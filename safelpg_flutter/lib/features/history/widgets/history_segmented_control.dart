import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HistorySegmentedControl extends StatefulWidget {
  const HistorySegmentedControl({super.key});

  @override
  State<HistorySegmentedControl> createState() => _HistorySegmentedControlState();
}

class _HistorySegmentedControlState extends State<HistorySegmentedControl> {
  final List<String> segments = ['24H', '7D', '30D', '90D'];
  String selected = '7D';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: segments.map((segment) {
          final isSelected = segment == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selected = segment),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: Color(0x1A0F172A),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  segment,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
