import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StreakFlame extends StatelessWidget {
  final int streakDays;
  final bool isActive;

  const StreakFlame({
    super.key,
    required this.streakDays,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.orange.withOpacity(0.12)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: isActive ? Colors.orange : Colors.grey,
            size: 22,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.15,
                duration: 800.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(width: 6),
          Text(
            '$streakDays',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.orange[800] : Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            streakDays == 1 ? 'day' : 'days',
            style: TextStyle(
              fontSize: 13,
              color: isActive ? Colors.orange[700] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
