import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/sensor_providers.dart';

class HistorySummaryCards extends ConsumerWidget {
  final String deviceId;
  final String period;

  const HistorySummaryCards({
    super.key,
    required this.deviceId,
    required this.period,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingsAsync =
        ref.watch(historicalReadingsProvider('$deviceId|$period'));
    final alertsAsync =
        ref.watch(historicalAlertsProvider('$deviceId|$period'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Period Summary',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 12),
        readingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Text('Failed to load summary'),
          data: (readings) {
            double peak = 0;
            double avg = 0;
            int safeCount = 0;

            if (readings.isNotEmpty) {
              peak = readings
                  .map((r) => r.gasLevel)
                  .fold(0.0, (a, b) => a > b ? a : b);
              avg = readings.map((r) => r.gasLevel).reduce((a, b) => a + b) /
                  readings.length;
              safeCount = readings
                  .where((r) => r.systemState == SystemState.normal)
                  .length;
            }

            final safePercent = readings.isEmpty
                ? 0
                : ((safeCount / readings.length) * 100).round();

            return Column(
              children: [
                Row(
                  children: [
                    _buildSummaryCard(
                      'Peak Level',
                      '${peak.toStringAsFixed(1)}%',
                      'LEL',
                      AppTheme.critical,
                      const Color(0xFFFEE2E2),
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      'Avg Level',
                      '${avg.toStringAsFixed(1)}%',
                      'LEL',
                      AppTheme.primary,
                      const Color(0xFFCCFBF1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    alertsAsync.when(
                      loading: () => _buildSummaryCard(
                          'Total Alerts', '—', 'events', AppTheme.warning, const Color(0xFFFEF3C7)),
                      error: (_, __) => _buildSummaryCard(
                          'Total Alerts', '—', 'events', AppTheme.warning, const Color(0xFFFEF3C7)),
                      data: (alerts) => _buildSummaryCard(
                        'Total Alerts',
                        '${alerts.length}',
                        'events',
                        AppTheme.warning,
                        const Color(0xFFFEF3C7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      'Safe Hours',
                      '$safePercent%',
                      'uptime',
                      AppTheme.success,
                      const Color(0xFFDCFCE7),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, String unit,
      Color accentColor, Color bgColor) {
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
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
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
