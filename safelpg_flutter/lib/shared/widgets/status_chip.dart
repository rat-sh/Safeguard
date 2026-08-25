import 'package:flutter/material.dart';

enum StatusType { safe, caution, critical, info }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusType status;

  const StatusChip({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case StatusType.safe:
        backgroundColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF16A34A);
        break;
      case StatusType.caution:
        backgroundColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        break;
      case StatusType.critical:
        backgroundColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        break;
      case StatusType.info:
        backgroundColor = const Color(0xFFCCFBF1);
        textColor = const Color(0xFF0F766E);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9999), // Pill shape
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
