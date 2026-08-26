"""
Alerts Routes
=============
CRUD endpoints for system alerts triggered by AI analysis.
"""

from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional
from app.models.schemas import AlertResponse, AlertSeverity
from app.services import alert_service

router = APIRouter()


@router.get("/", response_model=List[AlertResponse])
async def list_alerts(
    device_id: Optional[str] = Query(None, description="Filter alerts by device ID"),
    severity: Optional[AlertSeverity] = Query(None, description="Filter by severity (info/warning/critical)"),
    is_resolved: Optional[bool] = Query(None, description="Filter by resolved status"),
    limit: int = Query(50, ge=1, le=100, description="Maximum number of alerts to return"),
):
    """
    Get system alerts, newest first.
    Supports filtering by device_id, severity level, and resolved status.
    """
    return alert_service.get_all_alerts(
        device_id=device_id,
        severity=severity,
        is_resolved=is_resolved,
        limit=limit,
    )


@router.get("/{alert_id}", response_model=AlertResponse)
async def get_alert(alert_id: str):
    """Get a specific alert by its UUID."""
    alert = alert_service.get_alert_by_id(alert_id)
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return alert


@router.patch("/{alert_id}/resolve", response_model=AlertResponse)
async def resolve_alert(alert_id: str):
    """
    Mark an alert as resolved (is_resolved=True).
    Used by the Flutter app when the user dismisses or acknowledges an alert.
    """
    alert = alert_service.resolve_alert(alert_id)
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return alert
