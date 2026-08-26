from app.models.schemas import SensorReading

def analyze_sensor_data(data: SensorReading) -> dict:
    """
    Analyze sensor reading using basic HAT-LPG style rules.
    """
    gas = data.gas_level
    reg_off = not data.regulator_state
    presence = data.human_presence
    
    severity = "info"
    message = "Gas levels are normal."
    should_create_alert = False

    # Logic rules based on gas level, regulator state, and human presence
    if gas >= 25.0:
        severity = "critical"
        should_create_alert = True
        if reg_off:
            message = "High gas concentration detected with regulator OFF. Immediate action required."
        else:
            message = "High gas concentration detected. Consider turning off the regulator."
    elif gas >= 15.0:
        severity = "warning"
        should_create_alert = True
        if presence:
            message = "Elevated gas level detected. Human presence detected in area."
        else:
            message = "Elevated gas level detected."
            
    return {
        "severity": severity,
        "message": message,
        "should_create_alert": should_create_alert
    }
