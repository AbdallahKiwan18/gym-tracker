import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/database/database_helper.dart';

// ═══════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Map<String, DateTime?> lastWorkoutDates;
  final Map<String, int> workoutCounts;

  HomeLoaded({
    required this.lastWorkoutDates,
    required this.workoutCounts,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

// ═══════════════════════════════════════════
// CUBIT
// ═══════════════════════════════════════════

class HomeCubit extends Cubit<HomeState> {
  final DatabaseHelper _db;

  HomeCubit({DatabaseHelper? db})
      : _db = db ?? DatabaseHelper(),
        super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final lastDates = await _db.getLastWorkoutPerCategory();
      final counts = await _db.getWorkoutCountPerCategory();
      emit(HomeLoaded(
        lastWorkoutDates: lastDates,
        workoutCounts: counts,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
