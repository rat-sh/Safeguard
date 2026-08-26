import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/sensor_models.dart';
import '../../core/providers/sensor_providers.dart';
import 'widgets/alert_card.dart';

class AlertCentreScreen extends ConsumerStatefulWidget {
  const AlertCentreScreen({super.key});

  static const String _deviceId = String.fromEnvironment(
    'DEVICE_ID',
    defaultValue: 'default-device',
  );

  @override
  ConsumerState<AlertCentreScreen> createState() => _AlertCentreScreenState();
}

class _AlertCentreScreenState extends ConsumerState<AlertCentreScreen> {
  String _activeFilter = 'All';
  final _filters = ['All', 'Critical', 'Warning', 'Info'];

  List<AlertModel> _applyFilter(List<AlertModel> alerts) {
    if (_activeFilter == 'All') return alerts;
    return alerts
        .where((a) => a.severity.name == _activeFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final alertsAsync =
        ref.watch(activeAlertsProvider(AlertCentreScreen._deviceId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: AppTheme.surface,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alert Centre',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  alertsAsync.when(
                    loading: () => const Text('Loading...'),
                    error: (_, __) => const Text('—'),
                    data: (alerts) => Text(
                      '${_applyFilter(alerts).length} active alerts',
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            // Filter chips
            Container(
              color: AppTheme.surface,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final isActive = _activeFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _activeFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.primary
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isActive
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.border),
            // Alert list
            Expanded(
              child: alertsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Error loading alerts: $e',
                    style: const TextStyle(color: AppTheme.critical),
                  ),
                ),
                data: (alerts) {
                  final filtered = _applyFilter(alerts);
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        'No alerts in this category',
                        style: TextStyle(
                            fontSize: 14, color: AppTheme.textSecondary),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final alert = filtered[index];
                      return AlertCard(
                        severity: alert.severity.name,
                        title: _alertTitle(alert.severity),
                        description: alert.message,
                        time: _formatTime(alert.createdAt),
                        onTap: () => context.go('/alerts/detail'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _alertTitle(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return 'Critical Alert';
      case AlertSeverity.warning:
        return 'Warning';
      default:
        return 'Info';
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
