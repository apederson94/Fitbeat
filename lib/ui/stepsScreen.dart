import 'package:fitbeat/data/db/managers/google_fit_hive_manager.dart';
import 'package:fitbeat/utils/extensions.dart';
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
        return snapshot.hasData
            ? snapshot.data.getAllBuckets().isNotEmpty
                ? SizedBox.expand(
                    child: SingleChildScrollView(
                        child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                          label: Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                      DataColumn(
                          label: Text(
                        "Steps",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ))
                    ],
                    rows: snapshot.data
                        .getDailyStepEntries()
                        .entries
                        .map(((element) => DataRow(cells: <DataCell>[
                              DataCell(Text(element.key,
                                  style: TextStyle(fontSize: 16))),
                              DataCell(Text(
                                  element.value.getTotalSteps().toString(),
                                  style: TextStyle(fontSize: 16)))
                            ])))
                        .toList()
                        .reversed
                        .toList(),
                  )))
                : Center(child: Text('USER DOES NOT HAVE DATA'))
            : Center(
                child: Text('Loading...'),
              );
      },
    ));
  }
}
