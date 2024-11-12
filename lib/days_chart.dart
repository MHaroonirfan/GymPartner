import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DaysChart extends StatefulWidget {
  const DaysChart({super.key});

  @override
  State<DaysChart> createState() => _DaysChartState();
}

class _DaysChartState extends State<DaysChart> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DropdownButton<String>(
        items: const [
          DropdownMenuItem(
            child: Text("data"),
          )
        ],
        onChanged: (t) => {},
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
                ]),
          ))
    ]);
  }
}
