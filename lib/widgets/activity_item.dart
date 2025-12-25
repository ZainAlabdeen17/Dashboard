import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const ActivityItem({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
