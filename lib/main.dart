import 'package:fitbeat/data/db/managers/google_fit_hive_manager.dart';
import 'package:fitbeat/ui/homeScreen.dart';
import 'package:fitbeat/ui/stepsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/assets/fitbeatConstants.dart';

void main() => runApp(MaterialApp(
        title: FitbeatConstants.fitbeatTitle,
        routes: <String, WidgetBuilder>{
          '/': (context) => HomeScreen(),
          '/steps': (context) => StepsScreen()
        }));