import 'package:flutter/material.dart';
import 'package:gym_partener/form_screen.dart';
import 'package:gym_partener/history_screen.dart';
import 'package:gym_partener/home_screen.dart';
import 'package:gym_partener/progress_screen.dart';
import 'package:gym_partener/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.instance.getPrefs();

  runApp(const GymPartner());
}

class GymPartner extends StatelessWidget {
  const GymPartner({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Gym Partner",
      home: AppHomeScreen(),
    );
  }
}

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  int _selectedIndex = 0;

  bool _isHomeSelected = true;

  List<Widget> screens = [
    const HomeScreen(),
    const PreogressScreen(),
    const HistoryScreen()
  ];

  void _itemTapped(index) {
    if (index == 0) {
      _isHomeSelected = true;
    } else {
      _isHomeSelected = false;
    }
    setState(() {
      _isHomeSelected;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(),
      appBar: AppBar(
        title: const Text("Gym Partner"),
        backgroundColor: Colors.blue[200],
        actions: [
          if (_isHomeSelected)
            IconButton(
              icon: const Icon(
                Icons.edit_note_rounded,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FormScreen()));
              },
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.auto_graph_rounded,
                color: Colors.black,
              ),
              label: "Progress"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                color: Colors.black,
              ),
              label: "History")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _itemTapped,
      ),
      backgroundColor: Colors.blue[200],
      body: screens[_selectedIndex],
    );
  }

  Drawer getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_3_rounded,
                        size: 75,
                        color: Colors.white54,
                      ),
                      Text(
                        "John Cena",
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      )
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Column(children: [Text("Age"), Text("30")]),
                      Spacer(),
                      Column(children: [Text("Weight"), Text("88")]),
                      Spacer(),
                      Column(children: [Text("Height"), Text("181")])
                    ],
                  )
                ],
              )),
          ListTile(
            selectedColor: Colors.blue,
            selected: _selectedIndex == 0 ? true : false,
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              _itemTapped(0);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            selectedColor: Colors.blue,
            selected: _selectedIndex == 1 ? true : false,
            leading: const Icon(Icons.auto_graph),
            title: const Text("Progress"),
            onTap: () {
              _itemTapped(1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            selectedColor: Colors.blue,
            selected: _selectedIndex == 2 ? true : false,
            leading: const Icon(Icons.history_outlined),
            title: const Text("History"),
            onTap: () {
              _itemTapped(2);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
