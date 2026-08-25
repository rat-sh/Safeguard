import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HistorySummaryCards extends StatelessWidget {
  const HistorySummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Period Summary',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSummaryCard('Peak Level', '28.4%', 'LEL', AppTheme.critical, const Color(0xFFFEE2E2)),
            const SizedBox(width: 12),
            _buildSummaryCard('Avg Level', '13.4%', 'LEL', AppTheme.primary, const Color(0xFFCCFBF1)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSummaryCard('Total Alerts', '7', 'events', AppTheme.warning, const Color(0xFFFEF3C7)),
            const SizedBox(width: 12),
            _buildSummaryCard('Safe Hours', '91%', 'uptime', AppTheme.success, const Color(0xFFDCFCE7)),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, String unit, Color accentColor, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 8,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Container(
                  width: 4,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      TextSpan(
                        text: ' $unit',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
