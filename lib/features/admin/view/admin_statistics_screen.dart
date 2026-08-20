import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';
import 'package:three_alfa_mobile_app/features/admin/provider/admin_provider.dart';
import 'package:three_alfa_mobile_app/features/admin/model/admin_stats_model.dart';

class AdminStatisticsScreen extends StatefulWidget {
  const AdminStatisticsScreen({super.key});

  @override
  State<AdminStatisticsScreen> createState() => _AdminStatisticsScreenState();
}

class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final stats = admin.stats;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: EdgeInsets.all(5.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Decisions Bar Chart
                _buildBarChartCard(
                  stats,
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
                Gap(3.h),

                // Distribution Pie Chart
                if (stats.participantsPerFormation.isNotEmpty) ...[
                  _buildPieChartCard(stats)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.1, end: 0),
                  Gap(3.h),
                ],

                // Recent Activity
                _buildActivitySection(stats)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.1, end: 0),
                Gap(5.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 18.h,
      pinned: true,
      backgroundColor: const Color(0xFF06042E),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 12.w, bottom: 2.h, right: 4.w),
        title: Text(
          'Statistiques & Analyses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF06042E), Color(0xFF58205E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -5.w,
                top: -5.h,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: AppColors.pink.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 5.w,
                bottom: 6.h,
                right: 5.w,
                child: Text(
                  'Suivez l\'activité des formations et les inscriptions en temps réel.',
                  style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChartCard(AdminStats stats) {
    return _buildCard(
      title: 'Décisions sur les formations',
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxYForBarChart(stats),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    rod.toY.round().toString(),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    );
                    String text = '';
                    switch (value.toInt()) {
                      case 0:
                        text = 'Acceptées';
                        break;
                      case 1:
                        text = 'Refusées';
                        break;
                      case 2:
                        text = 'En attente';
                        break;
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(text, style: style),
                    );
                  },
                  reservedSize: 28,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ), // Clean minimal design
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              _makeBarData(
                0,
                stats.confirmedInscriptions.toDouble(),
                AppColors.success,
              ),
              _makeBarData(
                1,
                stats.rejectedInscriptions.toDouble(),
                AppColors.error,
              ),
              _makeBarData(
                2,
                stats.pendingInscriptions.toDouble(),
                AppColors.warning,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getMaxYForBarChart(AdminStats stats) {
    final maxVal = [
      stats.confirmedInscriptions,
      stats.rejectedInscriptions,
      stats.pendingInscriptions,
    ].reduce((a, b) => a > b ? a : b).toDouble();
    return maxVal < 5 ? 5 : maxVal + (maxVal * 0.2); // Add 20% padding to top
  }

  BarChartGroupData _makeBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y == 0 ? 5 : y * 1.5, // Subtle background height
            color: color.withOpacity(0.1),
          ),
        ),
      ],
      showingTooltipIndicators: y > 0 ? [0] : [],
    );
  }

  Widget _buildPieChartCard(AdminStats stats) {
    final entries = stats.participantsPerFormation.entries.toList();
    // Sort by count descending
    entries.sort((a, b) => b.value.compareTo(a.value));

    // Limit to top 5 for better pie chart readability
    final displayEntries = entries.take(5).toList();
    final int total = stats.participantsPerFormation.values.fold(
      0,
      (sum, val) => sum + val,
    );

    final List<Color> pieColors = [
      AppColors.pink,
      AppColors.purple,
      const Color(0xFF4A90E2),
      const Color(0xFFF5A623),
      const Color(0xFF50E3C2),
    ];

    return _buildCard(
      title: 'Répartition des formations suivies',
      child: Column(
        children: [
          SizedBox(
            height: 25.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!
                              .touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: displayEntries.asMap().entries.map((e) {
                      final isTouched = e.key == touchedIndex;
                      final double radius = isTouched ? 35 : 25;
                      final double percentage = (e.value.value / total) * 100;
                      return PieChartSectionData(
                        color: pieColors[e.key % pieColors.length],
                        value: e.value.value.toDouble(),
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: radius,
                        titleStyle: TextStyle(
                          fontSize: isTouched ? 14 : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Center text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMute,
                      ),
                    ),
                    Text(
                      '$total',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(2.h),
          // Legend
          ...displayEntries.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: pieColors[e.key % pieColors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(3.w),
                  Expanded(
                    child: Text(
                      e.value.key,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${e.value.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivitySection(AdminStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité récente',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        Gap(2.h),
        _buildActivityRow(
          icon: Icons.star_rounded,
          color: AppColors.warning,
          title: 'Formation la plus demandée',
          subtitle: stats.mostPopularFormation,
        ),
        Gap(1.5.h),
        _buildActivityRow(
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
          title: 'Total acceptées',
          subtitle: '${stats.confirmedInscriptions} demandes validées',
        ),
        Gap(1.5.h),
        _buildActivityRow(
          icon: Icons.cancel_rounded,
          color: AppColors.error,
          title: 'Total refusées',
          subtitle: '${stats.rejectedInscriptions} demandes rejetées',
        ),
      ],
    );
  }

  Widget _buildActivityRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          Gap(4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textMute),
                ),
                Gap(0.5.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Gap(3.h),
          child,
        ],
      ),
    );
  }
}
