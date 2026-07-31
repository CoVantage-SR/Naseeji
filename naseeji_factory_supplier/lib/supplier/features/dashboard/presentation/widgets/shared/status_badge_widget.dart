import 'package:flutter/material.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.fontSize = 11.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  factory StatusBadgeWidget.priority(String priority) {
    Color bg;
    Color fg;
    String text = priority;

    switch (priority.toLowerCase()) {
      case 'urgent':
      case 'عاجل':
      case 'عالية جداً':
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFC62828);
        text = 'عاجل جداً';
        break;
      case 'high':
      case 'عالية':
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        text = 'أولوية عالية';
        break;
      case 'medium':
      case 'متوسطة':
        bg = const Color(0xFFE8EAF6);
        fg = const Color(0xFF283593);
        text = 'أولوية متوسطة';
        break;
      default:
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        text = 'أولوية عادية';
    }

    return StatusBadgeWidget(
      label: text,
      backgroundColor: bg,
      textColor: fg,
      icon: Icons.flag_rounded,
    );
  }

  factory StatusBadgeWidget.rfqStatus(String status) {
    Color bg;
    Color fg;
    String text = status;

    switch (status.toLowerCase()) {
      case 'newrfq':
      case 'جديد':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        text = 'جديد';
        break;
      case 'underreview':
      case 'قيد التقييم':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        text = 'قيد التقييم';
        break;
      case 'quoted':
      case 'تم تقديم عرض':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        text = 'تم تقديم عرض';
        break;
      default:
        bg = const Color(0xFFF5F5F5);
        fg = const Color(0xFF616161);
        text = status;
    }

    return StatusBadgeWidget(
      label: text,
      backgroundColor: bg,
      textColor: fg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize + 2,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}


