import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Column(
        children: [
          // Avatar with edit overlay
          Stack(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'RK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border, width: 1.5),
                  ),
                  child: const Icon(Icons.edit, size: 13, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Riya Kumar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '+91 98765 43210',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat('2', 'Devices'),
              _buildDivider(),
              _buildStat('3', 'Contacts'),
              _buildDivider(),
              _buildStat('147', 'Days Active'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 28, color: AppTheme.border);
  }
}
