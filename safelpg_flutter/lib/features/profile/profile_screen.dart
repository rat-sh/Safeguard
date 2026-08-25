import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/safe_lpg_card.dart';
import '../dashboard/widgets/bottom_nav_bar.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Icon(Icons.settings_outlined, color: AppTheme.textSecondary, size: 24),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.border),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile header (avatar + stats)
                    const ProfileHeader(),
                    const Divider(height: 1, thickness: 1, color: AppTheme.border),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Account Details card
                          const Text(
                            'ACCOUNT DETAILS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SafeLPGCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                _buildInfoRow('Full Name', 'Riya Kumar', Icons.person_outline),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9), indent: 56),
                                _buildInfoRow('Mobile Number', '+91 98765 43210', Icons.phone_outlined),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9), indent: 56),
                                _buildInfoRow('Member Since', 'March 2024', Icons.calendar_today_outlined),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9), indent: 56),
                                _buildInfoRow('Safety Grade', 'Grade A — Excellent', Icons.verified_outlined,
                                    valueColor: AppTheme.success),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Registered Devices
                          const Text(
                            'REGISTERED DEVICES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDeviceCard(
                            name: 'Cylinder A',
                            location: 'Kitchen',
                            status: 'Online',
                            statusColor: AppTheme.success,
                            firmware: 'v2.1.4',
                          ),
                          const SizedBox(height: 12),
                          _buildDeviceCard(
                            name: 'Cylinder B',
                            location: 'Balcony',
                            status: 'Offline',
                            statusColor: AppTheme.disabled,
                            firmware: 'v2.0.9',
                          ),
                          const SizedBox(height: 20),

                          // Activity summary
                          const Text(
                            'ACTIVITY SUMMARY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SafeLPGCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                _buildInfoRow('Total Alerts (30d)', '7 events', Icons.warning_amber_rounded,
                                    valueColor: AppTheme.warning),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9), indent: 56),
                                _buildInfoRow('Critical Alerts (30d)', '1 event', Icons.error_outline,
                                    valueColor: AppTheme.critical),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9), indent: 56),
                                _buildInfoRow('Safe Days Streak', '12 days', Icons.local_fire_department_outlined,
                                    valueColor: AppTheme.success),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9), indent: 56),
                                _buildInfoRow('Avg Gas Level', '13.4% LEL', Icons.sensors, valueColor: AppTheme.primary),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign out
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout, color: AppTheme.critical, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.critical,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const BottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard({
    required String name,
    required String location,
    required String status,
    required Color statusColor,
    required String firmware,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, 1), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFCCFBF1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sensors, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text('$location · $firmware',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
