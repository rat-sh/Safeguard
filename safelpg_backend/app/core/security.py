import os
from fastapi import Security, HTTPException, status
from fastapi.security.api_key import APIKeyHeader

API_KEY_NAME = "X-Device-API-Key"
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)

# Read the valid API key from environment, with a fallback for development
DEVICE_API_KEY = os.getenv("DEVICE_API_KEY", "default-dev-key")

async def get_api_key(api_key: str = Security(api_key_header)):
    """
    Validate the API key from the request header.
    Returns 401 Unauthorized if missing or invalid.
    """
    if api_key == DEVICE_API_KEY:
        return api_key
        
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or missing API Key",
    )
