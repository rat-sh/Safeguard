from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.routes import health, device, sensor, alerts

app = FastAPI(title="SafeLPG API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router, prefix="/api/v1", tags=["health"])
app.include_router(device.router, prefix="/api/v1/device", tags=["device"])
app.include_router(sensor.router, prefix="/api/v1/sensor", tags=["sensor"])
app.include_router(alerts.router, prefix="/api/v1/alerts", tags=["alerts"])
