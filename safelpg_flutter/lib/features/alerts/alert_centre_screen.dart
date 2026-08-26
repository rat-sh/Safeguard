import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'widgets/alert_filter_chips.dart';
import 'widgets/alert_card.dart';

class AlertCentreScreen extends StatelessWidget {
  const AlertCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar replacement
            Container(
              width: double.infinity,
              color: AppTheme.surface,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Alert Centre',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '3 active alerts today',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppTheme.surface,
              width: double.infinity,
              child: const AlertFilterChips(),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  AlertCard(
                    severity: 'critical',
                    title: 'High Gas Concentration',
                    description: 'Regulator OFF + Gas level above 25% LEL. Immediate action required.',
                    time: '10:42 AM',
                    onTap: () => context.go('/alerts/detail'),
                  ),
                  AlertCard(
                    severity: 'warning',
                    title: 'Regulator Switched Off',
                    description: 'Gas regulator turned OFF while presence is detected in the kitchen.',
                    time: '09:58 AM',
                    onTap: () {},
                  ),
                  AlertCard(
                    severity: 'warning',
                    title: 'Battery Low',
                    description: 'Device battery at 18%. Connect to power source to avoid service interruption.',
                    time: '08:30 AM',
                    onTap: () {},
                  ),
                  AlertCard(
                    severity: 'info',
                    title: 'Morning Safety Check',
                    description: 'Automated daily safety scan completed. No anomalies found.',
                    time: '07:00 AM',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
