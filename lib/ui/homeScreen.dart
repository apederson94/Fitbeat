import 'package:fitbeat/ui/dashboard.dart';
import 'package:fitbeat/ui/stepsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Destination> _children = [
    Destination(title: "Fitbeat", body: Dashboard()),
    Destination(title: "Steps", body: StepsScreen())
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Destination destination = _children[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
      ),
      body: destination.body,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home), activeIcon: Icon(Icons.home, color: Colors.blueAccent,)),
          BottomNavigationBarItem(
              title: Text("Steps"), icon: Icon(Icons.directions_walk), activeIcon: Icon(Icons.directions_walk, color: Colors.blueAccent)),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class Destination {
  String title;
  Widget body;

  Destination({title: String, body: Widget}) {
    this.title = title;
    this.body = body;
  }
}
