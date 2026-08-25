import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum ErrorType { offline, deviceUnreachable, serverError, timeout }

class ErrorOfflineScreen extends StatelessWidget {
  final ErrorType type;
  final VoidCallback? onRetry;

  const ErrorOfflineScreen({
    super.key,
    this.type = ErrorType.offline,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final config = _configFor(type);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing icon container
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: (config['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: (config['color'] as Color).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        config['icon'] as IconData,
                        size: 32,
                        color: config['color'] as Color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  config['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  config['subtitle'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Retry button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(
                      'Try Again',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Secondary action
                TextButton(
                  onPressed: () {},
                  child: Text(
                    config['secondaryAction'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Status info strip
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      _buildStatusRow('Last Successful Sync', '10:42 AM Today'),
                      const Divider(height: 16, color: AppTheme.border),
                      _buildStatusRow('Cached Data', 'Available · 12 min old'),
                      const Divider(height: 16, color: AppTheme.border),
                      _buildStatusRow('Device Status', 'Last seen: Online'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
      ],
    );
  }

  Map<String, dynamic> _configFor(ErrorType type) {
    switch (type) {
      case ErrorType.offline:
        return {
          'icon': Icons.wifi_off_rounded,
          'color': AppTheme.warning,
          'title': 'You\'re Offline',
          'subtitle': 'No internet connection detected.\nPlease check your network and try again.',
          'secondaryAction': 'View cached data',
        };
      case ErrorType.deviceUnreachable:
        return {
          'icon': Icons.sensors_off_outlined,
          'color': AppTheme.critical,
          'title': 'Device Unreachable',
          'subtitle': 'SafeLPG sensor is not responding.\nMake sure it is powered and in range.',
          'secondaryAction': 'Go to device settings',
        };
      case ErrorType.serverError:
        return {
          'icon': Icons.cloud_off_outlined,
          'color': AppTheme.critical,
          'title': 'Server Error',
          'subtitle': 'We\'re having trouble connecting\nto our servers. Please try again shortly.',
          'secondaryAction': 'Check system status',
        };
      case ErrorType.timeout:
        return {
          'icon': Icons.timer_off_outlined,
          'color': AppTheme.warning,
          'title': 'Connection Timed Out',
          'subtitle': 'The request took too long to complete.\nCheck your connection and retry.',
          'secondaryAction': 'View cached data',
        };
    }
  }
}
