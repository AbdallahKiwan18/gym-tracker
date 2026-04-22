import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class SetInputRow extends StatelessWidget {
  final int setNumber;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final String? previousReps;
  final String? previousWeight;

  const SetInputRow({
    super.key,
    required this.setNumber,
    required this.repsController,
    required this.weightController,
    this.previousReps,
    this.previousWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Set number badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$setNumber',
                    style: AppStyles.bodyTextBold.copyWith(
                      color: AppColors.textOnAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Reps input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('العدات', style: AppStyles.caption),
                    const SizedBox(height: 4),
                    TextField(
                      controller: repsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: AppStyles.numberMedium,
                      decoration: InputDecoration(
                        hintText: previousReps ?? '12',
                        hintStyle: AppStyles.numberMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Weight input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الوزن (كجم)', style: AppStyles.caption),
                    const SizedBox(height: 4),
                    TextField(
                      controller: weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                      ],
                      textAlign: TextAlign.center,
                      style: AppStyles.numberMedium,
                      decoration: InputDecoration(
                        hintText: previousWeight ?? '10',
                        hintStyle: AppStyles.numberMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Previous values hint
          if (previousReps != null && previousWeight != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 14, color: AppColors.accent.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(
                    'آخر مرة: $previousReps عدة × $previousWeight كجم',
                    style: AppStyles.caption.copyWith(
                      color: AppColors.accent.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
