import 'package:flutter/material.dart';

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
      body: ListView(children: getHistory()),
    );
  }

  List<Widget> getHistory() {
    List<Widget> historyResult = [];

    for (var i = 0; i < 5; i++) {
      Widget tile = const ExpansionTile(
        title: Text('25 Nov Tue'),
        leading: Icon(Icons.info),
        children: <Widget>[
          Text('First item detail 1'),
          Text('First item detail 2'),
        ],
      );
      historyResult.add(tile);
    }

    return historyResult;
  }
}
