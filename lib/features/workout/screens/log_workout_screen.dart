import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/workout_set.dart';
import '../../../widgets/set_input_row.dart';
import '../cubit/workout_cubit.dart';

class LogWorkoutScreen extends StatelessWidget {
  final Exercise exercise;

  const LogWorkoutScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutCubit()..loadLastLog(exercise.id!),
      child: _LogWorkoutBody(exercise: exercise),
    );
  }
}

class _LogWorkoutBody extends StatefulWidget {
  final Exercise exercise;

  const _LogWorkoutBody({required this.exercise});

  @override
  State<_LogWorkoutBody> createState() => _LogWorkoutBodyState();
}

class _LogWorkoutBodyState extends State<_LogWorkoutBody> {
  final List<TextEditingController> _repsControllers = List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _weightControllers = List.generate(3, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _repsControllers) {
      c.dispose();
    }
    for (final c in _weightControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.getColorForCategory(widget.exercise.category);

    return Scaffold(
      body: BlocConsumer<WorkoutCubit, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('تم حفظ التمرين بنجاح! 💪', style: AppStyles.bodyTextBold.copyWith(color: Colors.white)),
                  ],
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
            Navigator.pop(context, true);
          }

          if (state is WorkoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حصل خطأ: ${state.message}'),
                backgroundColor: AppColors.danger,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }

          if (state is WorkoutLogDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.delete_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('تم مسح التمرين بنجاح! 🗑️', style: AppStyles.bodyTextBold.copyWith(color: Colors.white)),
                  ],
                ),
                backgroundColor: AppColors.danger,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
            for (var c in _repsControllers) {
              c.clear();
            }
            for (var c in _weightControllers) {
              c.clear();
            }
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top bar
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.cardBgLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => _openVideo(widget.exercise.videoUrl),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_circle_filled, color: Colors.red, size: 18),
                                    const SizedBox(width: 6),
                                    Text('شوف الفيديو', style: AppStyles.chipText.copyWith(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Exercise info
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: AppStyles.glassmorphism,
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: categoryColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(widget.exercise.emoji, style: const TextStyle(fontSize: 32)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.exercise.name, style: AppStyles.screenTitle.copyWith(fontSize: 20)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: categoryColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${widget.exercise.muscleGroupAr} • 3 مجاميع',
                                        style: AppStyles.chipText.copyWith(color: categoryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text('سجل المجاميع', style: AppStyles.sectionTitle),
                            const Spacer(),
                            if (state is WorkoutLastLogLoaded && state.lastLog != null)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                tooltip: 'مسح آخر تمرينة',
                                onPressed: () => _showDeleteConfirmation(context),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('ادخل العدات والوزن لكل مجموعة', style: AppStyles.caption),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              // Set input rows
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      String? prevReps;
                      String? prevWeight;

                      if (state is WorkoutLastLogLoaded && state.lastLog != null) {
                        final lastSets = state.lastLog!.sets;
                        if (index < lastSets.length) {
                          prevReps = '${lastSets[index].reps}';
                          prevWeight = '${lastSets[index].weight}';
                        }
                      }

                      return SetInputRow(
                        setNumber: index + 1,
                        repsController: _repsControllers[index],
                        weightController: _weightControllers[index],
                        previousReps: prevReps,
                        previousWeight: prevWeight,
                      );
                    },
                    childCount: 3,
                  ),
                ),
              ),
              // Save button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is WorkoutSaving ? null : () => _saveWorkout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.textOnAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      child: state is WorkoutSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.textOnAccent,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save_rounded, size: 22),
                                const SizedBox(width: 8),
                                Text('حفظ التمرين', style: AppStyles.buttonText),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _saveWorkout(BuildContext context) {
    final sets = <WorkoutSet>[];
    bool hasValidSet = false;

    for (int i = 0; i < 3; i++) {
      final repsText = _repsControllers[i].text.trim();
      final weightText = _weightControllers[i].text.trim();

      if (repsText.isNotEmpty && weightText.isNotEmpty) {
        final reps = int.tryParse(repsText);
        final weight = double.tryParse(weightText);

        if (reps != null && weight != null && reps > 0 && weight > 0) {
          sets.add(WorkoutSet(
            setNumber: i + 1,
            reps: reps,
            weight: weight,
          ));
          hasValidSet = true;
        }
      }
    }

    if (!hasValidSet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لازم تملأ مجموعة واحدة على الأقل', style: AppStyles.bodyTextBold.copyWith(color: Colors.white)),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    context.read<WorkoutCubit>().saveWorkout(
      exerciseId: widget.exercise.id!,
      sets: sets,
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          backgroundColor: AppColors.cardBgLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('مسح مجاميع التمرينة', style: AppStyles.screenTitle.copyWith(fontSize: 20)),
          content: Text('متأكد إنك عايز تمسح آخر مجاميع حفظتها للتمرين ده؟', style: AppStyles.bodyText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: Text('إلغاء', style: AppStyles.buttonText.copyWith(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(contextDialog);
                context.read<WorkoutCubit>().deleteLastLog(widget.exercise.id!);
              },
              child: const Text('مسح', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
