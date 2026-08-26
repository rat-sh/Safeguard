"""
AI/ML Analysis Service
======================
Analyses incoming ESP32 sensor readings and produces a structured
AIAnalysisResult covering:
  1. Threshold-based severity classification
  2. Gas spike / anomaly detection (rolling window)
  3. Multi-factor leak probability scoring (0.0 – 1.0)
  4. LPG cylinder usage / remaining level estimation
"""

import logging
from collections import deque
from typing import Deque, Dict, List, Tuple
from app.models.schemas import (
    SensorReading,
    AIAnalysisResult,
    AlertSeverity,
    SystemState,
)

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Thresholds (LEL %)
# ---------------------------------------------------------------------------
THRESHOLD_WARNING = 10.0     # 10 % LEL — elevated, monitor
THRESHOLD_CRITICAL = 25.0    # 25 % LEL — dangerous, act now

# Anomaly: spike factor — if latest reading is this many times the rolling avg
SPIKE_FACTOR = 2.5           # 2.5× the rolling mean = anomaly
ROLLING_WINDOW = 10          # last N readings used for baseline

# Usage estimation: track cumulative exposure above idle baseline
IDLE_GAS_BASELINE = 2.0      # LEL% considered background / idle

# ---------------------------------------------------------------------------
# Per-device rolling history (in-memory, survives across requests per process)
# ---------------------------------------------------------------------------
_gas_history: Dict[str, Deque[float]] = {}


def _get_history(device_id: str) -> Deque[float]:
    """Return (and lazily create) the rolling gas-level deque for a device."""
    if device_id not in _gas_history:
        _gas_history[device_id] = deque(maxlen=ROLLING_WINDOW)
    return _gas_history[device_id]


# ---------------------------------------------------------------------------
# 1. Threshold Classification
# ---------------------------------------------------------------------------

def _classify_threshold(gas: float) -> AlertSeverity:
    if gas >= THRESHOLD_CRITICAL:
        return AlertSeverity.CRITICAL
    if gas >= THRESHOLD_WARNING:
        return AlertSeverity.WARNING
    return AlertSeverity.INFO


# ---------------------------------------------------------------------------
# 2. Anomaly Detection (Spike Detection)
# ---------------------------------------------------------------------------

def _detect_anomaly(device_id: str, gas: float) -> Tuple[bool, float]:
    """
    Compare current gas reading against the rolling average.
    Returns (anomaly_detected, rolling_mean).
    """
    history = _get_history(device_id)

    if len(history) < 3:
        # Not enough data to establish baseline yet
        return False, gas

    rolling_mean = sum(history) / len(history)

    # Avoid division-by-zero when baseline is near zero
    if rolling_mean < 0.5:
        anomaly = gas > THRESHOLD_WARNING
    else:
        anomaly = gas >= (rolling_mean * SPIKE_FACTOR)

    return anomaly, rolling_mean


# ---------------------------------------------------------------------------
# 3. Leak Probability Scoring
# ---------------------------------------------------------------------------

def _compute_leak_probability(
    data: SensorReading,
    severity: AlertSeverity,
    anomaly_detected: bool,
    contributing_factors: List[str],
) -> float:
    """
    Combine multiple sensor signals into a single probability score [0, 1].
    Each factor adds a weighted contribution.
    """
    score = 0.0

    # Gas level contribution (0 – 0.45)
    gas_contrib = min(data.gas_level / 100.0, 1.0) * 0.45
    score += gas_contrib
    if data.gas_level > 0:
        contributing_factors.append(f"Gas level at {data.gas_level:.1f}% LEL")

    # Anomaly spike (+0.15)
    if anomaly_detected:
        score += 0.15
        contributing_factors.append("Sudden gas spike detected (anomaly)")

    # Regulator is OFF but gas is still rising (+0.15)
    if not data.regulator_state and data.gas_level > IDLE_GAS_BASELINE:
        score += 0.15
        contributing_factors.append("Gas elevated while regulator is OFF")

    # Human presence amplifies risk (+0.10)
    if data.human_presence:
        score += 0.10
        contributing_factors.append("Human presence detected in area")

    # Door/window open = ventilation available, slightly reduces risk (-0.05)
    if data.door_open is True:
        score -= 0.05
        contributing_factors.append("Door/window open (ventilation present)")

    # Relay already triggered = system is responding (+0.05)
    if data.relay_active:
        score += 0.05
        contributing_factors.append("Auto shut-off relay is active")

    # GSM signal weak — escalation may fail (+0.05)
    if data.gsm_signal_strength is not None and data.gsm_signal_strength < 5:
        score += 0.05
        contributing_factors.append("Weak GSM signal — SMS escalation may fail")

    # Power-cut state — can't rely on electric safety (+0.05)
    if data.system_state == SystemState.POWER_CUT:
        score += 0.05
        contributing_factors.append("System is in power-cut state")

    return round(max(0.0, min(score, 1.0)), 3)


