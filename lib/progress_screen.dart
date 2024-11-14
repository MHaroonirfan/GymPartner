import 'package:flutter/material.dart';
import 'package:gym_partener/days_chart.dart';
import 'package:gym_partener/exercises_chart.dart';
// import 'package:gym_partener/exercises_chart.dart';

class PreogressScreen extends StatefulWidget {
  const PreogressScreen({super.key});

  @override
  State<PreogressScreen> createState() => _PreogressScreenState();
}

class _PreogressScreenState extends State<PreogressScreen> {
  Widget chartWidget = const DaysChart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Progress"),
          backgroundColor: Colors.blue[200],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => {
                    setState(() {
                      chartWidget = const DaysChart();
                    })
                  },
                  child: const Text(
                    "By Day",
                    style: TextStyle(fontSize: 28, color: Colors.green),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => {
                    setState(() {
                      chartWidget = const ExercisesChart();
                    })
                  },
                  child: const Text(
                    "By Exercise",
                    style: TextStyle(fontSize: 28, color: Colors.green),
                  ),
                ),
                const Spacer()
              ],
            ),
            chartWidget
          ],
        ));
  }
}
