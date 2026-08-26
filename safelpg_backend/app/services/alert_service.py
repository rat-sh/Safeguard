import uuid
import logging
from datetime import datetime
from typing import List, Optional
from app.models.schemas import AlertCreate, AlertResponse
from app.db.session import supabase_client

logger = logging.getLogger(__name__)

# In-memory store for alerts (fallback)
_alerts_db: dict[str, AlertResponse] = {}

def create_alert(alert_data: AlertCreate) -> AlertResponse:
    """
    Create a new alert based on AI analysis.
    Stores it in Supabase, falls back to in-memory database if Supabase is unavailable.
    """
    alert = AlertResponse(
        id=str(uuid.uuid4()),
        device_id=alert_data.device_id,
        severity=alert_data.severity,
        message=alert_data.message,
        created_at=datetime.now(),
        is_resolved=False
    )
    
    saved_to_db = False
    if supabase_client:
        try:
            data = alert.model_dump(mode='json')
            supabase_client.table("alerts").insert(data).execute()
            logger.info(f"Alert {alert.id} saved to Supabase.")
            saved_to_db = True
        except Exception as e:
            logger.error(f"Failed to save alert to Supabase: {e}")
            
    if not saved_to_db:
        _alerts_db[alert.id] = alert
        
    return alert

def get_all_alerts() -> List[AlertResponse]:
    """
    Retrieve all alerts from Supabase, fallback to in-memory store.
    """
    if supabase_client:
        try:
            response = supabase_client.table("alerts").select("*").order("created_at", desc=True).execute()
            return [AlertResponse(**item) for item in response.data]
        except Exception as e:
            logger.error(f"Failed to fetch alerts from Supabase: {e}")
            
    # Fallback
    return sorted(list(_alerts_db.values()), key=lambda a: a.created_at, reverse=True)

def get_alert_by_id(alert_id: str) -> Optional[AlertResponse]:
    """
    Retrieve a specific alert by ID from Supabase, fallback to in-memory store.
    """
    if supabase_client:
        try:
            response = supabase_client.table("alerts").select("*").eq("id", alert_id).execute()
            if response.data:
                return AlertResponse(**response.data[0])
        except Exception as e:
            logger.error(f"Failed to fetch alert {alert_id} from Supabase: {e}")
            
    return _alerts_db.get(alert_id)
