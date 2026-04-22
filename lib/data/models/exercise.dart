class Exercise {
  final int? id;
  final String name;
  final String nameAr;
  final String category; // push, pull, leg, crossfit
  final String muscleGroup;
  final String muscleGroupAr;
  final String videoUrl;
  final String emoji;

  const Exercise({
    this.id,
    required this.name,
    required this.nameAr,
    required this.category,
    required this.muscleGroup,
    required this.muscleGroupAr,
    required this.videoUrl,
    required this.emoji,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'name_ar': nameAr,
      'category': category,
      'muscle_group': muscleGroup,
      'muscle_group_ar': muscleGroupAr,
      'video_url': videoUrl,
      'emoji': emoji,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
      nameAr: map['name_ar'] as String,
      category: map['category'] as String,
      muscleGroup: map['muscle_group'] as String,
      muscleGroupAr: map['muscle_group_ar'] as String,
      videoUrl: map['video_url'] as String,
      emoji: map['emoji'] as String,
    );
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? nameAr,
    String? category,
    String? muscleGroup,
    String? muscleGroupAr,
    String? videoUrl,
    String? emoji,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      category: category ?? this.category,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      muscleGroupAr: muscleGroupAr ?? this.muscleGroupAr,
      videoUrl: videoUrl ?? this.videoUrl,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  String toString() => 'Exercise($name, $category)';
}
