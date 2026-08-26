import uuid
from datetime import datetime
from typing import List, Optional
from app.models.schemas import AlertCreate, AlertResponse

# In-memory store for alerts
_alerts_db: dict[str, AlertResponse] = {}

def create_alert(alert_data: AlertCreate) -> AlertResponse:
    """
    Create a new alert based on AI analysis.
    Stores it in the in-memory database.
    """
    alert = AlertResponse(
        id=str(uuid.uuid4()),
        device_id=alert_data.device_id,
        severity=alert_data.severity,
        message=alert_data.message,
        created_at=datetime.now(),
        is_resolved=False
    )
    _alerts_db[alert.id] = alert
    return alert

def get_all_alerts() -> List[AlertResponse]:
    """
    Retrieve all alerts from the in-memory store.
    """
    # Return sorted by created_at descending (newest first)
    return sorted(list(_alerts_db.values()), key=lambda a: a.created_at, reverse=True)

def get_alert_by_id(alert_id: str) -> Optional[AlertResponse]:
    """
    Retrieve a specific alert by ID.
    """
    return _alerts_db.get(alert_id)
