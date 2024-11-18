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
  String _selectedDay = "";
  String _selectedEx = "";

  int trackX = 10;
  int trackY = 10;

  List<String> dateValues = List.generate(20, (index) {
    return "$index";
  });

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
    if (exercisesList.isNotEmpty) {
      _selectedEx = exercisesList[0];
    } else {
      _selectedEx = "";
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
            return StatefulBuilder(builder: (context, setState) {
              return Column(children: [
                Row(
                  children: [
                    Spacer(),
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
                          updateExercises(_selectedDay);
                          fetchChartData();
                        });
                      },
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      value: _selectedEx,
                      borderRadius: BorderRadius.circular(15),
                      items: List<DropdownMenuItem<String>>.generate(
                          exercisesList.length, (index) {
                        return DropdownMenuItem<String>(
                          value: exercisesList[index],
                          child: Text(exercisesList[index]),
                        );
                      }),
                      onChanged: (t) {
                        setState(() {
                          print("123");
                          _selectedEx = t!;
                          print(_selectedEx);
                          fetchChartData();
                        });
                      },
                    ),
                    Spacer()
                  ],
                ),
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
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
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
                            weightData,
                            setsData,
                            repsData,
                          ]),
                    ))
              ]);
            });
          }
        });
  }

  Future fetchChartData() async {
    if (_selectedDay == "" || _selectedEx == "") {
      // If no day or exercise selected, clear chart
      weightData = LineChartBarData(spots: []);
      setsData = LineChartBarData(spots: []);
      repsData = LineChartBarData(spots: []);
      return;
    }
    dateValues.clear();
    dateValues.add("");
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

        Map<String, dynamic>? prevDay = await DatabaseHandler.instance
            .getFromDB("PrevDays", "p_day_id", dayDB[i]["p_day_id"]);

        dateValues.add(prevDay!["date"]);

        weightSpots.add(FlSpot(track.toDouble(), weight));
        setsSpots.add(FlSpot(track.toDouble(), sets));
        repsSpots.add(FlSpot(track.toDouble(), reps));

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
    } else {
      weightData = LineChartBarData(spots: []);
      setsData = LineChartBarData(spots: []);
      repsData = LineChartBarData(spots: []);
    }
  }
}