# ---------------------------------------------------------------------------
# 4. Usage / Remaining Gas Estimation
# ---------------------------------------------------------------------------

def _estimate_gas_remaining(device_id: str) -> float | None:
    """
    Estimate remaining cylinder gas as a percentage based on how often
    gas-above-idle readings have been logged over the rolling window.

    Formula: remaining = 100 - (exposure_pct * 100)
    where exposure_pct = fraction of recent readings that are above idle baseline.

    This is a simplified heuristic; replace with a proper calorific-value
    model once usage timestamps are stored persistently.
    """
    history = _get_history(device_id)
    if len(history) < ROLLING_WINDOW:
        return None  # Not enough data yet

    above_idle = sum(1 for g in history if g > IDLE_GAS_BASELINE)
    exposure_pct = above_idle / len(history)
    estimated_remaining = round(100.0 - (exposure_pct * 100.0), 1)
    return max(0.0, estimated_remaining)


# ---------------------------------------------------------------------------
# 5. Message Builder
# ---------------------------------------------------------------------------

def _build_message(
    severity: AlertSeverity,
    data: SensorReading,
    anomaly_detected: bool,
    leak_prob: float,
) -> str:
    gas = data.gas_level
    presence = data.human_presence
    reg_off = not data.regulator_state

    if severity == AlertSeverity.CRITICAL:
        base = f"🚨 CRITICAL: Gas at {gas:.1f}% LEL"
        if reg_off:
            return f"{base} — regulator is OFF. Possible severe leak. Evacuate and call for help immediately."
        if presence:
            return f"{base} with human presence detected. Evacuate immediately and ventilate the area."
        return f"{base}. Immediate action required. Ventilate and evacuate."

    if severity == AlertSeverity.WARNING:
        base = f"⚠️ WARNING: Gas at {gas:.1f}% LEL"
        if anomaly_detected:
            return f"{base} — sudden spike detected. Check connections and regulator."
        if reg_off:
            return f"{base} while regulator is OFF. Check for potential leak."
        if presence:
            return f"{base} with human presence. Please ventilate the area."
        return f"{base}. Monitor closely and ensure good ventilation."

    # INFO
    if anomaly_detected:
        return f"ℹ️ Minor gas variation detected ({gas:.1f}% LEL). Monitoring in progress."
    return f"✅ Gas levels normal ({gas:.1f}% LEL). System operating safely."


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def analyze_sensor_data(data: SensorReading) -> AIAnalysisResult:
    """
    Main entry point. Accepts a SensorReading, runs all analysis stages,
    updates the rolling history, and returns a complete AIAnalysisResult.
    """
    device_id = data.device_id
    gas = data.gas_level
    contributing_factors: List[str] = []

    # Stage 1: Anomaly detection (before updating history)
    anomaly_detected, rolling_mean = _detect_anomaly(device_id, gas)
    logger.debug(
        f"[{device_id}] gas={gas:.2f}% LEL | rolling_mean={rolling_mean:.2f} | anomaly={anomaly_detected}"
    )

    # Stage 2: Update rolling history
    _get_history(device_id).append(gas)

    # Stage 3: Threshold severity
    severity = _classify_threshold(gas)

    # Upgrade severity if anomaly is detected at borderline levels
    if anomaly_detected and severity == AlertSeverity.INFO:
        severity = AlertSeverity.WARNING

    # Stage 4: Leak probability
    leak_probability = _compute_leak_probability(
        data, severity, anomaly_detected, contributing_factors
    )

    # Stage 5: Usage estimation
    estimated_remaining = _estimate_gas_remaining(device_id)

    # Stage 6: Human-readable message
    message = _build_message(severity, data, anomaly_detected, leak_probability)

    # Determine whether to persist an alert
    should_create_alert = severity in (AlertSeverity.WARNING, AlertSeverity.CRITICAL)

    result = AIAnalysisResult(
        severity=severity,
        message=message,
        should_create_alert=should_create_alert,
        leak_probability=leak_probability,
        anomaly_detected=anomaly_detected,
        estimated_gas_remaining_pct=estimated_remaining,
        contributing_factors=contributing_factors,
    )

    logger.info(
        f"[{device_id}] AI result — severity={severity.value} "
        f"leak_prob={leak_probability} anomaly={anomaly_detected} "
        f"alert={should_create_alert}"
    )

    return result
