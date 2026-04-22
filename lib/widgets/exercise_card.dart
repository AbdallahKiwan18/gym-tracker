import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../data/models/exercise.dart';
import '../../data/models/workout_log.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final WorkoutLog? lastLog;
  final VoidCallback onTap;
  final VoidCallback onVideoTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.lastLog,
    required this.onTap,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.getColorForCategory(exercise.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Emoji icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(exercise.emoji, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercise.name, style: AppStyles.cardTitle),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            exercise.muscleGroupAr,
                            style: AppStyles.chipText.copyWith(
                              color: categoryColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        if (lastLog != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${lastLog!.sets.isNotEmpty ? lastLog!.sets.first.weight : 0} kg',
                            style: AppStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Video button
              GestureDetector(
                onTap: onVideoTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_circle_filled,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
