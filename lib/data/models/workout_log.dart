import 'workout_set.dart';

class WorkoutLog {
  final int? id;
  final int exerciseId;
  final String exerciseName;
  final String exerciseNameAr;
  final String category;
  final DateTime date;
  final int weekOfMonth; // 1-4
  final int month;
  final int year;
  final List<WorkoutSet> sets;

  const WorkoutLog({
    this.id,
    required this.exerciseId,
    this.exerciseName = '',
    this.exerciseNameAr = '',
    this.category = '',
    required this.date,
    required this.weekOfMonth,
    required this.month,
    required this.year,
    required this.sets,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'exercise_id': exerciseId,
      'date': date.toIso8601String(),
      'week_of_month': weekOfMonth,
      'month': month,
      'year': year,
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map, {List<WorkoutSet>? sets}) {
    return WorkoutLog(
      id: map['id'] as int?,
      exerciseId: map['exercise_id'] as int,
      exerciseName: map['exercise_name'] as String? ?? '',
      exerciseNameAr: map['exercise_name_ar'] as String? ?? '',
      category: map['exercise_category'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      weekOfMonth: map['week_of_month'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
      sets: sets ?? [],
    );
  }

  /// Total volume = sum of (reps * weight) for all sets
  double get totalVolume =>
      sets.fold(0.0, (sum, s) => sum + s.volume);

  WorkoutLog copyWith({
    int? id,
    int? exerciseId,
    String? exerciseName,
    String? exerciseNameAr,
    String? category,
    DateTime? date,
    int? weekOfMonth,
    int? month,
    int? year,
    List<WorkoutSet>? sets,
  }) {
    return WorkoutLog(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseNameAr: exerciseNameAr ?? this.exerciseNameAr,
      category: category ?? this.category,
      date: date ?? this.date,
      weekOfMonth: weekOfMonth ?? this.weekOfMonth,
      month: month ?? this.month,
      year: year ?? this.year,
      sets: sets ?? this.sets,
    );
  }
}
