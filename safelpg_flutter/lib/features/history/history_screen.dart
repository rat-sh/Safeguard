import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/widgets/bottom_nav_bar.dart';
import 'widgets/history_segmented_control.dart';
import 'widgets/gas_level_chart.dart';
import 'widgets/history_summary_cards.dart';
import 'widgets/event_log_list.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'History & Insights',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Icon(Icons.download_outlined, color: AppTheme.textSecondary, size: 24),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Cylinder A · Kitchen',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  const HistorySegmentedControl(),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    GasLevelChart(),
                    SizedBox(height: 16),
                    HistorySummaryCards(),
                    SizedBox(height: 16),
                    EventLogList(),
                    SizedBox(height: 8),
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
