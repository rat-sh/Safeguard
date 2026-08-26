from app.models.schemas import SensorReading, DeviceStatus
from datetime import datetime

def process_sensor_data(data: SensorReading) -> dict:
    """
    Process incoming sensor data.
    Currently just returns a success message.
    """
    return {
        "status": "success",
        "message": f"Data received for device {data.device_id}",
        "received_at": datetime.now().isoformat()
    }

def get_device_status(device_id: str) -> DeviceStatus:
    """
    Retrieve current status for a given device.
    Currently returns a mock DeviceStatus.
    """
    return DeviceStatus(
        device_id=device_id,
        is_online=True,
        battery_level=76,
        last_heartbeat=datetime.now()
    )
