import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        backgroundColor: Colors.blue[200],
      ),
      body: ListView(
        children: getDaysTasksWidgets(),
      ),
    );
  }

  List<Widget> getDaysTasksWidgets() {
    List<Widget> excerxises = [];
    for (var i = 0; i < 7; i++) {
      excerxises.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
              padding: const EdgeInsets.only(left: 10),
              // height: 50,
              color: Colors.blueGrey[500],
              child: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Tuesday",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              )),
        ),
      );
    }

    return excerxises;
  }
}
