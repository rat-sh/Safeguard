import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/safe_lpg_card.dart';
import '../../../shared/widgets/status_chip.dart';
import 'arc_gauge_painter.dart';

class GasLevelCard extends StatelessWidget {
  const GasLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeLPGCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'GAS CONCENTRATION',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Cylinder A · Kitchen',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const StatusChip(label: 'Caution', status: StatusType.caution),
            ],
          ),
          const SizedBox(height: 24),
          // Arc Gauge
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomPaint(
                  size: const Size(220, 110),
                  painter: ArcGaugePainter(
                    percentage: 18,
                    color: AppTheme.warning,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '18',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warning,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'Current LEL %',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Status strip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusStripItem('Regulator', 'ON', const Color(0xFF16A34A), const Color(0xFFDCFCE7)),
              _buildStatusStripItem('Presence', 'Detected', const Color(0xFF0F766E), const Color(0xFFCCFBF1)),
              _buildStatusStripItem('Battery', '76%', const Color(0xFFD97706), const Color(0xFFFEF3C7)),
              _buildStatusStripItem('Updated', '12s ago', const Color(0xFF64748B), const Color(0xFFF1F5F9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStripItem(String label, String value, Color textColor, Color bgColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
