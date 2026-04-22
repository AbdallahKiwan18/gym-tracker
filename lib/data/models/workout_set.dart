class WorkoutSet {
  final int? id;
  final int? logId;
  final int setNumber; // 1, 2, 3
  final int reps;
  final double weight; // in kg

  const WorkoutSet({
    this.id,
    this.logId,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (logId != null) 'log_id': logId,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'] as int?,
      logId: map['log_id'] as int?,
      setNumber: map['set_number'] as int,
      reps: map['reps'] as int,
      weight: (map['weight'] as num).toDouble(),
    );
  }

  WorkoutSet copyWith({
    int? id,
    int? logId,
    int? setNumber,
    int? reps,
    double? weight,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      logId: logId ?? this.logId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
    );
  }

  /// Total volume for this set = reps * weight
  double get volume => reps * weight;

  @override
  String toString() => '$reps×${weight}kg';
}
