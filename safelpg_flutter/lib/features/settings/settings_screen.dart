import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'widgets/settings_section.dart';
import 'widgets/contact_list_item.dart';
import 'widgets/quiet_hours_preview.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppTheme.surface,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile row
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('RK', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Riya Kumar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                            Text('+91 98765 43210', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppTheme.disabled),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quiet Hours Preview
                    const QuietHoursPreview(),
                    const SizedBox(height: 20),

                    // Emergency Contacts section
                    const Text(
                      'EMERGENCY CONTACTS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 8),
                    const ContactListItem(
                      name: 'Riya Kumar',
                      phone: '+91 98765 43210',
                      relation: 'Family',
                      callEnabled: true,
                      smsEnabled: true,
                    ),
                    const SizedBox(height: 12),
                    const ContactListItem(
                      name: 'Arjun Mehta',
                      phone: '+91 87654 32109',
                      relation: 'Neighbour',
                      callEnabled: false,
                      smsEnabled: true,
                    ),
                    const SizedBox(height: 12),
                    // Add contact button
                    GestureDetector(
                      onTap: () => context.go('/settings/add-contact'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary, width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFCCFBF1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: AppTheme.primary, size: 18),
                          SizedBox(width: 6),
                          Text('Add Emergency Contact', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notifications section
                    buildSettingsSection(
                      title: 'Notifications',
                      rows: [
                        {
                          'label': 'Push Notifications',
                          'subtitle': 'Critical and warning alerts',
                          'icon': Icons.notifications_outlined,
                          'iconBg': const Color(0xFFCCFBF1),
                          'iconColor': AppTheme.primary,
                          'trailing': Switch(value: true, onChanged: null, activeColor: AppTheme.primary),
                        },
                        {
                          'label': 'SMS Alerts',
                          'subtitle': 'Sent to emergency contacts',
                          'icon': Icons.sms_outlined,
                          'iconBg': const Color(0xFFFEF3C7),
                          'iconColor': AppTheme.warning,
                          'trailing': Switch(value: true, onChanged: null, activeColor: AppTheme.primary),
                        },
                        {
                          'label': 'Quiet Hours',
                          'subtitle': '10:00 PM – 07:00 AM',
                          'icon': Icons.bedtime_outlined,
                          'iconBg': const Color(0xFFF1F5F9),
                          'iconColor': AppTheme.textSecondary,
                          'onTap': () => context.go('/settings/quiet-hours'),
                        },
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Device section
                    buildSettingsSection(
                      title: 'Device',
                      rows: [
                        {
                          'label': 'Device Name',
                          'value': 'Cylinder A',
                          'icon': Icons.sensors,
                          'iconBg': const Color(0xFFCCFBF1),
                          'iconColor': AppTheme.primary,
                          'onTap': () {},
                        },
                        {
                          'label': 'Alert Thresholds',
                          'subtitle': 'Caution 15% · Critical 25%',
                          'icon': Icons.tune,
                          'iconBg': const Color(0xFFFEF3C7),
                          'iconColor': AppTheme.warning,
                          'onTap': () {},
                        },
                        {
                          'label': 'Firmware Version',
                          'value': 'v2.1.4',
                          'icon': Icons.memory_outlined,
                          'iconBg': const Color(0xFFF1F5F9),
                          'iconColor': AppTheme.textSecondary,
                        },
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Account section
                    buildSettingsSection(
                      title: 'Account',
                      rows: [
                        {
                          'label': 'Privacy Policy',
                          'icon': Icons.privacy_tip_outlined,
                          'iconBg': const Color(0xFFF1F5F9),
                          'iconColor': AppTheme.textSecondary,
                          'onTap': () {},
                        },
                        {
                          'label': 'Terms of Service',
                          'icon': Icons.description_outlined,
                          'iconBg': const Color(0xFFF1F5F9),
                          'iconColor': AppTheme.textSecondary,
                          'onTap': () {},
                        },
                        {
                          'label': 'Sign Out',
                          'icon': Icons.logout,
                          'iconBg': const Color(0xFFFEE2E2),
                          'iconColor': AppTheme.critical,
                          'labelColor': AppTheme.critical,
                          'onTap': () {},
                        },
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text('SafeLPG v2.1.0 · Certified Safety Grade A',
                          style: TextStyle(fontSize: 12, color: AppTheme.disabled)),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
