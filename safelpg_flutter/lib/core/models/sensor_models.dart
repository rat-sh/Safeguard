/// Mirrors the backend SystemState enum (schemas.py)
enum SystemState { normal, warning, critical, power_cut }

/// Mirrors the backend AlertSeverity enum (schemas.py)
enum AlertSeverity { info, warning, critical }

/// Mirrors SensorReadingResponse from schemas.py
class SensorReading {
  final String id;
  final String deviceId;
  final double gasLevel;
  final double? temperature;
  final double? humidity;
  final bool humanPresence;
  final bool regulatorState;
  final bool? doorOpen;
  final bool? relayActive;
  final int? batteryLevel;
  final SystemState systemState;
  final DateTime timestamp;

  const SensorReading({
    required this.id,
    required this.deviceId,
    required this.gasLevel,
    this.temperature,
    this.humidity,
    required this.humanPresence,
    required this.regulatorState,
    this.doorOpen,
    this.relayActive,
    this.batteryLevel,
    required this.systemState,
    required this.timestamp,
  });

  factory SensorReading.fromMap(Map<String, dynamic> map) {
    return SensorReading(
      id: map['id'] as String,
      deviceId: map['device_id'] as String,
      gasLevel: (map['gas_level'] as num).toDouble(),
      temperature: map['temperature'] != null
          ? (map['temperature'] as num).toDouble()
          : null,
      humidity: map['humidity'] != null
          ? (map['humidity'] as num).toDouble()
          : null,
      humanPresence: map['human_presence'] as bool,
      regulatorState: map['regulator_state'] as bool,
      doorOpen: map['door_open'] as bool?,
      relayActive: map['relay_active'] as bool?,
      batteryLevel: map['battery_level'] as int?,
      systemState: _parseSystemState(map['system_state'] as String? ?? 'normal'),
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  static SystemState _parseSystemState(String value) {
    switch (value) {
      case 'warning':
        return SystemState.warning;
      case 'critical':
        return SystemState.critical;
      case 'power_cut':
        return SystemState.power_cut;
      default:
        return SystemState.normal;
    }
  }
}

/// Mirrors AlertResponse from schemas.py
class AlertModel {
  final String id;
  final String deviceId;
  final AlertSeverity severity;
  final String message;
  final double? leakProbability;
  final List<String> contributingFactors;
  final DateTime createdAt;
  final bool isResolved;

  const AlertModel({
    required this.id,
    required this.deviceId,
    required this.severity,
    required this.message,
    this.leakProbability,
    required this.contributingFactors,
    required this.createdAt,
    required this.isResolved,
  });

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] as String,
      deviceId: map['device_id'] as String,
      severity: _parseSeverity(map['severity'] as String? ?? 'info'),
      message: map['message'] as String,
      leakProbability: map['leak_probability'] != null
          ? (map['leak_probability'] as num).toDouble()
          : null,
      contributingFactors:
          (map['contributing_factors'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(map['created_at'] as String),
      isResolved: map['is_resolved'] as bool,
    );
  }

  static AlertSeverity _parseSeverity(String value) {
    switch (value) {
      case 'warning':
        return AlertSeverity.warning;
      case 'critical':
        return AlertSeverity.critical;
      default:
        return AlertSeverity.info;
    }
  }
}
