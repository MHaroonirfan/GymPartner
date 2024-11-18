import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_partener/colors.dart';
import 'package:gym_partener/database.dart';
import 'package:intl/intl.dart';

class ExercisesScreen extends StatefulWidget {
  final int dayID;
  final String dayName;
  const ExercisesScreen(
      {super.key, required this.dayID, required this.dayName});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Map<String, dynamic>> exercisesList = [];

  DateTime timeNow = DateTime.now();
  String dateText = "";
  String todayName = "";
  bool isToday = false;

  void setToday() {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    int today = timeNow.weekday;
    todayName = weekdays[today - 1];
    if (todayName == widget.dayName) {
      isToday = true;
    }
  }

  Future fetchData() async {
    List<Map<String, dynamic>>? list = await DatabaseHandler.instance
        .getExercisesFromDB("Excercises", "day_id", widget.dayID);

    if (list.isNotEmpty) {
      exercisesList = List<Map<String, dynamic>>.from(list);
    }
  }

  @override
  void initState() {
    super.initState();
    setToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${todayName == widget.dayName ? "${widget.dayName}(Today)" : widget.dayName} Excercises"),
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
                  height: 40,
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
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            title: Text(
                              "Delete This exercise",
                              style: TextStyle(fontSize: 24),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    await DatabaseHandler.instance.deleteARow(
                                        "Excercises", "ex_id", thisEx["ex_id"]);
                                    setState(() {
                                      exercisesList.remove(thisEx);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ],
                          );
                        });
                  },
                  onTap: () {
                    showExercisePopUp(
                        exName: thisEx["name"],
                        exWeight: thisEx["weight"],
                        exSets: thisEx["sets"],
                        exReps: thisEx["reps"],
                        exTime: thisEx["duration"],
                        exID: thisEx["ex_id"],
                        updating: true);
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
                            color: CustomColors.cColors[
                                rnd.nextInt(CustomColors.cColors.length)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(children: [
                                Text(
                                  "${thisEx["name"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
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
                              if (isToday)
                                CircleAvatar(
                                    backgroundColor: Colors.blue[100],
                                    child: IconButton(
                                        onPressed: () {
                                          showExercisePopUp(
                                              exName: thisEx["name"],
                                              exWeight: thisEx["weight"],
                                              exSets: thisEx["sets"],
                                              exReps: thisEx["reps"],
                                              exTime: thisEx["duration"],
                                              exID: thisEx["ex_id"],
                                              saving: true);
                                        },
                                        icon: Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        ))),
                            ],
                          )))))));
    }
    return result;
  }

  Future showExercisePopUp(
      {String exName = "",
      int exWeight = 10,
      int exSets = 1,
      int exReps = 10,
      int exTime = 10,
      int exID = 0,
      bool saving = false,
      bool updating = false}) async {
    TextEditingController controller = TextEditingController();
    String trimmed = exName.trim();
    print("Ex : $exName");
    print(trimmed);
    controller.text = exName;
    Map<String, dynamic>? checkSave =
        await DatabaseHandler.instance.getFromDB("Excercises", "name", exName);
    int prevDayId = await getPrevDayId();
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
                    saving
                        ? Expanded(
                            child: Row(
                                children: [Spacer(), Text(exName), Spacer()]))
                        : Expanded(
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
                      } else if (saving) {
                        if (checkSave == null) {
                          DatabaseHandler.instance
                              .insertInDB("DoneExcercises", {
                            "name": trimmed,
                            "weight": exWeight,
                            "sets": exSets,
                            "reps": exReps,
                            "duration": exTime,
                            "p_day_id": prevDayId,
                            "day": todayName
                          });
                          super.setState(() {
                            exercisesList;
                          });
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Excercise Saved Already",
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_LONG);
                          Navigator.pop(context);
                        }
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

  Future<int> getPrevDayId() async {
    DateFormat dateFormat = DateFormat("dd MMM yy");
    dateText = dateFormat.format(timeNow);
    Map<String, dynamic>? dayDB =
        await DatabaseHandler.instance.getFromDB("PrevDays", "date", dateText);

    if (dayDB != null) {
      return dayDB["p_day_id"];
    } else {
      DatabaseHandler.instance
          .insertInDB("PrevDays", {"day": todayName, "date": dateText});
      dayDB = await DatabaseHandler.instance
          .getFromDB("PrevDays", "date", dateText);
      return dayDB!["p_day_id"];
    }
  }
}
