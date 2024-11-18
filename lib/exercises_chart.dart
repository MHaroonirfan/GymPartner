import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_partener/database.dart';

class ExercisesChart extends StatefulWidget {
  const ExercisesChart({super.key});

  @override
  State<ExercisesChart> createState() => _ExercisesChartState();
}

class _ExercisesChartState extends State<ExercisesChart> {
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
  String _selectedEx = "";

  int trackX = 10;
  int trackY = 10;

  LineChartBarData weightData = LineChartBarData();
  LineChartBarData setsData = LineChartBarData();
  LineChartBarData repsData = LineChartBarData();

  List<String> exercisesList = [];

  Future fetchData() async {
    Map<String, dynamic>? dbRes;
    for (var i = dayNames.length - 1; i >= 0; i--) {
      dbRes =
          await DatabaseHandler.instance.getFromDB("Days", "day", dayNames[i]);
      if (dbRes == null) {
        dayNames.remove(dayNames[i]);
      }
    }
    if (dayNames.isNotEmpty) {
      _selectedDay = dayNames[0];
      await updateExercises(dayNames[0]);
      await fetchChartData();
    }
  }

  Future updateExercises(String day) async {
    exercisesList.clear();
    Map<String, dynamic>? dbRes =
        await DatabaseHandler.instance.getFromDB("Days", "day", day);
    List<Map<String, dynamic>> exercises = await DatabaseHandler.instance
        .getExercisesFromDB("Excercises", "day_id", dbRes!["day_id"]);

    for (var i = 0; i < exercises.length; i++) {
      exercisesList.add((exercises[i]["name"]));
    }
    _selectedEx = exercisesList[0];
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
                return Row(
                  children: [
                    Spacer(),
                    DropdownButton<String>(
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
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: _selectedEx,
                      items: List<DropdownMenuItem<String>>.generate(
                          exercisesList.length, (index) {
                        return DropdownMenuItem<String>(
                          value: exercisesList[index],
                          child: Text(exercisesList[index]),
                        );
                      }),
                      onChanged: (t) {
                        setState(() {
                          _selectedEx = t!;
                        });
                      },
                    ),
                    Spacer()
                  ],
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
                        maxX: trackX.toDouble(),
                        minY: 0,
                        maxY: trackY.toDouble(),
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(value.toString());
                                  },
                                  reservedSize: 32)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          weightData,
                          setsData,
                          repsData,
                        ]),
                  ))
            ]);
          }
        });
  }

  Future fetchChartData() async {
    List<Map<String, dynamic>> dayDB = await DatabaseHandler.instance
        .getCompletedExercises(_selectedDay, _selectedEx);

    weightData = LineChartBarData(spots: []);
    setsData = LineChartBarData(spots: []);
    repsData = LineChartBarData(spots: []);
    List<FlSpot> weightSpots = [];
    List<FlSpot> setsSpots = [];
    List<FlSpot> repsSpots = [];
    if (dayDB.isNotEmpty) {
      int i = 0;
      int track = 1;
      int interval = 1;
      if (dayDB.length > 20) {
        interval = (dayDB.length / 20).ceil();
      }
      while (i < dayDB.length) {
        double weight = dayDB[i]["weight"].toDouble();
        double sets = dayDB[i]["sets"].toDouble();
        double reps = dayDB[i]["reps"].toDouble();

        weightSpots.add(FlSpot(track as double, weight));
        setsSpots.add(FlSpot(track as double, sets));
        repsSpots.add(FlSpot(track as double, reps));

        trackY = max(trackY, weight.toInt());
        trackY = max(trackY, sets.toInt());
        trackY = max(trackY, reps.toInt());

        i = i + interval;
        track++;
        trackX = max(trackX, track);
      }

      weightData = LineChartBarData(
          spots: weightSpots, isCurved: true, color: Colors.red);
      setsData = LineChartBarData(
          spots: setsSpots, isCurved: true, color: Colors.blue);
      repsData = LineChartBarData(
          spots: repsSpots, isCurved: true, color: Colors.green);
    }
  }
}
