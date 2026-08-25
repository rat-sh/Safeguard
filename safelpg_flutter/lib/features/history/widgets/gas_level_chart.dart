import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

// Static bar chart approximating a gas level trend for the past 7 days.
// Data: [Mon, Tue, Wed, Thu, Fri, Sat, Sun] as % LEL values.
const List<_DayData> _chartData = [
  _DayData('Mon', 6),
  _DayData('Tue', 11),
  _DayData('Wed', 9),
  _DayData('Thu', 18),
  _DayData('Fri', 28),
  _DayData('Sat', 14),
  _DayData('Sun', 8),
];

class _DayData {
  final String label;
  final double value;
  const _DayData(this.label, this.value);
}

class GasLevelChart extends StatelessWidget {
  const GasLevelChart({super.key});

  @override
  Widget build(BuildContext context) {
    const double maxValue = 35;

    return SafeLPGCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Gas Level Trend',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
              Text(
                'LEL %',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Past 7 days · Average 13.4% LEL',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _chartData.map((data) {
                Color barColor;
                if (data.value >= 25) {
                  barColor = AppTheme.critical;
                } else if (data.value >= 15) {
                  barColor = AppTheme.warning;
                } else {
                  barColor = AppTheme.primary;
                }

                final barHeight = (data.value / maxValue) * 100;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${data.value.toInt()}',
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
                          style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Safe (<15%)', AppTheme.primary),
              const SizedBox(width: 16),
              _buildLegendItem('Caution (15-25%)', AppTheme.warning),
              const SizedBox(width: 16),
              _buildLegendItem('Critical (>25%)', AppTheme.critical),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
      ],
    );
  }
}
