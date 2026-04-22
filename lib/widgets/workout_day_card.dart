import 'package:flutter/material.dart';
import '../../core/theme/app_styles.dart';

class WorkoutDayCard extends StatelessWidget {
  final String title;
  final String emoji;
  final String subtitle;
  final String? lastWorkout;
  final int workoutCount;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const WorkoutDayCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.subtitle,
    this.lastWorkout,
    this.workoutCount = 0,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background emoji pattern
            Positioned(
              right: -10,
              bottom: -10,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 80, color: Colors.white10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 36)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppStyles.sectionTitle.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: AppStyles.bodyText.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.fitness_center, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$workoutCount',
                              style: AppStyles.bodyTextBold.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (lastWorkout != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, color: Colors.white70, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'آخر تمرين: $lastWorkout',
                            style: AppStyles.caption.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
