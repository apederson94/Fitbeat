import 'package:fitbeat/data/assets/fitbeatConstants.dart';
import 'package:fitbeat/data/db/managers/google_fit_hive_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
        child: FutureBuilder(
          future: GoogleFitHiveManager().initialize(),
          builder: (context, AsyncSnapshot<GoogleFitHiveManager> snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  FitbeatConstants.steps,
                  textDirection: TextDirection.ltr,
                ),
              ),
              body: snapshot.hasData
                  ? snapshot.data.getAllBuckets().isNotEmpty
                  ? Text('NEED TO BUILD TABLE OF STEPS STILL')
                  : Text('USER DOES NOT HAVE DATA')
                  : Text("COULD NOT FIND DATABASE"),
            );
          },
        ));
  }
}
