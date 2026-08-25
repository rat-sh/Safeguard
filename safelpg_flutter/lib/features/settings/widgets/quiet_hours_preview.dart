import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

class QuietHoursPreview extends StatelessWidget {
  final String startTime;
  final String endTime;
  final bool enabled;

  const QuietHoursPreview({
    super.key,
    this.startTime = '10:00 PM',
    this.endTime = '07:00 AM',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeLPGCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: enabled ? const Color(0xFFCCFBF1) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.bedtime_outlined,
                      size: 18,
                      color: enabled ? AppTheme.primary : AppTheme.disabled,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quiet Hours',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      Text(
                        enabled ? 'Active · $startTime – $endTime' : 'Disabled',
                        style: TextStyle(
                          fontSize: 12,
                          color: enabled ? AppTheme.primary : AppTheme.disabled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: enabled ? const Color(0xFFCCFBF1) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  enabled ? 'ON' : 'OFF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: enabled ? AppTheme.primary : AppTheme.disabled,
                  ),
                ),
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 16),
            // Timeline visualisation
            Row(
              children: [
                Expanded(
                  child: _buildTimeBlock(startTime, 'Start', AppTheme.primary, const Color(0xFFCCFBF1)),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, Color(0xFF134E4A)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildTimeBlock(endTime, 'End', const Color(0xFF134E4A), const Color(0xFFCCFBF1)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Critical alerts will still be delivered during quiet hours.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeBlock(String time, String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
