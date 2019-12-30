
import 'dart:io';

import 'package:fitbeat/data/db/models/google_fit_bucket.dart';
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
      //Hive.registerAdapter(, 0);
      initialized = true;
    }
    if (!Hive.isBoxOpen('account')) {
      Box<GoogleFitBucket> box = await Hive.openBox<GoogleFitBucket>('account');
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
  
  GoogleFitBucket saveNewBucket(GoogleFitBucket bucket) {
    box.add(bucket);
  }

  DateTime getLatestRequestTime() {
    List<GoogleFitBucket> allBuckets = getAllBuckets();
    if (allBuckets != null) {
      int latest = 0;
      allBuckets.forEach((bucket) {
        int requestTime = bucket.requestTimeInMillis;
        if (requestTime > latest) {
          latest = requestTime;
        }
      });
    }
  }
}