import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/sensor_providers.dart';
import '../../core/models/sensor_models.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/gas_level_card.dart';
import 'widgets/system_state_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_activity_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // Device ID is taken from env at compile time (same pattern as config).
  // In a full auth flow, this would come from the logged-in user's session.
  static const String _deviceId = String.fromEnvironment(
    'DEVICE_ID',
    defaultValue: 'default-device',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingAsync = ref.watch(latestReadingProvider(_deviceId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(),
            Expanded(
              child: readingAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Connection error: $e',
                    style: const TextStyle(color: AppTheme.critical),
                  ),
                ),
                data: (reading) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GasLevelCard(reading: reading),
                      const SizedBox(height: 12),
                      SystemStateCard(reading: reading),
                      const SizedBox(height: 12),
                      const QuickActions(),
                      const SizedBox(height: 12),
                      RecentActivityCard(deviceId: _deviceId),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
