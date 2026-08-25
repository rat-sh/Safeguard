import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

class EventLogList extends StatelessWidget {
  const EventLogList({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      _EventData(
        date: 'Today',
        items: [
          _EventItem('10:42 AM', 'High Gas Concentration Alert', 'Gas peaked at 28.4% LEL — alert dispatched.', 'critical'),
          _EventItem('09:58 AM', 'Regulator Switched Off', 'Regulator turned OFF with presence detected.', 'warning'),
          _EventItem('07:00 AM', 'Daily Safety Scan', 'Morning automated check passed successfully.', 'info'),
        ],
      ),
      _EventData(
        date: 'Yesterday',
        items: [
          _EventItem('08:30 PM', 'Battery Low Warning', 'Device battery dropped below 20%.', 'warning'),
          _EventItem('06:15 PM', 'System Restored', 'Gas levels returned to safe range after ventilation.', 'info'),
          _EventItem('05:52 PM', 'Caution Threshold Crossed', 'Gas level briefly hit 17% LEL during cooking.', 'warning'),
        ],
      ),
    ];

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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
              Text(
                'Filter',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...events.map((group) => _buildEventGroup(group)).toList(),
        ],
      ),
    );
  }

  Widget _buildEventGroup(_EventData group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            group.date,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
        ),
        ...group.items.map((item) => _buildEventItem(item)).toList(),
      ],
    );
  }

  Widget _buildEventItem(_EventItem item) {
    Color dotColor;
    if (item.severity == 'critical') {
      dotColor = AppTheme.critical;
    } else if (item.severity == 'warning') {
      dotColor = AppTheme.warning;
    } else {
      dotColor = AppTheme.primary;
    }

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
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
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
                      item.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      item.time,
                      style: const TextStyle(fontSize: 11, color: AppTheme.disabled),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventData {
  final String date;
  final List<_EventItem> items;
  const _EventData({required this.date, required this.items});
}

class _EventItem {
  final String time;
  final String title;
  final String description;
  final String severity;
  const _EventItem(this.time, this.title, this.description, this.severity);
}
