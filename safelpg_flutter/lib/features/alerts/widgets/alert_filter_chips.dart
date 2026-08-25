import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AlertFilterChips extends StatefulWidget {
  const AlertFilterChips({super.key});

  @override
  State<AlertFilterChips> createState() => _AlertFilterChipsState();
}

class _AlertFilterChipsState extends State<AlertFilterChips> {
  final List<String> filters = ['All', 'Critical', 'Warning', 'Info'];
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
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
