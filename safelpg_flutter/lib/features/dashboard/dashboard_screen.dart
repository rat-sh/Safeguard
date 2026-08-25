import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/gas_level_card.dart';
import 'widgets/system_state_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_activity_card.dart';
import 'widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    GasLevelCard(),
                    SizedBox(height: 12),
                    SystemStateCard(),
                    SizedBox(height: 12),
                    QuickActions(),
                    SizedBox(height: 12),
                    RecentActivityCard(),
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
}
