import 'package:fitbeat/data/assets/fitbeatConstants.dart';
import 'package:fitbeat/data/db/managers/google_fit_hive_manager.dart';
import 'package:fitbeat/ui/fitbeat_layout.dart';
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
        return FitbeatLayout.create(
          title: FitbeatConstants.steps,
          body: snapshot.hasData
              ? snapshot.data.getAllBuckets().isNotEmpty
                  ? ListView.builder(
                      itemCount: snapshot.data.getAllSteps().length,
                      itemBuilder: (context, entryIndex) {
                        return Text("start: " +
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                    snapshot.data
                                        .getAllSteps()[entryIndex]
                                        .startTimeMillis))
                                .toIso8601String() +
                            " steps: ${snapshot.data.getAllSteps()[entryIndex].stepCount}");
                      })
                  : Text('USER DOES NOT HAVE DATA')
              : Text("COULD NOT FIND DATABASE"),
        );
      },
    ));
  }
}
