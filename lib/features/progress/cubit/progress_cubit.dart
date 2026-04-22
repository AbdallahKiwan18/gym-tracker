import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/database/database_helper.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/workout_log.dart';

// ═══════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════

abstract class ProgressState {}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressExercisesLoaded extends ProgressState {
  final List<Exercise> exercises;
  ProgressExercisesLoaded(this.exercises);
}

class ProgressDataLoaded extends ProgressState {
  final List<Exercise> exercises;
  final Exercise selectedExercise;
  final int selectedMonth;
  final int selectedYear;
  final Map<int, WorkoutLog> weeklyLogs; // weekNumber -> log

  ProgressDataLoaded({
    required this.exercises,
    required this.selectedExercise,
    required this.selectedMonth,
    required this.selectedYear,
    required this.weeklyLogs,
  });
}

class ProgressError extends ProgressState {
  final String message;
  ProgressError(this.message);
}

// ═══════════════════════════════════════════
// CUBIT
// ═══════════════════════════════════════════

class ProgressCubit extends Cubit<ProgressState> {
  final DatabaseHelper _db;
  List<Exercise> _exercises = [];
  Exercise? _selectedExercise;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  ProgressCubit({DatabaseHelper? db})
      : _db = db ?? DatabaseHelper(),
        super(ProgressInitial());

  Future<void> loadExercisesWithLogs() async {
    emit(ProgressLoading());
    try {
      _exercises = await _db.getExercisesWithLogs();
      if (_exercises.isEmpty) {
        // If no exercises have logs, load all exercises
        _exercises = await _db.getAllExercises();
      }
      emit(ProgressExercisesLoaded(_exercises));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }

  Future<void> selectExercise(Exercise exercise) async {
    _selectedExercise = exercise;
    await _loadProgressData();
  }

  Future<void> changeMonth(int month, int year) async {
    _selectedMonth = month;
    _selectedYear = year;
    await _loadProgressData();
  }

  Future<void> nextMonth() async {
    if (_selectedMonth == 12) {
      _selectedMonth = 1;
      _selectedYear++;
    } else {
      _selectedMonth++;
    }
    await _loadProgressData();
  }

  Future<void> previousMonth() async {
    if (_selectedMonth == 1) {
      _selectedMonth = 12;
      _selectedYear--;
    } else {
      _selectedMonth--;
    }
    await _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    if (_selectedExercise == null) return;
    emit(ProgressLoading());
    try {
      final weeklyLogs = await _db.getMonthlyLogs(
        _selectedExercise!.id!,
        _selectedMonth,
        _selectedYear,
      );
      emit(ProgressDataLoaded(
        exercises: _exercises,
        selectedExercise: _selectedExercise!,
        selectedMonth: _selectedMonth,
        selectedYear: _selectedYear,
        weeklyLogs: weeklyLogs,
      ));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
