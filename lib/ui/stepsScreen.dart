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
                      itemCount: snapshot.data.getAllBuckets().length,
                      itemBuilder: (context, bucketIndex) {
                        return ListView.builder(
                            itemCount: snapshot.data
                                .getAllBuckets()[bucketIndex]
                                .entries
                                .length,
                            itemBuilder: (context, entryIndex) {
                              return Text(snapshot.data
                                      .getAllBuckets()[bucketIndex]
                                      .entries[entryIndex]
                                      .startTimeMillis +
                                  "${snapshot.data.getAllBuckets()[bucketIndex].entries[entryIndex].stepCount}");
                            });
                      },
                    ).build(context)
                  : Text('USER DOES NOT HAVE DATA')
              : Text("COULD NOT FIND DATABASE"),
        );
      },
    ));
  }
}
