import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/sensor_models.dart';
import '../../../core/providers/sensor_providers.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

class EventLogList extends ConsumerWidget {
  final String deviceId;
  final String period;

  const EventLogList({
    super.key,
    required this.deviceId,
    required this.period,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync =
        ref.watch(historicalAlertsProvider('$deviceId|$period'));

    return SafeLPGCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Event Log',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary),
              ),
              Text(
                'All events',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          alertsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text(
              'Failed to load events: $e',
              style: const TextStyle(
                  color: AppTheme.critical, fontSize: 12),
            ),
            data: (alerts) {
              if (alerts.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No events in this period',
                      style: TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ),
                );
              }

              // Group alerts by date label
              final groups = _groupByDate(alerts);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groups.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      ...entry.value.map(_buildEventItem),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, List<AlertModel>> _groupByDate(List<AlertModel> alerts) {
    final Map<String, List<AlertModel>> groups = {};
    final now = DateTime.now();
    for (final alert in alerts) {
      final diff = now.difference(alert.createdAt).inDays;
      String label;
      if (diff == 0) {
        label = 'Today';
      } else if (diff == 1) {
        label = 'Yesterday';
      } else {
        label =
            '${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year}';
      }
      groups.putIfAbsent(label, () => []).add(alert);
    }
    return groups;
  }

  Widget _buildEventItem(AlertModel alert) {
    Color dotColor;
    switch (alert.severity) {
      case AlertSeverity.critical:
        dotColor = AppTheme.critical;
        break;
      case AlertSeverity.warning:
        dotColor = AppTheme.warning;
        break;
      default:
        dotColor = AppTheme.primary;
    }

    final h = alert.createdAt.hour.toString().padLeft(2, '0');
    final m = alert.createdAt.minute.toString().padLeft(2, '0');
    final timeStr = '$h:$m';
    final title = _alertTitle(alert.severity);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: dotColor, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      timeStr,
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  alert.message,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
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
}
