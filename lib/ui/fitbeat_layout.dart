
import 'package:flutter/material.dart';

class FitbeatLayout {
  static Scaffold create({String title, dynamic body, ValueChanged<int> onTap}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home)),
          BottomNavigationBarItem(title: Text("Steps"), icon: Icon(Icons.directions_walk)),
        ],
        onTap: ,
      ),
    );
  }
}