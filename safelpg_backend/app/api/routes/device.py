"""
Device Routes
=============
Endpoints for ESP32 device data ingestion and device status queries.
"""

from fastapi import APIRouter, HTTPException, Depends
from app.models.schemas import SensorReading, DeviceStatus
from app.services import device_service
from app.core.security import get_api_key

router = APIRouter()


@router.post("/data")
async def receive_device_data(
    data: SensorReading,
    api_key: str = Depends(get_api_key),
):
    """
    Receive sensor data from an ESP32 IoT device.

    **Requires** `X-Device-API-Key` header for authentication.

    Returns the AI analysis result and any alert that was created.
    The ESP32 can use the `analysis.severity` field to decide whether
    to trigger its local buzzer/relay independently.
    """
    result = device_service.process_sensor_data(data)
    return result


@router.get("/{device_id}/status", response_model=DeviceStatus)
async def get_device_status(device_id: str):
    """
    Get the current health and connectivity status of a specific device.
    Returns is_online, system_state, battery level, relay state, and last heartbeat.
    """
    try:
        status = device_service.get_device_status(device_id)
        return status
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{device_id}/latest-data", response_model=SensorReading)
async def get_latest_data(device_id: str):
    """
    Get the most recent sensor reading for a specific device.
    Used by the Flutter Live Dashboard to display current readings.
    """
    data = device_service.get_latest_sensor_data(device_id)
    if not data:
        raise HTTPException(status_code=404, detail="No data found for device")
    return data
