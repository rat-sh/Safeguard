from fastapi import APIRouter, HTTPException
from app.models.schemas import SensorReading, DeviceStatus
from app.services import device_service

router = APIRouter()

@router.post("/data")
async def receive_device_data(data: SensorReading):
    """
    Receive sensor data from an IoT device.
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
