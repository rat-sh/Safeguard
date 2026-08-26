"""
Sensor History Routes
=====================
GET endpoints for retrieving historical sensor data for Flutter graphs.
"""

from fastapi import APIRouter, HTTPException, Query
from app.models.schemas import HistoricalDataResponse
from app.services import device_service

router = APIRouter()


@router.get("/{device_id}/history", response_model=HistoricalDataResponse)
async def get_sensor_history(
    device_id: str,
    limit: int = Query(100, ge=1, le=500, description="Number of readings to return"),
    offset: int = Query(0, ge=0, description="Number of readings to skip (for pagination)"),
):
    """
    Retrieve paginated historical sensor readings for a device.
    Ordered by newest first. Used by Flutter for graph rendering.
    """
    readings, total = device_service.get_historical_data(
        device_id=device_id,
        limit=limit,
        offset=offset,
    )
    return HistoricalDataResponse(
        device_id=device_id,
        total=total,
        readings=readings,
    )
