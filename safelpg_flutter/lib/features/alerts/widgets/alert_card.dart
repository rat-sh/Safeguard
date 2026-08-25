import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AlertCard extends StatelessWidget {
  final String severity; // critical, warning, info
  final String title;
  final String description;
  final String time;
  final VoidCallback onTap;

  const AlertCard({
    super.key,
    required this.severity,
    required this.title,
    required this.description,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;

    if (severity == 'critical') {
      color = AppTheme.critical;
      bgColor = const Color(0xFFFEE2E2);
    } else if (severity == 'warning') {
      color = AppTheme.warning;
      bgColor = const Color(0xFFFEF3C7);
    } else {
      color = AppTheme.primary;
      bgColor = const Color(0xFFCCFBF1);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F0F172A),
              offset: Offset(0, 1),
              blurRadius: 8,
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                color: color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              severity.toUpperCase(),
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.disabled,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Mark as False',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Silence 15 min',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
