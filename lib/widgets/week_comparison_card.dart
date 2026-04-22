import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../data/models/workout_log.dart';
import '../../data/models/workout_set.dart';

class WeekComparisonCard extends StatelessWidget {
  final Map<int, WorkoutLog> weeklyLogs;

  const WeekComparisonCard({
    super.key,
    required this.weeklyLogs,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyLogs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: AppStyles.glassmorphism,
        child: Column(
          children: [
            const Text('📊', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'مفيش بيانات للشهر ده',
              style: AppStyles.bodyText,
            ),
            const SizedBox(height: 4),
            Text(
              'ابدأ سجل تمارينك وهتلاقي التقدم هنا',
              style: AppStyles.caption,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: AppStyles.glassmorphism,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
            ),
            child: Row(
              children: [
                const Icon(Icons.compare_arrows, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text('مقارنة الأسابيع', style: AppStyles.cardTitle),
              ],
            ),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text('الأسبوع', style: AppStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: Text('مجموعة 1', style: AppStyles.caption.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text('مجموعة 2', style: AppStyles.caption.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text('مجموعة 3', style: AppStyles.caption.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          // Weeks
          ...List.generate(4, (index) {
            final weekNum = index + 1;
            final log = weeklyLogs[weekNum];
            final prevLog = index > 0 ? weeklyLogs[weekNum - 1] : null;

            return _buildWeekRow(weekNum, log, prevLog);
          }),
        ],
      ),
    );
  }

  Widget _buildWeekRow(int weekNum, WorkoutLog? log, WorkoutLog? prevLog) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: log != null ? AppColors.accent.withValues(alpha: 0.03) : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: log != null
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.textMuted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$weekNum',
                      style: AppStyles.chipText.copyWith(
                        color: log != null ? AppColors.accent : AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(3, (setIdx) {
            return Expanded(
              child: _buildSetCell(log, prevLog, setIdx),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSetCell(WorkoutLog? log, WorkoutLog? prevLog, int setIndex) {
    if (log == null || setIndex >= log.sets.length) {
      return Center(
        child: Text('—', style: AppStyles.caption),
      );
    }

    final set = log.sets[setIndex];
    final prevSet = (prevLog != null && setIndex < prevLog.sets.length)
        ? prevLog.sets[setIndex]
        : null;

    final trend = _getTrend(set, prevSet);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${set.reps}×${set.weight}',
              style: AppStyles.chipText.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (trend != null) ...[
              const SizedBox(width: 2),
              Icon(
                trend['icon'] as IconData,
                size: 14,
                color: trend['color'] as Color,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Map<String, dynamic>? _getTrend(WorkoutSet current, WorkoutSet? previous) {
    if (previous == null) return null;

    final currentVolume = current.volume;
    final previousVolume = previous.volume;

    if (currentVolume > previousVolume) {
      return {'icon': Icons.arrow_upward, 'color': AppColors.success};
    } else if (currentVolume < previousVolume) {
      return {'icon': Icons.arrow_downward, 'color': AppColors.danger};
    } else {
      return {'icon': Icons.horizontal_rule, 'color': AppColors.warning};
    }
  }
}
