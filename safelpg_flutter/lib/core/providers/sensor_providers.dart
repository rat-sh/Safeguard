import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/supabase_client.dart';
import '../models/sensor_models.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Streams the latest sensor reading from Supabase in real-time.
/// Used by the Dashboard to show live gas level, system state, etc.
final latestReadingProvider = StreamProvider.family<SensorReading?, String>(
  (ref, deviceId) {
    final svc = ref.read(supabaseServiceProvider);
    return svc
        .getDeviceReadingsStream(deviceId)
        .map((rows) => rows.isNotEmpty ? SensorReading.fromMap(rows.first) : null);
  },
);

/// Streams active (unresolved) alerts from Supabase in real-time.
/// Used by the Alert Centre screen.
final activeAlertsProvider = StreamProvider.family<List<AlertModel>, String>(
  (ref, deviceId) {
    final svc = ref.read(supabaseServiceProvider);
    return svc
        .getAlertsStream(deviceId)
        .map((rows) => rows.map(AlertModel.fromMap).toList());
  },
);
