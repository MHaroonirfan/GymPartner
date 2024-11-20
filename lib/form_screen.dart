import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_partener/database.dart';
import 'package:gym_partener/main.dart';
import 'package:gym_partener/shared_pref.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<int> ageList = List.generate(84, (index) => index + 16);
  int age = SharedPref.instance.getIntValue("age") ?? 25;

  List<int> feetList = List.generate(7, (index) => index + 3);
  int heightFeet = SharedPref.instance.getIntValue("height_feet") ?? 5;

  List<int> inchList = List.generate(13, (index) => index);
  int heightInches = SharedPref.instance.getIntValue("height_inches") ?? 6;

  List<int> kList = List.generate(120, (index) => index + 30);
  int weightK = SharedPref.instance.getIntValue("weight_kilo") ?? 50;

  List<int> gList = List.generate(100, (index) => index);
  int weightG = SharedPref.instance.getIntValue("weight_gram") ?? 0;

  String userName = SharedPref.instance.getStringValue("name") ?? "";

  final TextEditingController _controller = TextEditingController();

  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  List<bool> daysSwitch = [true, true, true, true, true, true, true];

  @override
  void initState() {
    super.initState();
    changeSwitches();
  }

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
          onPressed: saveUserData,
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
    _controller.text = userName;
    return [
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextField(
            buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                null,
            autofocus: true,
            maxLength: 64,
            controller: _controller,
            onChanged: (value) {
              userName = value;
            },
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
      const SizedBox(
        height: 5,
      ),
      Divider(indent: 50, endIndent: 50),
      Padding(
          padding: EdgeInsets.only(left: 17.5),
          child: Text("Select your Workout Days")),
      Divider(
        height: 5,
        indent: 25,
        endIndent: 150,
        color: Colors.black,
      ),
      Column(children: getFormDays())
    ];
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
                  child: SizedBox(
                      width: 250,
                      height: 350,
                      child: CupertinoPicker(
                          itemExtent: 30,
                          magnification: 1.25,
                          scrollController: FixedExtentScrollController(
                              initialItem: ageList.indexOf(age)),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              age = ageList[index];
                            });
                          },
                          selectionOverlay:
                              const CupertinoPickerDefaultSelectionOverlay(
                            background: Color.fromARGB(125, 31, 105, 32),
                          ),
                          children: List<Widget>.generate(ageList.length,
                              (index) => Text(ageList[index].toString()))))),
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
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  weightK = kList[index];
                                });
                              },
                              scrollController: FixedExtentScrollController(
                                  initialItem: kList.indexOf(weightK)),
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
                              scrollController: FixedExtentScrollController(
                                  initialItem: gList.indexOf(weightG)),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  weightG = gList[index];
                                });
                              },
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
                child: SizedBox(
                    width: 250,
                    height: 350,
                    child: Row(children: [
                      Expanded(
                          child: CupertinoPicker(
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                background: Color.fromARGB(125, 31, 105, 32),
                                capEndEdge: false,
                              ),
                              itemExtent: 30,
                              scrollController: FixedExtentScrollController(
                                  initialItem: feetList.indexOf(heightFeet)),
                              magnification: 1.25,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  heightFeet = feetList[index];
                                });
                              },
                              children: List<Widget>.generate(feetList.length,
                                  (index) {
                                return Center(
                                  child: Text(feetList[index].toString()),
                                );
                              }))),
                      Expanded(
                          child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                  initialItem: inchList.indexOf(heightInches)),
                              selectionOverlay:
                                  const CupertinoPickerDefaultSelectionOverlay(
                                background: Color.fromARGB(125, 31, 105, 32),
                                capStartEdge: false,
                              ),
                              itemExtent: 30,
                              magnification: 1.25,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  heightInches = inchList[index];
                                });
                              },
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

  List<Widget> getFormDays() {
    List<Widget> result = [];

    for (var i = 0; i < days.length; i++) {
      result.add(Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Container(
              height: 38,
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
                  Switch(
                    value: daysSwitch[i],
                    onChanged: (boolValue) {
                      setState(() {
                        daysSwitch[i] = boolValue;
                      });
                    },
                  )
                ],
              ))));
    }
    return result;
  }

  Future<void> changeSwitches() async {
    for (var i = 0; i < days.length; i++) {
      Map<String, dynamic>? dbRes =
          await DatabaseHandler.instance.getFromDB("Days", "day", days[i]);
      setState(() {
        if (dbRes != null) {
          if (dbRes["selected"] == 1) {
            print(true);
            daysSwitch[i] = true;
          }
        } else {
          daysSwitch[i] = false;
          print("false");
        }
      });
    }
  }

  void saveUserData() async {
    String trimmed = userName.trim();
    if (trimmed == "") {
      Fluttertoast.showToast(
          msg: "Please Give a Name!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR);
    } else {
      SharedPref.instance.setStringValue("name", userName);

      SharedPref.instance.setIntValue("age", age);

      SharedPref.instance.setIntValue("height_feet", heightFeet);

      SharedPref.instance.setIntValue("height_inches", heightInches);

      SharedPref.instance.setIntValue("weight_kilo", weightK);

      SharedPref.instance.setIntValue("weight_gram", weightG);

      for (var i = 0; i < days.length; i++) {
        Map<String, dynamic>? dbres =
            await DatabaseHandler.instance.getFromDB("Days", "day", days[i]);
        if (dbres == null) {
          await DatabaseHandler.instance.insertInDB("Days", {"day": days[i]});
        }

        if (daysSwitch[i]) {
          await DatabaseHandler.instance
              .updateRowInDB("Days", {"selected": 1}, "day", days[i]);
        } else {
          await DatabaseHandler.instance.deleteARow("Days", "day", days[i]);
        }
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppHomeScreen()),
          (Route<dynamic> route) => false);
    }
  }
}
