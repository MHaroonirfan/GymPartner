import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_partener/database.dart';

class DaysChart extends StatefulWidget {
  const DaysChart({super.key});

  @override
  State<DaysChart> createState() => _DaysChartState();
}

class _DaysChartState extends State<DaysChart> {
  List<String> dayNames = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  String _selectedDay = "Monday";

  List<FlSpot> lineSpots = [];

  Future fetchData() async {
    for (var i = dayNames.length - 1; i >= 0; i--) {
      Map<String, dynamic>? dbRes =
          await DatabaseHandler.instance.getFromDB("Days", "day", dayNames[i]);
      if (dbRes == null) {
        dayNames.remove(dayNames[i]);
      }
    }
    if (dayNames.isNotEmpty) {
      _selectedDay = dayNames[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator.adaptive();
          } else {
            return Column(children: [
              StatefulBuilder(builder: (context, setState) {
                return DropdownButton<String>(
                  value: _selectedDay,
                  items: List<DropdownMenuItem<String>>.generate(
                      dayNames.length, (index) {
                    return DropdownMenuItem<String>(
                      value: dayNames[index],
                      child: Text(dayNames[index]),
                    );
                  }),
                  onChanged: (t) {
                    setState(() {
                      _selectedDay = t!;
                    });
                  },
                );
              }),
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
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                              spots: lineSpots,
                              isCurved: true,
                              color: Colors.red),
                        ]),
                  ))
            ]);
          }
        });
  }

  void fetchChartData() async {
    List<Map<String, dynamic>> dayDB =
        await DatabaseHandler.instance.getPrevDaysByName("day", _selectedDay);

    double xSpot = 0;

    if (dayDB.isEmpty) {
      return;
    } else {
      int i = dayDB.length - 1;
      int interval = 1;
      if (dayDB.length > 20) {
        interval = (dayDB.length / 20).ceil();
      }
      while (i >= 0) {
        double spot = (await getVolume(dayDB[i]["p_day_id"])) as double;
        xSpot++;
        lineSpots.add(FlSpot(xSpot, spot));
        i = i + interval;
      }
    }
  }

  Future<int> getVolume(int dayId) async {
    List<Map<String, dynamic>> exercises = await DatabaseHandler.instance
        .getExercisesFromDB("DoneExcercises", "p_day_id", dayId);

    int fullVolume = 0;

    if (exercises.isNotEmpty) {
      for (var i = 0; i < exercises.length; i++) {
        int sets = (exercises[i])["sets"];
        int reps = (exercises[i])["reps"];
        int weight = (exercises[i])["weight"];
        fullVolume = fullVolume + (sets * reps * weight);
      }
    }

    return fullVolume ~/ exercises.length;
  }
}
