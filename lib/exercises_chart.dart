import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExercisesChart extends StatefulWidget {
  const ExercisesChart({super.key});

  @override
  State<ExercisesChart> createState() => _ExercisesChartState();
}

class _ExercisesChartState extends State<ExercisesChart> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 45,
      ),
      Container(
          padding: const EdgeInsets.only(right: 10),
          width: 500,
          height: 400,
          child: LineChart(
            LineChartData(
                gridData: const FlGridData(show: true),
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
                titlesData: const FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(spots: [
                    const FlSpot(0, 1),
                    const FlSpot(1, 2),
                    const FlSpot(2, 1.5),
                    const FlSpot(3, 3),
                    const FlSpot(4, 2),
                    const FlSpot(5, 4),
                    const FlSpot(6, 5),
                  ], isCurved: true, color: Colors.red),
                  LineChartBarData(spots: [
                    const FlSpot(1, 1),
                    const FlSpot(1, 3),
                    const FlSpot(2, 1),
                    const FlSpot(3, 5),
                    const FlSpot(4, 6),
                    const FlSpot(5, 4),
                    const FlSpot(6, 6),
                  ], isCurved: true, color: Colors.blue)
                ]),
          ))
    ]);
  }
}
