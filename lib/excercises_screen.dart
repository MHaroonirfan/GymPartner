import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_partener/database.dart';
import 'package:sqflite/sqflite.dart';

class ExercisesScreen extends StatefulWidget {
  final int dayID;
  const ExercisesScreen({super.key, required this.dayID});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Map<String, dynamic>> exercisesList = [];

  Future fetchData() async {
    List<Map<String, dynamic>>? list = await DatabaseHandler.instance
        .getExercisesFromDB("Excercises", "day_id", widget.dayID);

    if (list.isNotEmpty) {
      exercisesList = list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monday Excercises"),
        backgroundColor: Colors.blue[200],
      ),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: SizedBox(
                      width: 75,
                      height: 75,
                      child: CircularProgressIndicator(strokeWidth: 5)));
            } else {
              return Column(children: [
                Expanded(
                    child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  shrinkWrap: true,
                  children: getExercises(),
                )),
                SizedBox(
                  height: 2,
                ),
                ElevatedButton(
                  onPressed: showExercisePopUp,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text(
                    "Add New Exercise",
                    style: TextStyle(fontSize: 24, color: Colors.green),
                  ),
                ),
                SizedBox(
                  height: 18,
                )
              ]);
            }
          }),
    );
  }

  List<Widget> getExercises() {
    List<Widget> result = [];
    Random rnd = Random();
    for (var i = 0; i < exercisesList.length; i++) {
      Map<String, dynamic> thisEx = exercisesList[i];
      result.add(Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
              child: GestureDetector(
                  onTap: () {
                    showExercisePopUp(
                        exName: thisEx["name"],
                        exWeight: thisEx["weight"],
                        exSets: thisEx["sets"],
                        exReps: thisEx["reps"],
                        exTime: thisEx["duration"],
                        exID: thisEx["ex_id"]);
                  },
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          alignment: Alignment.topLeft,
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.only(left: 20, top: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(
                                (15 + rnd.nextInt(225)),
                                (15 + rnd.nextInt(235)),
                                (15 + rnd.nextInt(225)),
                                1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(children: [
                                Text(
                                  "${thisEx["name"]}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  "Weight: ${thisEx["weight"]}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  "Sets: ${thisEx["sets"]}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  "Reps: ${thisEx["reps"]}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  "Time: ${thisEx["duration"]}min",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )
                              ]),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () => {},
                                      icon: const Icon(Icons.done_rounded))
                                ],
                              )
                            ],
                          )))))));
    }
    return result;
  }

  void showExercisePopUp(
      {String exName = "",
      int exWeight = 10,
      int exSets = 1,
      int exReps = 10,
      int exTime = 10,
      int exID = 0,
      bool updating = false}) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Add/Edit Exercise"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Text("Exercise Name:"),
                    Expanded(child: TextField(
                      onChanged: (text) {
                        exName = text;
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
                              value: index + 1, child: Text("${index + 1}"));
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
                              value: index + 1, child: Text("${index + 1}"));
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
                              value: index + 1, child: Text("${index + 1}"));
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
                              value: index + 1, child: Text("${index + 1}"));
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
              contentPadding: EdgeInsets.all(10),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      String trimmed = exName.trim();
                      if (trimmed == "") {
                        Fluttertoast.showToast(
                            msg: "Please! Give Exercise Name",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM);
                      } else if (updating) {
                        DatabaseHandler.instance.updateRowInDB(
                            "Excercises",
                            {
                              "name": trimmed,
                              "weight": exWeight,
                              "sets": exSets,
                              "reps": exReps,
                              "duration": exTime,
                              "day_id": widget.dayID
                            },
                            "ex_id",
                            exID);
                        super.setState(() {
                          exercisesList;
                        });
                        Navigator.pop(context);
                      } else {
                        DatabaseHandler.instance.insertInDB("Excercises", {
                          "name": trimmed,
                          "weight": exWeight,
                          "sets": exSets,
                          "reps": exReps,
                          "duration": exTime,
                          "day_id": widget.dayID
                        });
                        super.setState(() {
                          exercisesList;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text("OK"))
              ],
            );
          });
        });
  }
}
