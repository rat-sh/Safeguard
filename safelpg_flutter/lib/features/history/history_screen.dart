import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/history_segmented_control.dart';
import 'widgets/gas_level_chart.dart';
import 'widgets/history_summary_cards.dart';
import 'widgets/event_log_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static const String _deviceId = String.fromEnvironment(
    'DEVICE_ID',
    defaultValue: 'default-device',
  );

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedPeriod = '7D';

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
                  HistorySegmentedControl(
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: (newPeriod) {
                      setState(() {
                        _selectedPeriod = newPeriod;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GasLevelChart(
                      deviceId: HistoryScreen._deviceId,
                      period: _selectedPeriod,
                    ),
                    const SizedBox(height: 16),
                    HistorySummaryCards(
                      deviceId: HistoryScreen._deviceId,
                      period: _selectedPeriod,
                    ),
                    const SizedBox(height: 16),
                    EventLogList(
                      deviceId: HistoryScreen._deviceId,
                      period: _selectedPeriod,
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
