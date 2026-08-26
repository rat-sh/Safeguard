from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional
from app.models.schemas import AlertResponse
from app.services import alert_service

router = APIRouter()

@router.get("/", response_model=List[AlertResponse])
async def list_alerts(
    device_id: Optional[str] = Query(None, description="Filter alerts by device ID"),
    limit: int = Query(50, ge=1, le=100, description="Maximum number of alerts to return")
):
    """
    Get system alerts, newest first.
    Optionally filter by device ID and limit the number of results.
    """
    return alert_service.get_all_alerts(device_id=device_id, limit=limit)

@router.get("/{alert_id}", response_model=AlertResponse)
async def get_alert(alert_id: str):
    """
    Get a specific alert by its ID.
    """
    alert = alert_service.get_alert_by_id(alert_id)
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return alert
