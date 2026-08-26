from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum


# ---------------------------------------------------------------------------
# Enumerations
# ---------------------------------------------------------------------------

class SystemState(str, Enum):
    """Overall system state reported by the ESP32 or derived by the backend."""
    NORMAL = "normal"
    WARNING = "warning"
    CRITICAL = "critical"
    POWER_CUT = "power_cut"


class AlertSeverity(str, Enum):
    """Severity level for alerts."""
    INFO = "info"
    WARNING = "warning"
    CRITICAL = "critical"


# ---------------------------------------------------------------------------
# Inbound — ESP32 → FastAPI
# ---------------------------------------------------------------------------

class SensorReading(BaseModel):
    """
    Full sensor payload sent by the ESP32 over HTTP POST.
    Covers all attached hardware: MQ-2, PIR, HC-SR04, Reed Switch, SIM800L, Relay, Buzzer/LEDs.
    """
    device_id: str = Field(
        ..., min_length=1, max_length=100,
        description="Unique identifier for the ESP32 device"
    )

    # --- MQ-2 Gas Sensor ---
    gas_level: float = Field(
        ..., ge=0.0, le=100.0,
        description="Gas concentration as Lower Explosive Limit percentage (LEL %)"
    )
    gas_raw_adc: Optional[int] = Field(
        None, ge=0, le=4095,
        description="Raw ADC reading from MQ-2 (0–4095 on ESP32)"
    )

    # --- DHT / Temperature ---
    temperature: Optional[float] = Field(
        None, ge=-50.0, le=150.0,
        description="Ambient temperature in Celsius"
    )
    humidity: Optional[float] = Field(
        None, ge=0.0, le=100.0,
        description="Relative humidity percentage"
    )

    # --- PIR Motion Sensor ---
    human_presence: bool = Field(
        ...,
        description="True if PIR motion sensor detects human presence"
    )

    # --- HC-SR04 Ultrasonic ---
    distance_cm: Optional[float] = Field(
        None, ge=0.0, le=400.0,
        description="Distance reading from HC-SR04 in centimeters (e.g. cylinder proximity)"
    )

    # --- Magnetic Reed Switch ---
    regulator_state: bool = Field(
        ...,
        description="True if gas regulator is ON (reed switch closed), False if OFF"
    )
    door_open: Optional[bool] = Field(
        None,
        description="True if door/window reed switch detects open state"
    )

    # --- Relay & Output State ---
    relay_active: Optional[bool] = Field(
        None,
        description="True if the relay (auto shut-off) is currently triggered"
    )
    buzzer_active: Optional[bool] = Field(
        None,
        description="True if the local buzzer is sounding"
    )

    # --- Power & Connectivity ---
    battery_level: Optional[int] = Field(
        None, ge=0, le=100,
        description="Device battery percentage (0–100)"
    )
    gsm_signal_strength: Optional[int] = Field(
        None, ge=0, le=31,
        description="SIM800L signal strength (0–31, per AT+CSQ)"
    )
    system_state: SystemState = Field(
        default=SystemState.NORMAL,
        description="Current operational state of the ESP32 system"
    )

    # --- Timestamp ---
    timestamp: datetime = Field(
        default_factory=datetime.now,
        description="UTC timestamp of the reading"
    )


# ---------------------------------------------------------------------------
# AI / ML Analysis Result
# ---------------------------------------------------------------------------

class AIAnalysisResult(BaseModel):
    """
    Result returned by the AI service after analysing a SensorReading.
    Covers threshold alerts, anomaly detection, leak probability, and usage prediction.
    """
    severity: AlertSeverity = Field(
        ...,
        description="Computed severity level based on all sensor inputs"
    )
    message: str = Field(
        ..., min_length=1, max_length=1000,
        description="Human-readable explanation of the analysis"
    )
    should_create_alert: bool = Field(
        ...,
        description="Whether the backend should persist an alert for this reading"
    )

    # --- Detailed Scores ---
    leak_probability: float = Field(
        ..., ge=0.0, le=1.0,
        description="Probability of an active gas leak (0.0 = no risk, 1.0 = certain leak)"
    )
    anomaly_detected: bool = Field(
        ...,
        description="True if a sudden gas spike (anomaly) was detected vs baseline"
    )
    estimated_gas_remaining_pct: Optional[float] = Field(
        None, ge=0.0, le=100.0,
        description="Estimated remaining LPG cylinder level as a percentage"
    )
    contributing_factors: List[str] = Field(
        default_factory=list,
        description="List of sensor conditions that contributed to the risk score"
    )


# ---------------------------------------------------------------------------
# Device Status
# ---------------------------------------------------------------------------

class DeviceStatus(BaseModel):
    """Current health and connectivity status for a registered device."""
    device_id: str
    is_online: bool = Field(..., description="True if device sent data within the last 5 minutes")
    system_state: SystemState = Field(default=SystemState.NORMAL)
    battery_level: Optional[int] = Field(None, ge=0, le=100)
    last_heartbeat: datetime
    last_gas_level: Optional[float] = Field(None, ge=0.0, le=100.0)
    relay_active: Optional[bool] = None
    gsm_signal_strength: Optional[int] = Field(None, ge=0, le=31)


# ---------------------------------------------------------------------------
# Alerts
# ---------------------------------------------------------------------------

class AlertCreate(BaseModel):
    """Payload used internally to create a new alert."""
    device_id: str = Field(..., min_length=1, max_length=100)
    severity: AlertSeverity
    message: str = Field(..., min_length=1, max_length=1000)
    leak_probability: Optional[float] = Field(None, ge=0.0, le=1.0)
    contributing_factors: Optional[List[str]] = None


class AlertResponse(BaseModel):
    """Alert record returned to clients (Flutter App / API consumers)."""
    id: str
    device_id: str
    severity: AlertSeverity
    message: str
    leak_probability: Optional[float] = None
    contributing_factors: Optional[List[str]] = None
    created_at: datetime
    is_resolved: bool


# ---------------------------------------------------------------------------
# Historical / Query Responses
# ---------------------------------------------------------------------------

class SensorReadingResponse(BaseModel):
    """
    A stored sensor reading returned from Supabase for historical queries.
    Mirrors SensorReading but with a guaranteed DB-assigned id.
    """
    id: str
    device_id: str
    gas_level: float
    temperature: Optional[float] = None
    humidity: Optional[float] = None
    human_presence: bool
    regulator_state: bool
    door_open: Optional[bool] = None
    relay_active: Optional[bool] = None
    battery_level: Optional[int] = None
    system_state: SystemState = SystemState.NORMAL
    timestamp: datetime


class HistoricalDataResponse(BaseModel):
    """Wrapper for paginated historical sensor data."""
    device_id: str
    total: int
    readings: List[SensorReadingResponse]
