import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<int> ageList = List.generate(84, (index) => index + 16);
  int age = 0;

  List<int> feetList = List.generate(7, (index) => index + 3);
  int heightFeet = 5;

  List<int> inchList = List.generate(12, (index) => index + 1);
  int heightInches = 0;

  List<int> kList = List.generate(120, (index) => index + 30);
  int weightK = 20;

  List<int> gList = List.generate(100, (index) => index);
  int weightG = 0;

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
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.75),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                    child: Text(
                  "Age",
                  style: TextStyle(fontSize: 24),
                )),
                const Spacer(),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          _showAgePicker();
                        },
                        child: Text(
                          age.toString(),
                          style: const TextStyle(fontSize: 24),
                        )))
              ],
            ),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.75),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                    child: Text(
                  "Weight",
                  style: TextStyle(fontSize: 24),
                )),
                const Spacer(),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          _showWeightPicker();
                        },
                        child: Text(
                          "$weightK.$weightG",
                          style: const TextStyle(fontSize: 24),
                        )))
              ],
            ),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.75),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                    child: Text(
                  "Height",
                  style: TextStyle(fontSize: 24),
                )),
                const Spacer(),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          _showHeightPicker();
                        },
                        child: Text(
                          "$heightFeet : $heightInches",
                          style: const TextStyle(fontSize: 24),
                        )))
              ],
            ),
          )),
      Container(
        height: 10,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      ),
      const SizedBox(
        height: 5,
      ),
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
                  Switch(value: false, onChanged: (s) => {})
                ],
              ))));
    }
    return result;
  }

  void _showAgePicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              const Center(
                child: Text(
                  "Pick Your Age",
                  style: TextStyle(fontSize: 32),
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: CupertinoPicker(
                          itemExtent: 30,
                          magnification: 1.25,
                          onSelectedItemChanged: (index) => {},
                          selectionOverlay:
                              const CupertinoPickerDefaultSelectionOverlay(
                            background: Color.fromARGB(125, 31, 105, 32),
                          ),
                          children: List<Widget>.generate(ageList.length,
                              (index) => Text(ageList[index].toString()))))),
              const SizedBox(height: 40)
            ],
          );
        });
  }

  void _showWeightPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(children: [
            const Center(
              child: Text(
                "Pick your Weight",
                style: TextStyle(fontSize: 32),
              ),
            ),
            Expanded(
                child: SizedBox(
                    width: 250,
                    height: 300,
                    child: Row(children: [
                      Expanded(
                          child: CupertinoPicker(
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                background: Color.fromARGB(125, 31, 105, 32),
                                capEndEdge: false,
                              ),
                              itemExtent: 30,
                              magnification: 1.25,
                              onSelectedItemChanged: (index) => {},
                              children:
                                  List<Widget>.generate(kList.length, (index) {
                                return Center(
                                  child: Text(kList[index].toString()),
                                );
                              }))),
                      const Text(
                        ".",
                        style: TextStyle(fontSize: 24),
                      ),
                      Expanded(
                          child: CupertinoPicker(
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                background: Color.fromARGB(125, 31, 105, 32),
                                capStartEdge: false,
                              ),
                              itemExtent: 30,
                              magnification: 1.25,
                              onSelectedItemChanged: (index) => {},
                              children:
                                  List<Widget>.generate(gList.length, (index) {
                                return Center(
                                  child: Text(gList[index] < 10
                                      ? "0${gList[index]}"
                                      : gList[index].toString()),
                                );
                              }))),
                      const Text("KG")
                    ]))),
          ]);
        });
  }

  void _showHeightPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(children: [
            const Center(
              child: Text(
                "Pick your Height",
                style: TextStyle(fontSize: 32),
              ),
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(children: [
                      Expanded(
                          child: CupertinoPicker(
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                background: Color.fromARGB(125, 31, 105, 32),
                                capEndEdge: false,
                              ),
                              itemExtent: 30,
                              scrollController:
                                  FixedExtentScrollController(initialItem: 0),
                              magnification: 1.25,
                              onSelectedItemChanged: (index) => {},
                              children: List<Widget>.generate(feetList.length,
                                  (index) {
                                return Center(
                                  child: Text(feetList[index].toString()),
                                );
                              }))),
                      Expanded(
                          child: CupertinoPicker(
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                background: Color.fromARGB(125, 31, 105, 32),
                                capStartEdge: false,
                              ),
                              itemExtent: 30,
                              magnification: 1.25,
                              onSelectedItemChanged: (index) => {},
                              children: List<Widget>.generate(inchList.length,
                                  (index) {
                                return Center(
                                  child: Text(inchList[index].toString()),
                                );
                              })))
                    ]))),
          ]);
        });
  }
}
