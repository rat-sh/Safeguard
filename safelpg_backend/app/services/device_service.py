"""
Device Service
==============
Handles all device-level business logic:
  - Ingesting sensor data from the ESP32
  - Orchestrating AI analysis
  - Persisting readings to Supabase
  - Retrieving device status and latest readings
"""

import logging
from datetime import datetime
from typing import Optional, List

from app.models.schemas import (
    SensorReading,
    SensorReadingResponse,
    DeviceStatus,
    AlertCreate,
    AIAnalysisResult,
    SystemState,
)
from app.services import ai_service, alert_service
from app.db.session import supabase_client

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# In-memory fallback store (used when Supabase is unavailable)
# ---------------------------------------------------------------------------
_latest_data_db: dict[str, SensorReading] = {}
_readings_history_db: dict[str, list[SensorReading]] = {}
_MAX_FALLBACK_HISTORY = 200  # cap in-memory per device


# ---------------------------------------------------------------------------
# Helper: persist a reading to Supabase
# ---------------------------------------------------------------------------

def _save_reading_to_supabase(data: SensorReading) -> bool:
    """Attempt to insert a sensor reading into Supabase. Returns True on success."""
    if not supabase_client:
        return False
    try:
        payload = data.model_dump(mode="json")
        supabase_client.table("sensor_readings").insert(payload).execute()
        logger.info(f"[{data.device_id}] Sensor reading saved to Supabase.")
        return True
    except Exception as e:
        logger.error(f"[{data.device_id}] Failed to save reading to Supabase: {e}")
        return False


def _save_reading_to_fallback(data: SensorReading) -> None:
    """Store reading in the in-memory fallback history."""
    _latest_data_db[data.device_id] = data
    history = _readings_history_db.setdefault(data.device_id, [])
    history.append(data)
    # Trim to cap
    if len(history) > _MAX_FALLBACK_HISTORY:
        _readings_history_db[data.device_id] = history[-_MAX_FALLBACK_HISTORY:]


# ---------------------------------------------------------------------------
# Core: Process Incoming Sensor Data
# ---------------------------------------------------------------------------

def process_sensor_data(data: SensorReading) -> dict:
    """
    Full pipeline for an incoming ESP32 payload:
      1. Cache in memory (always)
      2. Persist to Supabase (if available), fallback otherwise
      3. Run AI analysis
      4. Create alert if warranted
      5. Return a comprehensive JSON response
    """
    # Step 0: Always cache latest for fast status lookups
    _latest_data_db[data.device_id] = data

    # Step 1: Persist reading
    saved_to_db = _save_reading_to_supabase(data)
    if not saved_to_db:
        _save_reading_to_fallback(data)

    # Step 2: AI Analysis
    analysis: AIAnalysisResult = ai_service.analyze_sensor_data(data)

    # Step 3: Create alert if needed
    alert_result = None
    if analysis.should_create_alert:
        alert_data = AlertCreate(
            device_id=data.device_id,
            severity=analysis.severity,
            message=analysis.message,
            leak_probability=analysis.leak_probability,
            contributing_factors=analysis.contributing_factors,
        )
        alert = alert_service.create_alert(alert_data)
        alert_result = alert.model_dump(mode="json")
        logger.info(f"[{data.device_id}] Alert created: {alert.id} ({alert.severity.value})")

    # Step 4: Build response
    return {
        "status": "success",
        "message": f"Data received for device {data.device_id}",
        "received_at": datetime.now().isoformat(),
        "analysis": {
            "severity": analysis.severity.value,
            "message": analysis.message,
            "leak_probability": analysis.leak_probability,
            "anomaly_detected": analysis.anomaly_detected,
            "estimated_gas_remaining_pct": analysis.estimated_gas_remaining_pct,
            "contributing_factors": analysis.contributing_factors,
        },
        "alert_created": alert_result,
    }


# ---------------------------------------------------------------------------
# Device Status
# ---------------------------------------------------------------------------

def get_device_status(device_id: str) -> DeviceStatus:
    """
    Derive current device status from the latest sensor reading.
    A device is considered online if its last reading arrived within 5 minutes.
    """
    latest = get_latest_sensor_data(device_id)

    if not latest:
        return DeviceStatus(
            device_id=device_id,
            is_online=False,
            system_state=SystemState.NORMAL,
            battery_level=None,
            last_heartbeat=datetime.min,
            last_gas_level=None,
            relay_active=None,
            gsm_signal_strength=None,
        )

    time_since_last = datetime.now() - latest.timestamp
    is_online = time_since_last.total_seconds() < 300  # 5 minutes

    return DeviceStatus(
        device_id=device_id,
        is_online=is_online,
        system_state=latest.system_state,
        battery_level=latest.battery_level,
        last_heartbeat=latest.timestamp,
        last_gas_level=latest.gas_level,
        relay_active=latest.relay_active,
        gsm_signal_strength=latest.gsm_signal_strength,
    )


# ---------------------------------------------------------------------------
# Latest Sensor Data
# ---------------------------------------------------------------------------

def get_latest_sensor_data(device_id: str) -> Optional[SensorReading]:
    """
    Return the most recent sensor reading for a device.
    Tries Supabase first, falls back to in-memory cache.
    """
    if supabase_client:
        try:
            response = (
                supabase_client
                .table("sensor_readings")
                .select("*")
                .eq("device_id", device_id)
                .order("timestamp", desc=True)
                .limit(1)
                .execute()
            )
            if response.data:
                return SensorReading(**response.data[0])
        except Exception as e:
            logger.error(f"[{device_id}] Failed to fetch latest data from Supabase: {e}")

    return _latest_data_db.get(device_id)


# ---------------------------------------------------------------------------
# Historical Sensor Data
# ---------------------------------------------------------------------------

def get_historical_data(
    device_id: str,
    limit: int = 100,
    offset: int = 0,
) -> tuple[List[SensorReadingResponse], int]:
    """
    Retrieve paginated historical readings for a device.
    Returns (list_of_readings, total_count).
    """
    if supabase_client:
        try:
            # Count query
            count_response = (
                supabase_client
                .table("sensor_readings")
                .select("id", count="exact")
                .eq("device_id", device_id)
                .execute()
            )
            total = count_response.count or 0

            # Data query
            data_response = (
                supabase_client
                .table("sensor_readings")
                .select("*")
                .eq("device_id", device_id)
                .order("timestamp", desc=True)
                .range(offset, offset + limit - 1)
                .execute()
            )
            readings = [SensorReadingResponse(**row) for row in data_response.data]
            return readings, total
        except Exception as e:
            logger.error(f"[{device_id}] Failed to fetch historical data from Supabase: {e}")

    # Fallback: in-memory history
    history = _readings_history_db.get(device_id, [])
    total = len(history)
    sliced = history[-(offset + limit): len(history) - offset if offset > 0 else None]
    sliced.reverse()
    readings = [
        SensorReadingResponse(
            id=f"mem-{i}",
            device_id=r.device_id,
            gas_level=r.gas_level,
            temperature=r.temperature,
            humidity=r.humidity,
            human_presence=r.human_presence,
            regulator_state=r.regulator_state,
            door_open=r.door_open,
            relay_active=r.relay_active,
            battery_level=r.battery_level,
            system_state=r.system_state,
            timestamp=r.timestamp,
        )
        for i, r in enumerate(sliced)
    ]
    return readings, total
