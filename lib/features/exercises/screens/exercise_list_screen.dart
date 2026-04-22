import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/models/exercise.dart';
import '../../../widgets/exercise_card.dart';
import '../../workout/screens/log_workout_screen.dart';
import '../cubit/exercises_cubit.dart';

class ExerciseListScreen extends StatelessWidget {
  final String category;
  final String title;

  const ExerciseListScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExercisesCubit()..loadExercises(category),
      child: _ExerciseListBody(category: category, title: title),
    );
  }
}

class _ExerciseListBody extends StatelessWidget {
  final String category;
  final String title;

  const _ExerciseListBody({
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors.getGradientForCategory(category);
    final emoji = _getEmoji(category);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 40)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppStyles.screenTitle.copyWith(color: Colors.white),
                              ),
                              BlocBuilder<ExercisesCubit, ExercisesState>(
                                builder: (context, state) {
                                  final count = state is ExercisesLoaded ? state.exercises.length : 0;
                                  return Text(
                                    '$count تمارين',
                                    style: AppStyles.bodyText.copyWith(color: Colors.white70),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Exercise list
          BlocBuilder<ExercisesCubit, ExercisesState>(
            builder: (context, state) {
              if (state is ExercisesLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                );
              }

              if (state is ExercisesError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('حصل خطأ: ${state.message}', style: AppStyles.bodyText),
                  ),
                );
              }

              if (state is ExercisesLoaded) {
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final exercise = state.exercises[index];
                        final lastLog = state.lastLogs[exercise.id];
                        return ExerciseCard(
                          exercise: exercise,
                          lastLog: lastLog,
                          onTap: () => _navigateToLogWorkout(context, exercise),
                          onVideoTap: () => _openVideo(exercise.videoUrl),
                        );
                      },
                      childCount: state.exercises.length,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  String _getEmoji(String category) {
    switch (category) {
      case 'push': return '💪';
      case 'pull': return '🔙';
      case 'leg': return '🦵';
      case 'crossfit': return '🔥';
      default: return '🏋️';
    }
  }

  void _navigateToLogWorkout(BuildContext context, Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogWorkoutScreen(exercise: exercise),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<ExercisesCubit>().loadExercises(category);
      }
    });
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
