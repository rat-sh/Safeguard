import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/safe_lpg_card.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsRow> rows;

  const SettingsSection({
    super.key,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        SafeLPGCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(rows.length, (index) {
              final row = rows[index];
              final isLast = index == rows.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: row.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          if (row.icon != null) ...[
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: row.iconBg ?? const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(row.icon, size: 18, color: row.iconColor ?? AppTheme.textSecondary),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  row.label,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: row.labelColor ?? AppTheme.textPrimary,
                                  ),
                                ),
                                if (row.subtitle != null)
                                  Text(
                                    row.subtitle!,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                          if (row.trailing != null)
                            row.trailing!
                          else if (row.value != null)
                            Text(
                              row.value!,
                              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                            )
                          else if (row.onTap != null)
                            const Icon(Icons.chevron_right, color: AppTheme.disabled, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9), indent: 64),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingsRow {
  final String label;
  final String? subtitle;
  final String? value;
  final IconData? icon;
  final Color? iconBg;
  final Color? iconColor;
  final Color? labelColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.label,
    this.subtitle,
    this.value,
    this.icon,
    this.iconBg,
    this.iconColor,
    this.labelColor,
    this.trailing,
    this.onTap,
  });
}

// Factory helpers so callers don't need to import the private class
SettingsSection buildSettingsSection({
  required String title,
  required List<Map<String, dynamic>> rows,
}) {
  return SettingsSection(
    title: title,
    rows: rows.map((r) => _SettingsRow(
      label: r['label'] as String,
      subtitle: r['subtitle'] as String?,
      value: r['value'] as String?,
      icon: r['icon'] as IconData?,
      iconBg: r['iconBg'] as Color?,
      iconColor: r['iconColor'] as Color?,
      labelColor: r['labelColor'] as Color?,
      trailing: r['trailing'] as Widget?,
      onTap: r['onTap'] as VoidCallback?,
    )).toList(),
  );
}
