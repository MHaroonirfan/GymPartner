import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_partener/database.dart';
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
    for (var i = dayNames.length - 1; i >= 0; i--) {
      Map<String, dynamic>? dbRes =
          await DatabaseHandler.instance.getFromDB("Days", "day", dayNames[i]);
      if (dbRes == null) {
        dayNames.remove(dayNames[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  )));
                    },
                    child: Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.only(left: 20, top: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(
                              (15 + rnd.nextInt(225)),
                              (15 + rnd.nextInt(235)),
                              (15 + rnd.nextInt(225)),
                              1),
                        ),
                        child: Text(
                          dayNames[i],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        )))),
          ),
        );
      }
    }

    return days;
  }
}
