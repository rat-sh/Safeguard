import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ContactListItem extends StatelessWidget {
  final String name;
  final String phone;
  final String relation;
  final bool callEnabled;
  final bool smsEnabled;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContactListItem({
    super.key,
    required this.name,
    required this.phone,
    required this.relation,
    this.callEnabled = true,
    this.smsEnabled = true,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFCCFBF1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onEdit,
                          child: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: onDelete,
                          child: const Icon(Icons.delete_outline, size: 18, color: AppTheme.critical),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '$relation · $phone',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge(Icons.phone_outlined, 'Call', callEnabled),
                    const SizedBox(width: 8),
                    _buildBadge(Icons.sms_outlined, 'SMS', smsEnabled),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, bool enabled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFCCFBF1) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: enabled ? AppTheme.primary : AppTheme.disabled),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: enabled ? AppTheme.primary : AppTheme.disabled,
            ),
          ),
        ],
      ),
    );
  }
}
