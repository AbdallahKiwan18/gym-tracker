import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../widgets/workout_day_card.dart';
import '../../exercises/screens/exercise_list_screen.dart';
import '../../progress/screens/progress_screen.dart';
import '../cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(),
          const ProgressScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border(
            top: BorderSide(
              color: AppColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'الرئيسية'),
                _buildNavItem(1, Icons.trending_up_rounded, 'التقدم'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.textMuted,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: AppStyles.chipText.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Trigger load
        if (state is HomeInitial) {
          context.read<HomeCubit>().loadHomeData();
        }

        Map<String, DateTime?> lastDates = {};
        Map<String, int> counts = {};

        if (state is HomeLoaded) {
          lastDates = state.lastWorkoutDates;
          counts = state.workoutCounts;
        }

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar area
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: AppColors.textOnAccent,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('💪 Gym Tracker', style: AppStyles.screenTitle),
                                Text(
                                  _getGreeting(),
                                  style: AppStyles.bodyText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Stats row
                      _buildStatsRow(counts),
                      const SizedBox(height: 24),
                      Text('اختار يوم التمرين', style: AppStyles.sectionTitle),
                      const SizedBox(height: 4),
                      Text(
                        'اضغط على اليوم عشان تشوف التمارين',
                        style: AppStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),
              // Workout day cards
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    WorkoutDayCard(
                      title: 'Push Day',
                      emoji: '💪',
                      subtitle: 'صدر • أكتاف • تراي',
                      gradient: AppColors.pushGradient,
                      lastWorkout: _formatLastDate(lastDates['push']),
                      workoutCount: counts['push'] ?? 0,
                      onTap: () => _navigateToExercises(context, 'push', 'Push Day'),
                    ),
                    WorkoutDayCard(
                      title: 'Pull Day',
                      emoji: '🔙',
                      subtitle: 'ظهر • باي • ترابيس',
                      gradient: AppColors.pullGradient,
                      lastWorkout: _formatLastDate(lastDates['pull']),
                      workoutCount: counts['pull'] ?? 0,
                      onTap: () => _navigateToExercises(context, 'pull', 'Pull Day'),
                    ),
                    WorkoutDayCard(
                      title: 'Leg Day',
                      emoji: '🦵',
                      subtitle: 'فخذ أمامي • فخذ خلفي • سمانة',
                      gradient: AppColors.legGradient,
                      lastWorkout: _formatLastDate(lastDates['leg']),
                      workoutCount: counts['leg'] ?? 0,
                      onTap: () => _navigateToExercises(context, 'leg', 'Leg Day'),
                    ),
                    WorkoutDayCard(
                      title: 'CrossFit Day',
                      emoji: '🔥',
                      subtitle: 'جسم كامل • كارديو • قوة',
                      gradient: AppColors.crossfitGradient,
                      lastWorkout: _formatLastDate(lastDates['crossfit']),
                      workoutCount: counts['crossfit'] ?? 0,
                      onTap: () => _navigateToExercises(context, 'crossfit', 'CrossFit Day'),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(Map<String, int> counts) {
    final totalWorkouts = counts.values.fold(0, (a, b) => a + b);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.glassmorphism,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('🏋️', '$totalWorkouts', 'تمرين'),
          Container(width: 1, height: 40, color: AppColors.border),
          _buildStatItem('📅', '${counts.values.where((c) => c > 0).length}', 'أيام نشطة'),
          Container(width: 1, height: 40, color: AppColors.border),
          _buildStatItem('🔥', '${counts.length}', 'فئات'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value, style: AppStyles.numberMedium),
        Text(label, style: AppStyles.caption),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير! يلا نتمرن 🌅';
    if (hour < 17) return 'مساء النشاط! 💥';
    return 'يلا نختم اليوم بتمرينة 🌙';
  }

  String? _formatLastDate(DateTime? date) {
    if (date == null) return null;
    return AppDateUtils.timeAgoAr(date);
  }

  void _navigateToExercises(BuildContext context, String category, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseListScreen(
          category: category,
          title: title,
        ),
      ),
    ).then((_) {
      // Refresh home data when returning
      if (context.mounted) {
        context.read<HomeCubit>().loadHomeData();
      }
    });
  }
}
