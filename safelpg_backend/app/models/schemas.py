from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class SensorReading(BaseModel):
    device_id: str
    gas_level: float
    temperature: Optional[float] = None
    regulator_state: bool
    human_presence: bool
    battery_level: Optional[int] = None
    timestamp: datetime = Field(default_factory=datetime.now)

class DeviceStatus(BaseModel):
    device_id: str
    is_online: bool
    battery_level: Optional[int] = None
    last_heartbeat: datetime

class AlertCreate(BaseModel):
    device_id: str
    severity: str
    message: str

class AlertResponse(BaseModel):
    id: str
    device_id: str
    severity: str
    message: str
    created_at: datetime
    is_resolved: bool
