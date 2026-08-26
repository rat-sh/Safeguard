from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class SensorReading(BaseModel):
    device_id: str = Field(..., min_length=1, max_length=100, description="Unique identifier for the device")
    gas_level: float = Field(..., ge=0.0, le=100.0, description="Gas concentration percentage (LEL)")
    temperature: Optional[float] = Field(None, ge=-50.0, le=150.0, description="Ambient temperature in Celsius")
    regulator_state: bool = Field(..., description="True if regulator is ON, False if OFF")
    human_presence: bool = Field(..., description="True if motion/human presence detected")
    battery_level: Optional[int] = Field(None, ge=0, le=100, description="Battery percentage")
    timestamp: datetime = Field(default_factory=datetime.now)

class DeviceStatus(BaseModel):
    device_id: str
    is_online: bool
    battery_level: Optional[int] = Field(None, ge=0, le=100)
    last_heartbeat: datetime

class AlertCreate(BaseModel):
    device_id: str = Field(..., min_length=1, max_length=100)
    severity: str = Field(..., pattern="^(info|warning|critical)$")
    message: str = Field(..., min_length=1, max_length=500)

class AlertResponse(BaseModel):
    id: str
    device_id: str
    severity: str
    message: str
    created_at: datetime
    is_resolved: bool
