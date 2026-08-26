from fastapi import APIRouter, HTTPException
from typing import List
from app.models.schemas import AlertResponse
from app.services import alert_service

router = APIRouter()

@router.get("/", response_model=List[AlertResponse])
async def list_alerts():
    """
    Get all system alerts, newest first.
    """
    return alert_service.get_all_alerts()

@router.get("/{alert_id}", response_model=AlertResponse)
async def get_alert(alert_id: str):
    """
    Get a specific alert by its ID.
    """
    alert = alert_service.get_alert_by_id(alert_id)
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return alert
