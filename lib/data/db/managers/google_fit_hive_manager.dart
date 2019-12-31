
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
  
  void saveNewBucket(GoogleFitBucket bucket) {
    box.add(bucket);
  }

  int getLatestRequestTime() {
    List<GoogleFitBucket> allBuckets = getAllBuckets();
    int latest = DateTime.now().subtract(Duration(days: 90)).millisecondsSinceEpoch;
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
}