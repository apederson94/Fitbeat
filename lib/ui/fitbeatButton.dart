import 'package:flutter/material.dart';

class FitbeatButton {
  static FlatButton create({String text, @required Function onPressed}) {
    return FlatButton(
      color: Colors.blueAccent,
      child: Text(text, style: TextStyle(color: Colors.white)),
      onPressed: onPressed,
    );
  }
}
