import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildActionCard(context, 'Silence Alert', Icons.volume_off, const Color(0xFF0F766E), const Color(0xFFCCFBF1)),
        const SizedBox(width: 12),
        _buildActionCard(context, 'Emergency', Icons.phone, AppTheme.critical, const Color(0xFFFEE2E2)),
        const SizedBox(width: 12),
        _buildActionCard(context, 'View History', Icons.history, AppTheme.textPrimary, const Color(0xFFF1F5F9), route: '/history'),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String label, IconData icon, Color iconColor, Color bgColor, {String? route}) {
    return Expanded(
      child: GestureDetector(
        onTap: route != null ? () => context.go(route) : null,
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F0F172A),
              offset: Offset(0, 1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
