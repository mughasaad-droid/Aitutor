import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/app_background.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF4D3B3B), // Dark Brown
            Color(0xFFB18F8F), // Mauve
            Color(0xFFFFF2D1), // Beige
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Your Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Streak Card
              _buildStreakCard(),
              const SizedBox(height: 20),
              
              // Weekly Progress Rings
              _buildWeeklyProgress(),
              const SizedBox(height: 20),
              
              // Skills Chart
              _buildSkillsChart(),
              const SizedBox(height: 20),
              
              // Weekly Activity Graph
              _buildActivityGraph(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Color(0xFFFF8C00), size: 48),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '12 Day Streak!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Keep it up! You\'re on fire!',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildDayRing('Mon', 0.8, const Color(0xFFFF8C00)),
            _buildDayRing('Tue', 1.0, const Color(0xFFFF8C00)),
            _buildDayRing('Wed', 0.6, const Color(0xFFFF8C00)),
            _buildDayRing('Thu', 0.9, const Color(0xFFFF8C00)),
            _buildDayRing('Fri', 0.4, const Color(0xFFFF8C00)),
            _buildDayRing('Sat', 0.7, const Color(0xFFFF8C00)),
            _buildDayRing('Sun', 0.0, Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRing(String day, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 28,
            lineWidth: 4,
            percent: percent,
            center: Text(
              '${(percent * 100).toInt()}%',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            progressColor: color,
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 8),
          Text(day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }

  Widget _buildSkillsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barGroups: [
                  _makeBarGroup(0, 85, const Color(0xFFFF8C00)),
                  _makeBarGroup(1, 70, const Color(0xFFFF8C00)),
                  _makeBarGroup(2, 60, const Color(0xFFFF8C00)),
                  _makeBarGroup(3, 90, const Color(0xFFFF8C00)),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Speak', 'Listen', 'Read', 'Write'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            titles[value.toInt()],
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.7)),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityGraph() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 30), FlSpot(1, 50), FlSpot(2, 40),
                      FlSpot(3, 70), FlSpot(4, 60), FlSpot(5, 80), FlSpot(6, 45),
                    ],
                    isCurved: true,
                    color: const Color(0xFFFF8C00),
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFF8C00).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
