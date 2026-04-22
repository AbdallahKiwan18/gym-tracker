import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/database/database_helper.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/workout_log.dart';

// ═══════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════

abstract class ExercisesState {}

class ExercisesInitial extends ExercisesState {}

class ExercisesLoading extends ExercisesState {}

class ExercisesLoaded extends ExercisesState {
  final List<Exercise> exercises;
  final Map<int, WorkoutLog?> lastLogs; // exerciseId -> lastLog

  ExercisesLoaded({
    required this.exercises,
    required this.lastLogs,
  });
}

class ExercisesError extends ExercisesState {
  final String message;
  ExercisesError(this.message);
}

// ═══════════════════════════════════════════
// CUBIT
// ═══════════════════════════════════════════

class ExercisesCubit extends Cubit<ExercisesState> {
  final DatabaseHelper _db;

  ExercisesCubit({DatabaseHelper? db})
      : _db = db ?? DatabaseHelper(),
        super(ExercisesInitial());

  Future<void> loadExercises(String category) async {
    emit(ExercisesLoading());
    try {
      final exercises = await _db.getExercisesByCategory(category);
      final Map<int, WorkoutLog?> lastLogs = {};

      for (final exercise in exercises) {
        lastLogs[exercise.id!] = await _db.getLastLogForExercise(exercise.id!);
      }

      emit(ExercisesLoaded(exercises: exercises, lastLogs: lastLogs));
    } catch (e) {
      emit(ExercisesError(e.toString()));
    }
  }
}
