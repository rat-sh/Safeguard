import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/alert_card.dart';

class _AlertData {
  final String severity;
  final String title;
  final String description;
  final String time;

  const _AlertData({
    required this.severity,
    required this.title,
    required this.description,
    required this.time,
  });
}

const _allAlerts = [
  _AlertData(
    severity: 'critical',
    title: 'High Gas Concentration',
    description: 'Regulator OFF + Gas level above 25% LEL. Immediate action required.',
    time: '10:42 AM',
  ),
  _AlertData(
    severity: 'warning',
    title: 'Regulator Switched Off',
    description: 'Gas regulator turned OFF while presence is detected in the kitchen.',
    time: '09:58 AM',
  ),
  _AlertData(
    severity: 'warning',
    title: 'Battery Low',
    description: 'Device battery at 18%. Connect to power source to avoid service interruption.',
    time: '08:30 AM',
  ),
  _AlertData(
    severity: 'info',
    title: 'Morning Safety Check',
    description: 'Automated daily safety scan completed. No anomalies found.',
    time: '07:00 AM',
  ),
];

class AlertCentreScreen extends StatefulWidget {
  const AlertCentreScreen({super.key});

  @override
  State<AlertCentreScreen> createState() => _AlertCentreScreenState();
}

class _AlertCentreScreenState extends State<AlertCentreScreen> {
  String _activeFilter = 'All';
  final _filters = ['All', 'Critical', 'Warning', 'Info'];

  List<_AlertData> get _filteredAlerts {
    if (_activeFilter == 'All') return _allAlerts;
    return _allAlerts
        .where((a) => a.severity == _activeFilter.toLowerCase())
        .toList();
  }

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
                children: [
                  const Text(
                    'Alert Centre',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_filteredAlerts.length} active alerts today',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Filter chips
            Container(
              color: AppTheme.surface,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final isActive = _activeFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _activeFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.primary
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isActive
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.border),
            Expanded(
              child: _filteredAlerts.isEmpty
                  ? const Center(
                      child: Text(
                        'No alerts in this category',
                        style: TextStyle(
                            fontSize: 14, color: AppTheme.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = _filteredAlerts[index];
                        return AlertCard(
                          severity: alert.severity,
                          title: alert.title,
                          description: alert.description,
                          time: alert.time,
                          onTap: () => context.go('/alerts/detail'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
