import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/sensor_models.dart';
import '../../../core/providers/sensor_providers.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

class GasLevelChart extends ConsumerWidget {
  final String deviceId;
  final String period;

  const GasLevelChart({
    super.key,
    required this.deviceId,
    required this.period,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync =
        ref.watch(historicalReadingsProvider('$deviceId|$period'));

    return SafeLPGCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Gas Level Trend',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary),
              ),
              Text(
                'LEL %',
                style:
                    TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          historyAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Failed to load chart data',
                  style: TextStyle(color: AppTheme.critical, fontSize: 12)),
            ),
            data: (readings) {
              if (readings.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'No data yet for this period',
                      style: TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ),
                );
              }

              final buckets = _bucketReadings(readings, period);
              final avg = readings.map((r) => r.gasLevel).reduce((a, b) => a + b) /
                  readings.length;
              final maxValue = buckets
                  .map((b) => b.value)
                  .fold(0.0, (a, b) => a > b ? a : b)
                  .clamp(30.0, 100.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$period · Avg ${avg.toStringAsFixed(1)}% LEL',
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: buckets.map((data) {
                        Color barColor;
                        if (data.value >= 25) {
                          barColor = AppTheme.critical;
                        } else if (data.value >= 15) {
                          barColor = AppTheme.warning;
                        } else {
                          barColor = AppTheme.primary;
                        }
                        final barHeight =
                            (data.value / maxValue * 100).clamp(4.0, 100.0);

                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  data.value > 0
                                      ? data.value.toStringAsFixed(0)
                                      : '',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: barColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: barColor.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  data.label,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Safe (<15%)', AppTheme.primary),
                      const SizedBox(width: 16),
                      _buildLegendItem(
                          'Caution (15-25%)', AppTheme.warning),
                      const SizedBox(width: 16),
                      _buildLegendItem('Critical (>25%)', AppTheme.critical),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Groups readings into labelled buckets for the bar chart.
  List<_BarData> _bucketReadings(
      List<SensorReading> readings, String period) {
    if (period == '24H') {
      // Bucket by hour (last 8 hours shown)
      final now = DateTime.now();
      return List.generate(8, (i) {
        final hour = now.subtract(Duration(hours: 7 - i));
        final label = '${hour.hour.toString().padLeft(2, '0')}h';
        final inBucket = readings.where((r) =>
            r.timestamp.hour == hour.hour &&
            r.timestamp.day == hour.day);
        final avg = inBucket.isEmpty
            ? 0.0
            : inBucket.map((r) => r.gasLevel).reduce((a, b) => a + b) /
                inBucket.length;
        return _BarData(label, avg);
      });
    } else {
      // Bucket by day
      final days = period == '7D' ? 7 : period == '30D' ? 10 : 12;
      final step = period == '30D' ? 3 : period == '90D' ? 8 : 1;
      final now = DateTime.now();
      return List.generate(days, (i) {
        final day = now.subtract(Duration(days: (days - 1 - i) * step));
        final label = period == '7D'
            ? _dayLabel(day.weekday)
            : '${day.day}/${day.month}';
        final inBucket = readings.where((r) {
          final diff = now.difference(r.timestamp).inDays;
          final bucketStart = (days - 1 - i) * step;
          return diff >= bucketStart && diff < bucketStart + step;
        });
        final avg = inBucket.isEmpty
            ? 0.0
            : inBucket.map((r) => r.gasLevel).reduce((a, b) => a + b) /
                inBucket.length;
        return _BarData(label, avg);
      });
    }
  }

  String _dayLabel(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1).clamp(0, 6)];
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _BarData {
  final String label;
  final double value;
  const _BarData(this.label, this.value);
}
