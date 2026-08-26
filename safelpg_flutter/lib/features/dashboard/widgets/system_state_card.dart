import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/sensor_models.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

class SystemStateCard extends StatelessWidget {
  final SensorReading? reading;

  const SystemStateCard({super.key, this.reading});

  @override
  Widget build(BuildContext context) {
    final state = reading?.systemState ?? SystemState.normal;
    final gasLevel = reading?.gasLevel ?? 0.0;
    final timestamp = reading?.timestamp;

    final stateColor = _stateColor(state);
    final stateBg = _stateBg(state);
    final stateIcon = _stateIcon(state);
    final stateLabel = _stateLabel(state);
    final stateMessage = _stateMessage(state, gasLevel);
    final sinceTime = timestamp != null
        ? TimeOfDay.fromDateTime(timestamp).format(context)
        : '—';

    return SafeLPGCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: stateBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(stateIcon, color: stateColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System State',
                        style: TextStyle(
                            fontSize: 13, color: AppTheme.textSecondary),
                      ),
                      Text(
                        stateLabel,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: stateColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Since',
                    style:
                        TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  Text(
                    sinceTime,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (gasLevel / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: stateColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stateMessage,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Color _stateColor(SystemState state) {
    switch (state) {
      case SystemState.critical:
        return AppTheme.critical;
      case SystemState.warning:
        return AppTheme.warning;
      case SystemState.power_cut:
        return const Color(0xFF7C3AED);
      default:
        return AppTheme.success;
    }
  }

  Color _stateBg(SystemState state) {
    switch (state) {
      case SystemState.critical:
        return const Color(0xFFFEE2E2);
      case SystemState.warning:
        return const Color(0xFFFEF3C7);
      case SystemState.power_cut:
        return const Color(0xFFEDE9FE);
      default:
        return const Color(0xFFDCFCE7);
    }
  }

  IconData _stateIcon(SystemState state) {
    switch (state) {
      case SystemState.critical:
        return Icons.emergency_rounded;
      case SystemState.warning:
        return Icons.warning_amber_rounded;
      case SystemState.power_cut:
        return Icons.power_off_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  String _stateLabel(SystemState state) {
    switch (state) {
      case SystemState.critical:
        return 'Critical';
      case SystemState.warning:
        return 'Caution';
      case SystemState.power_cut:
        return 'Power Cut';
      default:
        return 'Normal';
    }
  }

  String _stateMessage(SystemState state, double gasLevel) {
    switch (state) {
      case SystemState.critical:
        return 'Danger! Gas level at ${gasLevel.toStringAsFixed(1)}% LEL — evacuate immediately';
      case SystemState.warning:
        return 'Gas level slightly elevated — ventilate the area';
      case SystemState.power_cut:
        return 'Power failure detected — device on backup power';
      default:
        return 'All systems normal — gas level safe at ${gasLevel.toStringAsFixed(1)}% LEL';
    }
  }
}
