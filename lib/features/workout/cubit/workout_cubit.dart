import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/models/workout_set.dart';

// ═══════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════

abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLastLogLoaded extends WorkoutState {
  final WorkoutLog? lastLog;
  WorkoutLastLogLoaded(this.lastLog);
}

class WorkoutSaving extends WorkoutState {}

class WorkoutSaved extends WorkoutState {}

class WorkoutLogDeleted extends WorkoutState {}

class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
}

// ═══════════════════════════════════════════
// CUBIT
// ═══════════════════════════════════════════

class WorkoutCubit extends Cubit<WorkoutState> {
  final DatabaseHelper _db;

  WorkoutCubit({DatabaseHelper? db})
      : _db = db ?? DatabaseHelper(),
        super(WorkoutInitial());

  Future<void> loadLastLog(int exerciseId) async {
    emit(WorkoutLoading());
    try {
      final lastLog = await _db.getLastLogForExercise(exerciseId);
      emit(WorkoutLastLogLoaded(lastLog));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> saveWorkout({
    required int exerciseId,
    required List<WorkoutSet> sets,
  }) async {
    emit(WorkoutSaving());
    try {
      final now = DateTime.now();
      final log = WorkoutLog(
        exerciseId: exerciseId,
        date: now,
        weekOfMonth: AppDateUtils.getWeekOfMonth(now),
        month: now.month,
        year: now.year,
        sets: sets,
      );
      await _db.insertWorkoutLog(log);
      emit(WorkoutSaved());
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> deleteLastLog(int exerciseId) async {
    emit(WorkoutLoading());
    try {
      final lastLog = await _db.getLastLogForExercise(exerciseId);
      if (lastLog != null && lastLog.id != null) {
        await _db.deleteWorkoutLog(lastLog.id!);
        emit(WorkoutLogDeleted());
      }
      // Re-load the now-last log
      await loadLastLog(exerciseId);
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }
}
