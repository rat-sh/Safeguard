"""
Alert Service
=============
Handles creation and retrieval of system alerts.
Primary storage: Supabase `alerts` table.
Fallback: in-memory dictionary (survives the process lifetime only).
"""

import uuid
import logging
from datetime import datetime
from typing import List, Optional

from app.models.schemas import AlertCreate, AlertResponse, AlertSeverity
from app.db.session import supabase_client

logger = logging.getLogger(__name__)

# In-memory fallback store
_alerts_db: dict[str, AlertResponse] = {}


# ---------------------------------------------------------------------------
# Create Alert
# ---------------------------------------------------------------------------

def create_alert(alert_data: AlertCreate) -> AlertResponse:
    """
    Create a new alert from AI analysis output.
    Persists to Supabase; falls back to in-memory store if unavailable.
    """
    alert = AlertResponse(
        id=str(uuid.uuid4()),
        device_id=alert_data.device_id,
        severity=alert_data.severity,
        message=alert_data.message,
        leak_probability=alert_data.leak_probability,
        contributing_factors=alert_data.contributing_factors or [],
        created_at=datetime.now(),
        is_resolved=False,
    )

    saved_to_db = False

    if supabase_client:
        try:
            payload = alert.model_dump(mode="json")
            supabase_client.table("alerts").insert(payload).execute()
            logger.info(f"Alert {alert.id} saved to Supabase (severity={alert.severity.value}).")
            saved_to_db = True
        except Exception as e:
            logger.error(f"Failed to save alert {alert.id} to Supabase: {e}")

    if not saved_to_db:
        _alerts_db[alert.id] = alert
        logger.warning(f"Alert {alert.id} saved to in-memory fallback (Supabase unavailable).")

    return alert


# ---------------------------------------------------------------------------
# Retrieve Alerts
# ---------------------------------------------------------------------------

def get_all_alerts(
    device_id: Optional[str] = None,
    severity: Optional[AlertSeverity] = None,
    is_resolved: Optional[bool] = None,
    limit: int = 50,
) -> List[AlertResponse]:
    """
    Retrieve alerts ordered by newest first.
    Optional filters: device_id, severity, is_resolved.
    """
    if supabase_client:
        try:
            query = supabase_client.table("alerts").select("*")

            if device_id:
                query = query.eq("device_id", device_id)
            if severity:
                query = query.eq("severity", severity.value)
            if is_resolved is not None:
                query = query.eq("is_resolved", is_resolved)

            response = query.order("created_at", desc=True).limit(limit).execute()
            return [AlertResponse(**item) for item in response.data]
        except Exception as e:
            logger.error(f"Failed to fetch alerts from Supabase: {e}")

    # Fallback: in-memory
    alerts = list(_alerts_db.values())

    if device_id:
        alerts = [a for a in alerts if a.device_id == device_id]
    if severity:
        alerts = [a for a in alerts if a.severity == severity]
    if is_resolved is not None:
        alerts = [a for a in alerts if a.is_resolved == is_resolved]

    alerts.sort(key=lambda a: a.created_at, reverse=True)
    return alerts[:limit]


def get_alert_by_id(alert_id: str) -> Optional[AlertResponse]:
    """Retrieve a specific alert by its UUID."""
    if supabase_client:
        try:
            response = (
                supabase_client.table("alerts")
                .select("*")
                .eq("id", alert_id)
                .execute()
            )
            if response.data:
                return AlertResponse(**response.data[0])
        except Exception as e:
            logger.error(f"Failed to fetch alert {alert_id} from Supabase: {e}")

    return _alerts_db.get(alert_id)


# ---------------------------------------------------------------------------
# Resolve Alert
# ---------------------------------------------------------------------------

def resolve_alert(alert_id: str) -> Optional[AlertResponse]:
    """
    Mark an alert as resolved (is_resolved=True).
    Updates Supabase if available, else updates in-memory store.
    """
    if supabase_client:
        try:
            response = (
                supabase_client.table("alerts")
                .update({"is_resolved": True})
                .eq("id", alert_id)
                .execute()
            )
            if response.data:
                return AlertResponse(**response.data[0])
        except Exception as e:
            logger.error(f"Failed to resolve alert {alert_id} in Supabase: {e}")

    # Fallback: mutate in-memory
    alert = _alerts_db.get(alert_id)
    if alert:
        updated = alert.model_copy(update={"is_resolved": True})
        _alerts_db[alert_id] = updated
        return updated

    return None
