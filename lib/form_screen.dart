import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Settings"),
      ),
      body: Column(children: [
        Expanded(
            child: ListView(
          children: getFormWidgets(),
        )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () => {},
          child: const Text(
            "Save",
            style: TextStyle(fontSize: 28, color: Colors.green),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ]),
    );
  }

  List<Widget> getFormWidgets() {
    return [
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Name",
                labelStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Age",
                labelStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Gender",
                labelStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Weight",
                labelStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          )),
      Column(children: getFormDays())
    ];
  }

  List<Widget> getFormDays() {
    List<Widget> result = [];
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    for (var i = 0; i < days.length; i++) {
      result.add(Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all()),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    days[i],
                    style: const TextStyle(fontSize: 20),
                  )),
                  Switch.adaptive(value: false, onChanged: (s) => {})
                ],
              ))));
    }
    return result;
  }
}
