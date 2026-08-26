import logging
from app.models.schemas import SensorReading, DeviceStatus, AlertCreate
from app.services import ai_service, alert_service
from app.db.session import supabase_client
from datetime import datetime

logger = logging.getLogger(__name__)

def process_sensor_data(data: SensorReading) -> dict:
    """
    Process incoming sensor data.
    Saves to Supabase if available.
    Calls AI service for analysis and Alert service if needed.
    """
    # 1. Save sensor reading to Supabase (if configured)
    if supabase_client:
        try:
            reading_data = data.model_dump(mode='json')
            supabase_client.table("sensor_readings").insert(reading_data).execute()
            logger.info(f"Sensor reading for {data.device_id} saved to Supabase.")
        except Exception as e:
            logger.error(f"Failed to save sensor reading to Supabase: {e}")

    # 2. Analyze data with AI service
    analysis = ai_service.analyze_sensor_data(data)
    
    alert_result = None
    
    # 3. Check if an alert needs to be created
    if analysis.get("should_create_alert"):
        alert_data = AlertCreate(
            device_id=data.device_id,
            severity=analysis["severity"],
            message=analysis["message"]
        )
        alert = alert_service.create_alert(alert_data)
        alert_result = alert.model_dump(mode='json')

    # 4. Return comprehensive response
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
