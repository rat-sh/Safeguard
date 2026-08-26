from fastapi import APIRouter, HTTPException, Depends
from app.models.schemas import SensorReading, DeviceStatus
from app.services import device_service
from app.core.security import get_api_key

router = APIRouter()

@router.post("/data")
async def receive_device_data(data: SensorReading, api_key: str = Depends(get_api_key)):
    """
    Receive sensor data from an IoT device.
    Requires X-Device-API-Key header.
    """
    result = device_service.process_sensor_data(data)
    return result

@router.get("/{device_id}/status", response_model=DeviceStatus)
async def get_device_status(device_id: str):
    """
    Get the current status of a specific device.
    """
    try:
        status = device_service.get_device_status(device_id)
        return status
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
