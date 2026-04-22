import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../data/models/workout_log.dart';

class ProgressChart extends StatelessWidget {
  final Map<int, WorkoutLog> weeklyLogs;

  const ProgressChart({
    super.key,
    required this.weeklyLogs,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyLogs.isEmpty) return const SizedBox.shrink();

    final spots = <FlSpot>[];
    for (int week = 1; week <= 4; week++) {
      final log = weeklyLogs[week];
      if (log != null) {
        spots.add(FlSpot(week.toDouble(), log.totalVolume));
      }
    }

    if (spots.length < 2) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: AppStyles.glassmorphism,
        child: Column(
          children: [
            const Icon(Icons.show_chart, color: AppColors.textMuted, size: 40),
            const SizedBox(height: 8),
            Text(
              'سجل أسبوعين على الأقل عشان يظهر الرسم البياني',
              style: AppStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final yRange = maxY - minY;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.glassmorphism,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text('حجم التمرين الإجمالي', style: AppStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'إجمالي (العدات × الوزن) لكل أسبوع',
            style: AppStyles.caption,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: yRange > 0 ? yRange / 4 : 50,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.border,
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'أسبوع ${value.toInt()}',
                            style: AppStyles.caption.copyWith(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: AppStyles.caption.copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 4,
                minY: (minY - yRange * 0.2).clamp(0, double.infinity),
                maxY: maxY + yRange * 0.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: AppColors.accentGradient,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 5,
                        color: AppColors.accent,
                        strokeWidth: 2,
                        strokeColor: AppColors.scaffoldBg,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.25),
                          AppColors.accent.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.cardBg,
                    tooltipRoundedRadius: 12,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} كجم\nأسبوع ${spot.x.toInt()}',
                          AppStyles.chipText.copyWith(color: AppColors.accent),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
