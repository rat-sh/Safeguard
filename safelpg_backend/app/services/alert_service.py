import uuid
from datetime import datetime
from app.models.schemas import AlertCreate, AlertResponse

def create_alert(alert_data: AlertCreate) -> AlertResponse:
    """
    Create a new alert based on AI analysis.
    Currently returns a mock AlertResponse.
    """
    return AlertResponse(
        id=str(uuid.uuid4()),
        device_id=alert_data.device_id,
        severity=alert_data.severity,
        message=alert_data.message,
        created_at=datetime.now(),
        is_resolved=False
    )
