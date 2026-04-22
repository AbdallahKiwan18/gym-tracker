class AppDateUtils {
  AppDateUtils._();

  /// Get the week number within the month (1-4)
  static int getWeekOfMonth(DateTime date) {
    final dayOfMonth = date.day;
    if (dayOfMonth <= 7) return 1;
    if (dayOfMonth <= 14) return 2;
    if (dayOfMonth <= 21) return 3;
    return 4;
  }

  /// Get month name in Arabic
  static String getMonthNameAr(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل',
      'مايو', 'يونيو', 'يوليو', 'أغسطس',
      'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return months[month - 1];
  }

  /// Get a short date format in Arabic
  static String formatDateAr(DateTime date) {
    return '${date.day} ${getMonthNameAr(date.month)}';
  }

  /// Get day name in Arabic
  static String getDayNameAr(DateTime date) {
    const days = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس',
      'الجمعة', 'السبت', 'الأحد',
    ];
    return days[date.weekday - 1];
  }

  /// Get how long ago text in Arabic
  static String timeAgoAr(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'النهارده';
    if (diff.inDays == 1) return 'إمبارح';
    if (diff.inDays < 7) return 'من ${diff.inDays} أيام';
    if (diff.inDays < 30) return 'من ${(diff.inDays / 7).floor()} أسابيع';
    if (diff.inDays < 365) return 'من ${(diff.inDays / 30).floor()} شهور';
    return 'من ${(diff.inDays / 365).floor()} سنين';
  }
}
