// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monday Excercises"),
        backgroundColor: Colors.blue[200],
      ),
      body: Column(children: [
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
          onPressed: _showExercisePopUp,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: Text(
            "Add New Exercise",
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
        ),
        SizedBox(
          height: 18,
        )
      ]),
    );
  }

  List<Widget> getExercises() {
    List<Widget> result = [];
    Random rnd = Random();
    for (var i = 0; i < 10; i++) {
      result.add(Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Center(
              child: GestureDetector(
                  onTap: () {
                    _showExercisePopUp();
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
                              Column(children: const [
                                Text(
                                  "Weight Lifting",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  "Weight: 12",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  "Sets: 2",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  "Reps: 10",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  "Time: 15min",
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

  void _showExercisePopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add/Edit Exercise"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Exercise Name:"),
              ],
            ),
            contentPadding: EdgeInsets.all(10),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }
}
