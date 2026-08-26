import logging
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from app.api.routes import health, device, sensor, alerts

# Basic logging configuration for the backend
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

app = FastAPI(title="SafeLPG API", version="1.0.0")

# Security Middleware: CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In production, restrict this to frontend domains
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global Exception Handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception on {request.url.path}: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error occurred."}
    )

# Routers
app.include_router(health.router, prefix="/api/v1", tags=["health"])
app.include_router(device.router, prefix="/api/v1/device", tags=["device"])
app.include_router(sensor.router, prefix="/api/v1/sensor", tags=["sensor"])
app.include_router(alerts.router, prefix="/api/v1/alerts", tags=["alerts"])
