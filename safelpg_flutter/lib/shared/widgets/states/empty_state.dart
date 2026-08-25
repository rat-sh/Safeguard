import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum EmptyStateType { alerts, history, contacts, generic }

class EmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.type = EmptyStateType.generic,
    this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final config = _configFor(type);
    final displayTitle = title ?? config['title'] as String;
    final displaySubtitle = subtitle ?? config['subtitle'] as String;
    final icon = config['icon'] as IconData;
    final iconColor = config['color'] as Color;
    final bgColor = config['bg'] as Color;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: iconColor),
            ),
            const SizedBox(height: 24),
            Text(
              displayTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              displaySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _configFor(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.alerts:
        return {
          'icon': Icons.check_circle_outline,
          'color': AppTheme.success,
          'bg': const Color(0xFFDCFCE7),
          'title': 'All Clear',
          'subtitle': 'No active alerts right now.\nYour home is safe.',
        };
      case EmptyStateType.history:
        return {
          'icon': Icons.history,
          'color': AppTheme.primary,
          'bg': const Color(0xFFCCFBF1),
          'title': 'No History Yet',
          'subtitle': 'Events and readings will appear\nhere over time.',
        };
      case EmptyStateType.contacts:
        return {
          'icon': Icons.people_outline,
          'color': AppTheme.warning,
          'bg': const Color(0xFFFEF3C7),
          'title': 'No Emergency Contacts',
          'subtitle': 'Add someone who should be notified\nin case of an emergency.',
        };
      case EmptyStateType.generic:
        return {
          'icon': Icons.inbox_outlined,
          'color': AppTheme.textSecondary,
          'bg': const Color(0xFFF1F5F9),
          'title': 'Nothing Here',
          'subtitle': 'There is no data to display\nat the moment.',
        };
    }
  }
}
