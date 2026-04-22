import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/exercise.dart';
import '../../../widgets/progress_chart.dart';
import '../../../widgets/week_comparison_card.dart';
import '../cubit/progress_cubit.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgressCubit()..loadExercisesWithLogs(),
      child: const _ProgressBody(),
    );
  }
}

class _ProgressBody extends StatelessWidget {
  const _ProgressBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.trending_up_rounded, color: AppColors.accent, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('📊 تتبع التقدم', style: AppStyles.screenTitle),
                              Text('شوف تحسنك كل أسبوع', style: AppStyles.bodyText),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Exercise selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildExerciseSelector(context, state),
                ),
              ),

              // Month selector (only when exercise is selected)
              if (state is ProgressDataLoaded)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildMonthSelector(context, state),
                  ),
                ),

              // Content
              if (state is ProgressLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                ),

              if (state is ProgressDataLoaded) ...[
                // Week comparison table
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: WeekComparisonCard(weeklyLogs: state.weeklyLogs),
                  ),
                ),
                // Progress chart
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: ProgressChart(weeklyLogs: state.weeklyLogs),
                  ),
                ),
                // Volume summary cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    child: _buildVolumeSummary(state),
                  ),
                ),
              ],

              if (state is ProgressExercisesLoaded)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text('👆', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('اختار التمرين', style: AppStyles.sectionTitle),
                        const SizedBox(height: 4),
                        Text(
                          'اختار التمرين اللي عايز تشوف تقدمك فيه',
                          style: AppStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExerciseSelector(BuildContext context, ProgressState state) {
    List<Exercise> exercises = [];
    Exercise? selected;

    if (state is ProgressExercisesLoaded) {
      exercises = state.exercises;
    } else if (state is ProgressDataLoaded) {
      exercises = state.exercises;
      selected = state.selectedExercise;
    }

    if (exercises.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: AppStyles.glassmorphism,
        child: Column(
          children: [
            const Text('🏋️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text('مفيش تمارين مسجلة لسة', style: AppStyles.bodyText),
            Text('سجل أول تمرين من الصفحة الرئيسية', style: AppStyles.caption),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selected?.id,
          hint: Text('اختار التمرين...', style: AppStyles.bodyText),
          dropdownColor: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.accent),
          items: exercises.map((exercise) {
            final categoryColor = AppColors.getColorForCategory(exercise.category);
            return DropdownMenuItem<int>(
              value: exercise.id,
              child: Row(
                children: [
                  Text(exercise.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(exercise.name, style: AppStyles.bodyTextBold),
                        Text(
                          exercise.muscleGroupAr,
                          style: AppStyles.caption.copyWith(color: categoryColor, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) {
              final exercise = exercises.firstWhere((e) => e.id == id);
              context.read<ProgressCubit>().selectExercise(exercise);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, ProgressDataLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.read<ProgressCubit>().previousMonth(),
            icon: const Icon(Icons.chevron_right, color: AppColors.accent),
          ),
          Column(
            children: [
              Text(
                AppDateUtils.getMonthNameAr(state.selectedMonth),
                style: AppStyles.cardTitle,
              ),
              Text(
                '${state.selectedYear}',
                style: AppStyles.caption,
              ),
            ],
          ),
          IconButton(
            onPressed: () => context.read<ProgressCubit>().nextMonth(),
            icon: const Icon(Icons.chevron_left, color: AppColors.accent),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeSummary(ProgressDataLoaded state) {
    if (state.weeklyLogs.isEmpty) return const SizedBox.shrink();

    // Calculate total volume change
    final weeks = state.weeklyLogs.keys.toList()..sort();
    if (weeks.length < 2) return const SizedBox.shrink();

    final firstWeekLog = state.weeklyLogs[weeks.first]!;
    final lastWeekLog = state.weeklyLogs[weeks.last]!;
    final firstVolume = firstWeekLog.totalVolume;
    final lastVolume = lastWeekLog.totalVolume;
    final volumeChange = lastVolume - firstVolume;
    final percentChange = firstVolume > 0
        ? ((volumeChange / firstVolume) * 100)
        : 0.0;

    final isImproved = volumeChange > 0;
    final isDeclined = volumeChange < 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.glassmorphism,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isImproved
                    ? Icons.emoji_events
                    : (isDeclined ? Icons.trending_down : Icons.horizontal_rule),
                color: isImproved
                    ? AppColors.success
                    : (isDeclined ? AppColors.danger : AppColors.warning),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text('ملخص الشهر', style: AppStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'أول أسبوع',
                '${firstVolume.toInt()}',
                'كجم إجمالي',
                AppColors.textSecondary,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isImproved ? AppColors.success : (isDeclined ? AppColors.danger : AppColors.warning))
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isImproved
                          ? Icons.arrow_upward
                          : (isDeclined ? Icons.arrow_downward : Icons.horizontal_rule),
                      color: isImproved
                          ? AppColors.success
                          : (isDeclined ? AppColors.danger : AppColors.warning),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${percentChange.abs().toStringAsFixed(1)}%',
                      style: AppStyles.bodyTextBold.copyWith(
                        color: isImproved
                            ? AppColors.success
                            : (isDeclined ? AppColors.danger : AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
              _buildSummaryItem(
                'آخر أسبوع',
                '${lastVolume.toInt()}',
                'كجم إجمالي',
                AppColors.accent,
              ),
            ],
          ),
          if (isImproved) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'أداؤك اتحسن بنسبة ${percentChange.toStringAsFixed(1)}% الشهر ده!',
                      style: AppStyles.bodyTextBold.copyWith(color: AppColors.success),
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

  Widget _buildSummaryItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(label, style: AppStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppStyles.numberLarge.copyWith(color: color)),
        Text(unit, style: AppStyles.caption),
      ],
    );
  }
}
