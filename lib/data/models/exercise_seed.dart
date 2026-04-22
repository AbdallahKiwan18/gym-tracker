import 'exercise.dart';

class ExerciseSeed {
  ExerciseSeed._();

  static const List<Exercise> allExercises = [
    // ═══════════════════════════════════════════
    // PUSH DAY 💪
    // ═══════════════════════════════════════════
    Exercise(
      name: 'Bench Press',
      nameAr: 'بنش بريس',
      category: 'push',
      muscleGroup: 'Chest',
      muscleGroupAr: 'صدر',
      videoUrl: 'https://www.youtube.com/watch?v=rT7DgCr-3pg',
      emoji: '🏋️',
    ),
    Exercise(
      name: 'Incline Dumbbell Press',
      nameAr: 'بنش مائل بالدمبل',
      category: 'push',
      muscleGroup: 'Upper Chest',
      muscleGroupAr: 'صدر علوي',
      videoUrl: 'https://www.youtube.com/watch?v=8iPEnn-ltC8',
      emoji: '💪',
    ),
    Exercise(
      name: 'Shoulder Press',
      nameAr: 'ضغط كتف',
      category: 'push',
      muscleGroup: 'Shoulders',
      muscleGroupAr: 'أكتاف',
      videoUrl: 'https://www.youtube.com/watch?v=qEwKCR5JCog',
      emoji: '🔝',
    ),
    Exercise(
      name: 'Lateral Raises',
      nameAr: 'رفرفة جانبية',
      category: 'push',
      muscleGroup: 'Side Delts',
      muscleGroupAr: 'كتف جانبي',
      videoUrl: 'https://www.youtube.com/watch?v=3VcKaXpzqRo',
      emoji: '🦅',
    ),
    Exercise(
      name: 'Tricep Pushdown',
      nameAr: 'تراي بوش داون',
      category: 'push',
      muscleGroup: 'Triceps',
      muscleGroupAr: 'تراي',
      videoUrl: 'https://www.youtube.com/watch?v=2-LAMcpzODU',
      emoji: '💎',
    ),
    Exercise(
      name: 'Cable Chest Fly',
      nameAr: 'تفتيح صدر بالكابل',
      category: 'push',
      muscleGroup: 'Chest',
      muscleGroupAr: 'صدر',
      videoUrl: 'https://www.youtube.com/watch?v=taI4XduLpTk',
      emoji: '🦋',
    ),
    Exercise(
      name: 'Overhead Tricep Extension',
      nameAr: 'فرنساوي تراي',
      category: 'push',
      muscleGroup: 'Triceps',
      muscleGroupAr: 'تراي',
      videoUrl: 'https://www.youtube.com/watch?v=YbX7Wd8jQ-Q',
      emoji: '🔨',
    ),

    // ═══════════════════════════════════════════
    // PULL DAY 🔙
    // ═══════════════════════════════════════════
    Exercise(
      name: 'Deadlift',
      nameAr: 'ديدليفت',
      category: 'pull',
      muscleGroup: 'Back',
      muscleGroupAr: 'ظهر',
      videoUrl: 'https://www.youtube.com/watch?v=op9kVnSso6Q',
      emoji: '🏗️',
    ),
    Exercise(
      name: 'Lat Pulldown',
      nameAr: 'سحب أمامي',
      category: 'pull',
      muscleGroup: 'Lats',
      muscleGroupAr: 'مجنص',
      videoUrl: 'https://www.youtube.com/watch?v=CAwf7n6Luuc',
      emoji: '🔽',
    ),
    Exercise(
      name: 'Seated Cable Row',
      nameAr: 'تجديف بالكابل',
      category: 'pull',
      muscleGroup: 'Mid Back',
      muscleGroupAr: 'وسط الظهر',
      videoUrl: 'https://www.youtube.com/watch?v=GZbfZ033f74',
      emoji: '🚣',
    ),
    Exercise(
      name: 'Barbell Curl',
      nameAr: 'باي بالبار',
      category: 'pull',
      muscleGroup: 'Biceps',
      muscleGroupAr: 'باي',
      videoUrl: 'https://www.youtube.com/watch?v=kwG2ipFRgFo',
      emoji: '💪',
    ),
    Exercise(
      name: 'Face Pulls',
      nameAr: 'فيس بول',
      category: 'pull',
      muscleGroup: 'Rear Delts',
      muscleGroupAr: 'كتف خلفي',
      videoUrl: 'https://www.youtube.com/watch?v=rep-qVOkqgk',
      emoji: '🎯',
    ),
    Exercise(
      name: 'Hammer Curls',
      nameAr: 'هامر كيرل',
      category: 'pull',
      muscleGroup: 'Biceps',
      muscleGroupAr: 'باي',
      videoUrl: 'https://www.youtube.com/watch?v=zC3nLlEvin4',
      emoji: '🔨',
    ),
    Exercise(
      name: 'Shrugs',
      nameAr: 'شراجز',
      category: 'pull',
      muscleGroup: 'Traps',
      muscleGroupAr: 'ترابيس',
      videoUrl: 'https://www.youtube.com/watch?v=cJRVVxmytaM',
      emoji: '🏔️',
    ),

    // ═══════════════════════════════════════════
    // LEG DAY 🦵
    // ═══════════════════════════════════════════
    Exercise(
      name: 'Squat',
      nameAr: 'سكوات',
      category: 'leg',
      muscleGroup: 'Quads',
      muscleGroupAr: 'فخذ أمامي',
      videoUrl: 'https://www.youtube.com/watch?v=ultWZbUMPL8',
      emoji: '🦵',
    ),
    Exercise(
      name: 'Leg Press',
      nameAr: 'ليج بريس',
      category: 'leg',
      muscleGroup: 'Quads',
      muscleGroupAr: 'فخذ أمامي',
      videoUrl: 'https://www.youtube.com/watch?v=IZxyjW7MPJQ',
      emoji: '🔥',
    ),
    Exercise(
      name: 'Romanian Deadlift',
      nameAr: 'رومنيان ديدليفت',
      category: 'leg',
      muscleGroup: 'Hamstrings',
      muscleGroupAr: 'فخذ خلفي',
      videoUrl: 'https://www.youtube.com/watch?v=7j-2w4-P14I',
      emoji: '🎯',
    ),
    Exercise(
      name: 'Leg Extension',
      nameAr: 'ليج إكستنشن',
      category: 'leg',
      muscleGroup: 'Quads',
      muscleGroupAr: 'فخذ أمامي',
      videoUrl: 'https://www.youtube.com/watch?v=YyvSfVjQeL0',
      emoji: '🦿',
    ),
    Exercise(
      name: 'Leg Curl',
      nameAr: 'ليج كيرل',
      category: 'leg',
      muscleGroup: 'Hamstrings',
      muscleGroupAr: 'فخذ خلفي',
      videoUrl: 'https://www.youtube.com/watch?v=1Tq3QdYUuHs',
      emoji: '🔄',
    ),
    Exercise(
      name: 'Calf Raises',
      nameAr: 'رفع سمانة',
      category: 'leg',
      muscleGroup: 'Calves',
      muscleGroupAr: 'سمانة',
      videoUrl: 'https://www.youtube.com/watch?v=-M4-G8p8fmc',
      emoji: '⬆️',
    ),
    Exercise(
      name: 'Bulgarian Split Squat',
      nameAr: 'سبليت سكوات',
      category: 'leg',
      muscleGroup: 'Quads/Glutes',
      muscleGroupAr: 'فخذ/مؤخرة',
      videoUrl: 'https://www.youtube.com/watch?v=2C-uNgKwPLE',
      emoji: '🏃',
    ),

    // ═══════════════════════════════════════════
    // CROSSFIT DAY 🔥
    // ═══════════════════════════════════════════
    Exercise(
      name: 'Burpees',
      nameAr: 'بيربيز',
      category: 'crossfit',
      muscleGroup: 'Full Body',
      muscleGroupAr: 'جسم كامل',
      videoUrl: 'https://www.youtube.com/watch?v=dZgVxmf6jkA',
      emoji: '🤸',
    ),
    Exercise(
      name: 'Box Jumps',
      nameAr: 'قفز على الصندوق',
      category: 'crossfit',
      muscleGroup: 'Legs/Cardio',
      muscleGroupAr: 'أرجل/كارديو',
      videoUrl: 'https://www.youtube.com/watch?v=NBY9-kTuHEk',
      emoji: '📦',
    ),
    Exercise(
      name: 'Kettlebell Swings',
      nameAr: 'كيتل بيل سوينج',
      category: 'crossfit',
      muscleGroup: 'Posterior Chain',
      muscleGroupAr: 'سلسلة خلفية',
      videoUrl: 'https://www.youtube.com/watch?v=YSxHifyI6s8',
      emoji: '🔔',
    ),
    Exercise(
      name: 'Wall Balls',
      nameAr: 'وول بولز',
      category: 'crossfit',
      muscleGroup: 'Full Body',
      muscleGroupAr: 'جسم كامل',
      videoUrl: 'https://www.youtube.com/watch?v=fpUD0mcFp_0',
      emoji: '🏐',
    ),
    Exercise(
      name: 'Battle Ropes',
      nameAr: 'حبال المعركة',
      category: 'crossfit',
      muscleGroup: 'Arms/Cardio',
      muscleGroupAr: 'ذراعين/كارديو',
      videoUrl: 'https://www.youtube.com/watch?v=jMbnnrDuaFc',
      emoji: '🪢',
    ),
    Exercise(
      name: 'Thrusters',
      nameAr: 'ثراسترز',
      category: 'crossfit',
      muscleGroup: 'Full Body',
      muscleGroupAr: 'جسم كامل',
      videoUrl: 'https://www.youtube.com/watch?v=IDuuKEMC6fA',
      emoji: '🚀',
    ),
    Exercise(
      name: 'Double Unders',
      nameAr: 'نط حبل مزدوج',
      category: 'crossfit',
      muscleGroup: 'Cardio',
      muscleGroupAr: 'كارديو',
      videoUrl: 'https://www.youtube.com/watch?v=82jNjDS19lg',
      emoji: '⚡',
    ),
  ];

  static List<Exercise> getByCategory(String category) {
    return allExercises.where((e) => e.category == category).toList();
  }
}
