import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/sensor_models.dart';
import '../../../core/providers/sensor_providers.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

class RecentActivityCard extends ConsumerWidget {
  final String deviceId;

  const RecentActivityCard({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(activeAlertsProvider(deviceId));

    return SafeLPGCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          alertsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Text(
              'Failed to load activity',
              style: TextStyle(fontSize: 13, color: AppTheme.critical),
            ),
            data: (alerts) {
              if (alerts.isEmpty) {
                return const Text(
                  'No recent activity — all clear!',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                );
              }
              final recent = alerts.take(3).toList();
              return Column(
                children: [
                  for (var i = 0; i < recent.length; i++) ...[
                    _buildActivityItem(
                      recent[i].message,
                      _formatTime(recent[i].createdAt),
                      _severityColor(recent[i].severity),
                    ),
                    if (i < recent.length - 1)
                      const Divider(color: Color(0xFFF1F5F9), height: 16),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Color _severityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return AppTheme.critical;
      case AlertSeverity.warning:
        return AppTheme.warning;
      default:
        return AppTheme.primary;
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Widget _buildActivityItem(String text, String time, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
