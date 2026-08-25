import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AlertTimeline extends StatelessWidget {
  const AlertTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final timeline = [
      {'time': '10:42:03', 'action': 'Gas level threshold exceeded (25% LEL)', 'icon': Icons.warning_amber_rounded, 'color': AppTheme.critical},
      {'time': '10:42:05', 'action': 'Push notification dispatched to your device', 'icon': Icons.notifications_none, 'color': AppTheme.warning},
      {'time': '10:42:10', 'action': 'SMS alert sent to Riya Kumar (+91 98765 XXXXX)', 'icon': Icons.phone, 'color': AppTheme.warning},
      {'time': '10:42:25', 'action': 'Voice call attempted to emergency contact #1', 'icon': Icons.phone, 'color': AppTheme.primary},
      {'time': '10:42:40', 'action': 'Alert acknowledged — awaiting user response', 'icon': Icons.access_time, 'color': AppTheme.textSecondary},
    ];

    return Column(
      children: List.generate(timeline.length, (index) {
        final item = timeline[index];
        final isLast = index == timeline.length - 1;
        return _buildTimelineRow(
          time: item['time'] as String,
          action: item['action'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
          isLast: isLast,
        );
      }),
    );
  }

  Widget _buildTimelineRow({
    required String time,
    required String action,
    required IconData icon,
    required Color color,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 32, // Line height between dots
                color: AppTheme.border,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.disabled,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  action,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
