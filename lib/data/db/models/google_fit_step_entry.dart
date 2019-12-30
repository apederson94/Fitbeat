import 'package:hive/hive.dart';

class GoogleFitStepEntry extends HiveObject {
  @HiveField(0)
  String startTimeMillis;

  @HiveField(1)
  String endTimeMillis;

  @HiveField(2)
  int stepCount;

  GoogleFitStepEntry(String start, String end, int steps) {
    startTimeMillis = start;
    endTimeMillis = end;
    stepCount = steps;
  }
}