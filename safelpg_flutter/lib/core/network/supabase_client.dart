import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../models/sensor_models.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  SupabaseClient get client => Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // Real-time streams (Dashboard)
  // ---------------------------------------------------------------------------

  Stream<List<Map<String, dynamic>>> getDeviceReadingsStream(String deviceId) {
    return client
        .from('sensor_readings')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .order('timestamp', ascending: false);
  }

  Stream<List<Map<String, dynamic>>> getAlertsStream(String deviceId) {
    return client
        .from('alerts')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .eq('is_resolved', false)
        .order('created_at', ascending: false);
  }

  // ---------------------------------------------------------------------------
  // Historical queries (History screen)
  // ---------------------------------------------------------------------------

  /// Returns sensor readings for [deviceId] within the given [period].
  /// [period] is one of: '24H', '7D', '30D', '90D'
  Future<List<SensorReading>> getHistoricalReadings(
      String deviceId, String period) async {
    final since = _periodToDateTime(period);
    final response = await client
        .from('sensor_readings')
        .select()
        .eq('device_id', deviceId)
        .gte('timestamp', since.toIso8601String())
        .order('timestamp', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(SensorReading.fromMap)
        .toList();
  }

  /// Returns all alerts (resolved + unresolved) for [deviceId] within [period].
  Future<List<AlertModel>> getHistoricalAlerts(
      String deviceId, String period) async {
    final since = _periodToDateTime(period);
    final response = await client
        .from('alerts')
        .select()
        .eq('device_id', deviceId)
        .gte('created_at', since.toIso8601String())
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(AlertModel.fromMap)
        .toList();
  }

  DateTime _periodToDateTime(String period) {
    final now = DateTime.now().toUtc();
    switch (period) {
      case '24H':
        return now.subtract(const Duration(hours: 24));
      case '30D':
        return now.subtract(const Duration(days: 30));
      case '90D':
        return now.subtract(const Duration(days: 90));
      case '7D':
      default:
        return now.subtract(const Duration(days: 7));
    }
  }
}
