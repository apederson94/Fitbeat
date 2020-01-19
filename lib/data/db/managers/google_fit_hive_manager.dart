import 'dart:io';

import 'package:fitbeat/data/db/models/google_fit_bucket.dart';
import 'package:fitbeat/data/db/models/google_fit_step_entry.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class GoogleFitHiveManager {
  static final GoogleFitHiveManager _manager = GoogleFitHiveManager._create();
  Box<GoogleFitBucket> box;
  bool initialized = false;

  factory GoogleFitHiveManager() {
    return _manager;
  }

  GoogleFitHiveManager._create() {
    //do nothing
  }

  Future<GoogleFitHiveManager> initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (!initialized) {
      Hive.init(directory.path);
      Hive.registerAdapter(GoogleFitBucketAdapter(), 1);
      Hive.registerAdapter(GoogleFitStepEntryAdapter(), 2);
      initialized = true;
    }
    if (!Hive.isBoxOpen('account')) {
      Box<GoogleFitBucket> box = await Hive.openBox<GoogleFitBucket>('buckets');
      this.box = box;
    }
    return this;
  }

  List<GoogleFitBucket> getAllBuckets() {
    List<GoogleFitBucket> allBuckets = List();
    Iterable<int>.generate(box.length).forEach((index) {
      allBuckets.add(box.getAt(index));
    });

    return allBuckets;
  }

  List<GoogleFitStepEntry> getAllSteps() {
    var buckets = getAllBuckets();
    var steps = List<GoogleFitStepEntry>();
    for (var value in buckets) {
      steps.addAll(value.entries);
    }

    return steps;
  }

  void saveNewBucket(GoogleFitBucket bucket) {
    box.add(bucket);
  }

  int getLatestRequestTime() {
    List<GoogleFitBucket> allBuckets = getAllBuckets();
    int latest =
        DateTime.now().subtract(Duration(days: 60)).millisecondsSinceEpoch;
    if (allBuckets != null) {
      allBuckets.forEach((bucket) {
        int requestTime = bucket.requestTimeInMillis;
        if (requestTime > latest) {
          latest = requestTime;
        }
      });
    }
    return latest;
  }

  Map<String, List<GoogleFitStepEntry>> getDailyStepEntries() {
    Map<String, List<GoogleFitStepEntry>> entriesByDay =
        Map<String, List<GoogleFitStepEntry>>();
    List<GoogleFitStepEntry> dateStepEntry = List<GoogleFitStepEntry>();
    var entries = getAllBuckets();
    DateTime previousDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(entries.first.entries.first.startTimeMillis));

    entries.forEach((bucket) {
      bucket.entries.forEach((entry) {
        var start = entry.startTimeMillis;
        var date = DateTime.fromMillisecondsSinceEpoch(int.parse(start));

        if (previousDate.day != date.day ||
            previousDate.month != date.month ||
            previousDate.year != date.year) {
          String formattedDate = previousDate.month.toString() +
              "/" +
              previousDate.day.toString() +
              "/" +
              previousDate.year.toString();
          entriesByDay[formattedDate] = dateStepEntry;
          dateStepEntry = List<GoogleFitStepEntry>();
        }

        dateStepEntry.add(entry);

        previousDate = date;
      });
    });

    return entriesByDay;
  }
}
