import 'package:fitbeat/data/db/models/google_fit_step_entry.dart';
import 'package:hive/hive.dart';

part 'google_fit_bucket.g.dart';

@HiveType()
class GoogleFitBucket extends HiveObject{

  @HiveField(0)
  List<GoogleFitStepEntry> entries = List();

  @HiveField(1)
  int requestTimeInMillis;

  GoogleFitBucket.empty();

  GoogleFitBucket(Map<String, dynamic> googleResponse) {
    var bucket = googleResponse['bucket'] as List<dynamic>;
    requestTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    bucket.forEach((entry) {
      String startTimeMillis = entry["startTimeMillis"];
      String endTimeMillis = entry["endTimeMillis"];
      List entryDataset = entry["dataset"][0]["point"];
      if (entryDataset.length > 0) {
        int stepCount = entry["dataset"][0]["point"][0]["value"][0]["intVal"];
        GoogleFitStepEntry newStepEntry = GoogleFitStepEntry(startTimeMillis, endTimeMillis, stepCount);
        entries.add(newStepEntry);
      }
    });
  }
}