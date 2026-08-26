import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/sensor_models.dart';
import '../../../shared/widgets/safe_lpg_card.dart';
import '../../../shared/widgets/status_chip.dart';
import 'arc_gauge_painter.dart';

class GasLevelCard extends StatelessWidget {
  final SensorReading? reading;

  const GasLevelCard({super.key, this.reading});

  @override
  Widget build(BuildContext context) {
    final gasLevel = reading?.gasLevel ?? 0.0;
    final regulatorOn = reading?.regulatorState ?? false;
    final presenceDetected = reading?.humanPresence ?? false;
    final battery = reading?.batteryLevel;
    final updatedAt = reading?.timestamp;

    final gaugeColor = _gaugeColor(gasLevel);
    final statusLabel = _statusLabel(reading?.systemState);
    final statusType = _statusType(reading?.systemState);

    final timeAgo = updatedAt != null
        ? _timeAgo(updatedAt)
        : '—';

    return SafeLPGCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    'Live reading',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              StatusChip(label: statusLabel, status: statusType),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth > 220.0
                        ? 220.0
                        : constraints.maxWidth;
                    return CustomPaint(
                      size: Size(width, width / 2),
                      painter: ArcGaugePainter(
                        percentage: gasLevel,
                        color: gaugeColor,
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      gasLevel.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: gaugeColor,
                        height: 1.0,
                      ),
                    ),
                    const Text(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusStripItem(
                'Regulator',
                regulatorOn ? 'ON' : 'OFF',
                regulatorOn ? const Color(0xFF16A34A) : AppTheme.critical,
                regulatorOn ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              ),
              _buildStatusStripItem(
                'Presence',
                presenceDetected ? 'Detected' : 'Clear',
                presenceDetected ? const Color(0xFF0F766E) : const Color(0xFF64748B),
                presenceDetected ? const Color(0xFFCCFBF1) : const Color(0xFFF1F5F9),
              ),
              _buildStatusStripItem(
                'Battery',
                battery != null ? '$battery%' : '—',
                const Color(0xFFD97706),
                const Color(0xFFFEF3C7),
              ),
              _buildStatusStripItem(
                'Updated',
                timeAgo,
                const Color(0xFF64748B),
                const Color(0xFFF1F5F9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _gaugeColor(double level) {
    if (level >= 25) return AppTheme.critical;
    if (level >= 10) return AppTheme.warning;
    return AppTheme.success;
  }

  String _statusLabel(SystemState? state) {
    switch (state) {
      case SystemState.critical:
        return 'Critical';
      case SystemState.warning:
        return 'Caution';
      case SystemState.power_cut:
        return 'Power Cut';
      default:
        return 'Safe';
    }
  }

  StatusType _statusType(SystemState? state) {
    switch (state) {
      case SystemState.critical:
        return StatusType.critical;
      case SystemState.warning:
        return StatusType.caution;
      default:
        return StatusType.safe;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  Widget _buildStatusStripItem(
      String label, String value, Color textColor, Color bgColor) {
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
