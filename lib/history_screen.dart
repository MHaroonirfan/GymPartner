import 'package:flutter/material.dart';
import 'package:gym_partener/database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("History"), backgroundColor: Colors.blue[200]),
      body: FutureBuilder(
          future: getHistory(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator.adaptive();
            } else {
              return ListView(children: snapShot.data!);
            }
          }),
    );
  }

  Future<List<Widget>> getHistory() async {
    print("2");
    List<Widget> historyResult = [];
    List<Map<String, dynamic>> prevdays =
        await DatabaseHandler.instance.getPrevDays();

    for (var i = 0; i < prevdays.length; i++) {
      int? pDayID = prevdays[i]["p_day_id"];
      Widget tile = ExpansionTile(
        title: Text("${prevdays[i]["date"]}(${prevdays[i]["day"]})"),
        leading: Icon(Icons.info),
        children: <Widget>[
          FutureBuilder(
              future: getExcercises(pDayID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator.adaptive();
                } else {
                  return Column(children: snapshot.data!);
                }
              })
        ],
      );
      historyResult.add(tile);
      print("object");
    }

    return historyResult;
  }

  Future<List<Widget>> getExcercises(int? dayId) async {
    List<Map<String, dynamic>> exercises = [];
    List<Widget> result = [];
    if (dayId != null) {
      exercises = await DatabaseHandler.instance
          .getExercisesFromDB("DoneExcercises", "p_day_id", dayId);
    } else {
      return result;
    }
    if (exercises.isNotEmpty) {
      for (var i = 0; i < exercises.length; i++) {
        print(exercises.length);
        result.add(Padding(
          padding: EdgeInsets.only(left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${exercises[i]["name"]}",
                style: TextStyle(fontSize: 24),
              ),
              Row(
                children: [
                  Text("Weight: ${exercises[i]["weight"]}, ",
                      style: TextStyle(fontSize: 16)),
                  Text("Sets: ${exercises[i]["sets"]}, ",
                      style: TextStyle(fontSize: 16)),
                  Text("Reps: ${exercises[i]["reps"]}, ",
                      style: TextStyle(fontSize: 16)),
                  Text("Duration: ${exercises[i]["duration"]}",
                      style: TextStyle(fontSize: 16))
                ],
              )
            ],
          ),
        ));
      }
    }

    return result;
  }
}
