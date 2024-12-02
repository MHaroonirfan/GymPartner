import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_partener/database.dart';
import 'package:gym_partener/colors.dart';
import 'package:gym_partener/excercises_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> dayNames = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  Future fetchData() async {
    String exName = "";
    int exWeight = 10;
    int exSets = 1;
    int exReps = 10;
    int exTime = 10;

    TextEditingController controller = TextEditingController();

    List<String> daysToRemove = [];
    for (var i = 0; i < dayNames.length; i++) {
      String trimmed = "";
      Map<String, dynamic>? dbRes =
          await DatabaseHandler.instance.getFromDB("Days", "day", dayNames[i]);
      if (dbRes == null) {
        daysToRemove.add(dayNames[i]);
      } else {
        List<Map<String, dynamic>> exercises = await DatabaseHandler.instance
            .getExercisesFromDB("Excercises", "day_id", dbRes["day_id"]);
        if (exercises.isEmpty) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text(
                      "Please Add a Excercise to ${dbRes["day"]}",
                      style: TextStyle(fontSize: 18),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Text("Exercise Name:"),
                          Expanded(
                              child: TextField(
                            controller: controller,
                            onChanged: (text) {
                              exName = text;
                              trimmed = exName.trim();
                            },
                          ))
                        ]),
                        Row(children: [
                          Expanded(child: Text("Weight:")),
                          DropdownButton(
                              value: exWeight,
                              menuMaxHeight: 200,
                              borderRadius: BorderRadius.circular(15),
                              items: List.generate(200, (index) {
                                return DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text("${index + 1}"));
                              }),
                              onChanged: (value) {
                                setState(() {
                                  exWeight = value!;
                                });
                              }),
                          Text("KG")
                        ]),
                        Row(children: [
                          Expanded(child: Text("Sets:")),
                          DropdownButton(
                              value: exSets,
                              menuMaxHeight: 200,
                              borderRadius: BorderRadius.circular(15),
                              items: List.generate(20, (index) {
                                return DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text("${index + 1}"));
                              }),
                              onChanged: (value) {
                                setState(() {
                                  exSets = value!;
                                });
                              }),
                        ]),
                        Row(children: [
                          Expanded(child: Text("Reps:")),
                          DropdownButton(
                              value: exReps,
                              menuMaxHeight: 200,
                              borderRadius: BorderRadius.circular(15),
                              items: List.generate(200, (index) {
                                return DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text("${index + 1}"));
                              }),
                              onChanged: (value) {
                                setState(() {
                                  exReps = value!;
                                });
                              }),
                        ]),
                        Row(children: [
                          Expanded(child: Text("Duration:")),
                          DropdownButton(
                              value: exTime,
                              menuMaxHeight: 200,
                              borderRadius: BorderRadius.circular(15),
                              items: List.generate(59, (index) {
                                return DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text("${index + 1}"));
                              }),
                              onChanged: (value) {
                                setState(() {
                                  exTime = value!;
                                });
                              }),
                          Text("min")
                        ])
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            if (trimmed == "") {
                              Fluttertoast.showToast(
                                  msg: "Please! Give Exercise Name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM);
                            } else {
                              await DatabaseHandler.instance
                                  .insertInDB("Excercises", {
                                "name": trimmed,
                                "weight": exWeight,
                                "sets": exSets,
                                "reps": exReps,
                                "duration": exTime,
                                "day_id": dbRes["day_id"]
                              });
                              controller.text = "";
                              trimmed = "";
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Done"))
                    ],
                  );
                });
              });
        }
      }
    }

    dayNames.removeWhere((day) => daysToRemove.contains(day));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else {
              return getWidget();
            }
          }),
    );
  }

  Widget getWidget() {
    return GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      shrinkWrap: true,
      children: getDaysWidgets(),
    );
  }

  List<Widget> getDaysWidgets() {
    Random rnd = Random();
    List<Widget> days = [];
    for (var i = 0; i < dayNames.length; i++) {
      {
        days.add(
          Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: GestureDetector(
                    onTap: () async {
                      Map<String, dynamic>? dbRes = await DatabaseHandler
                          .instance
                          .getFromDB("Days", "day", dayNames[i]);
                      int id = dbRes!["day_id"];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExercisesScreen(
                                    dayID: id,
                                    dayName: dayNames[i],
                                  )));
                    },
                    child: Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.only(left: 20, top: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomColors.cColors[
                              rnd.nextInt(CustomColors.cColors.length)],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dayNames[i],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Tap here to see\nExercises",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ])))),
          ),
        );
      }
    }

    return days;
  }
}
