from app.models.schemas import SensorReading, DeviceStatus, AlertCreate
from app.services import ai_service, alert_service
from datetime import datetime

def process_sensor_data(data: SensorReading) -> dict:
    """
    Process incoming sensor data.
    Calls AI service for analysis and Alert service if needed.
    """
    # 1. Analyze data with AI service
    analysis = ai_service.analyze_sensor_data(data)
    
    alert_result = None
    
    # 2. Check if an alert needs to be created
    if analysis.get("should_create_alert"):
        alert_data = AlertCreate(
            device_id=data.device_id,
            severity=analysis["severity"],
            message=analysis["message"]
        )
        alert = alert_service.create_alert(alert_data)
        alert_result = alert.model_dump() # Using Pydantic V2 model_dump()

    # 3. Return comprehensive response
    return {
        "status": "success",
        "message": f"Data received for device {data.device_id}",
        "received_at": datetime.now().isoformat(),
        "analysis": analysis,
        "alert_created": alert_result
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
