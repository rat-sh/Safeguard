from app.models.schemas import SensorReading

# Detection Thresholds
THRESHOLD_CRITICAL = 25.0
THRESHOLD_WARNING = 15.0

def analyze_sensor_data(data: SensorReading) -> dict:
    """
    Analyze sensor reading using HAT-LPG style rules.
    """
    gas = data.gas_level
    reg_off = not data.regulator_state
    presence = data.human_presence
    
    severity = "info"
    message = "Gas levels are normal."
    should_create_alert = False

    # 1. Elevated Gas (Warning level)
    if gas >= THRESHOLD_WARNING and gas < THRESHOLD_CRITICAL:
        severity = "warning"
        should_create_alert = True
        
        # Modifier: Regulator is OFF but gas is elevated. 
        # This indicates a potential leak independent of the regulator.
        if reg_off:
            severity = "critical"
            message = "Elevated gas detected while regulator is OFF. Possible severe leak. Immediate check required."
        # Modifier: Human presence adds urgency.
        elif presence:
            message = "Elevated gas level detected. Human presence detected in area. Please ventilate immediately."
        else:
            message = "Elevated gas level detected. Monitor closely."

    # 2. High Gas (Critical level)
    elif gas >= THRESHOLD_CRITICAL:
        severity = "critical"
        should_create_alert = True
        
        if reg_off:
            message = "CRITICAL: High gas concentration detected while regulator is OFF. Evacuate and seek help."
        elif presence:
            message = "CRITICAL: High gas concentration detected with human presence! Evacuate immediately."
        else:
            message = "CRITICAL: High gas concentration detected. Immediate action required."

    return {
        "severity": severity,
        "message": message,
        "should_create_alert": should_create_alert
    }
