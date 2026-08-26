import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';

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

  // Real-time stream for device readings
  Stream<List<Map<String, dynamic>>> getDeviceReadingsStream(String deviceId) {
    return client
        .from('sensor_readings')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .order('timestamp', ascending: false);
  }

  // Real-time stream for active alerts
  Stream<List<Map<String, dynamic>>> getAlertsStream(String deviceId) {
    return client
        .from('alerts')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .eq('is_resolved', false)
        .order('created_at', ascending: false);
  }
}
