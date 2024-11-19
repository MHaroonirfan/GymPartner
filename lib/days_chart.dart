import 'dart:math';

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
  List<String> dateValues = List.generate(20, (index) {
    return "$index";
  });

  int xLen = 10;
  int yLen = 10;

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
      fetchChartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else {
            return StatefulBuilder(builder: (context, setState) {
              return Column(children: [
                DropdownButton<String>(
                  value: _selectedDay,
                  borderRadius: BorderRadius.circular(15),
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
                      fetchChartData();
                    });
                  },
                ),
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: 500,
                    height: 400,
                    child: LineChart(
                      LineChartData(
                          gridData: const FlGridData(show: true),
                          minX: 0,
                          maxX: xLen.toDouble(),
                          minY: 0,
                          maxY: yLen.toDouble(),
                          titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                reservedSize: 50,
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return value.floor() + 1 > dateValues.length
                                      ? Text("")
                                      : Transform.rotate(
                                          alignment: Alignment.bottomCenter,
                                          angle: 325 * pi / 180,
                                          child: Text(
                                            dateValues[value.floor()],
                                            style: TextStyle(fontSize: 10),
                                          ));
                                },
                              ))),
                          lineBarsData: [
                            LineChartBarData(
                                spots: lineSpots,
                                isCurved: true,
                                color: Colors.red),
                          ]),
                    ))
              ]);
            });
          }
        });
  }

  void fetchChartData() async {
    List<Map<String, dynamic>> dayDB =
        await DatabaseHandler.instance.getPrevDaysByName("day", _selectedDay);

    double xSpot = 0;
    dateValues.clear();
    dateValues.add("");

    if (dayDB.isEmpty) {
      lineSpots.clear();
      return;
    } else {
      int i = 0;
      int interval = 1;
      if (dayDB.length > 20) {
        interval = (dayDB.length / 20).ceil();
      }
      while (i < dayDB.length) {
        dateValues.add(dayDB[i]["date"]);
        double spot = (await getVolume(dayDB[i]["p_day_id"])).toDouble();
        xSpot++;
        lineSpots.add(FlSpot(xSpot, spot));
        i = i + interval;
        xLen = max(xLen, i);
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
        fullVolume = fullVolume + (sets + reps + weight);
      }
    }
    yLen = exercises.isEmpty
        ? yLen
        : max(yLen, (fullVolume / exercises.length).ceil());

    lineSpots;

    return exercises.isEmpty ? 0 : fullVolume ~/ exercises.length;
  }
}
