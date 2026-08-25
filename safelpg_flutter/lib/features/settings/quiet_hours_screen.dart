import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/safe_lpg_button.dart';
import 'widgets/quiet_hours_preview.dart';

class QuietHoursScreen extends StatelessWidget {
  const QuietHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 28),
          onPressed: () {},
        ),
        title: const Text(
          'Quiet Hours',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppTheme.border),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current preview
                    const QuietHoursPreview(startTime: '10:00 PM', endTime: '07:00 AM', enabled: true),
                    const SizedBox(height: 20),

                    // Enable toggle row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, 1), blurRadius: 8),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Enable Quiet Hours', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                              Text('Suppress non-critical alerts', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            ],
                          ),
                          Switch(value: true, onChanged: null, activeColor: AppTheme.primary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time pickers
                    const Text(
                      'SCHEDULE',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 8),
                    _buildTimePicker('Start Time', '10:00 PM'),
                    const SizedBox(height: 12),
                    _buildTimePicker('End Time', '07:00 AM'),
                    const SizedBox(height: 16),

                    // Active days
                    const Text(
                      'ACTIVE DAYS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 8),
                    _buildDaysSelector(),
                    const SizedBox(height: 20),

                    // Info banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCFBF1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shield_outlined, color: AppTheme.primary, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Critical alerts (gas leak, fire) will always be delivered immediately, even during quiet hours.',
                              style: TextStyle(fontSize: 12, color: AppTheme.primary, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: SafeLPGButton(
                text: 'Save Changes',
                onPressed: () {},
                variant: ButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
          Row(
            children: [
              Text(time, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.primary)),
              const SizedBox(width: 6),
              const Icon(Icons.access_time, size: 16, color: AppTheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaysSelector() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const activeIndices = {0, 1, 2, 3, 4}; // Mon–Fri active

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, 1), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(days.length, (index) {
          final isActive = activeIndices.contains(index);
          return Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                days[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppTheme.disabled,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
