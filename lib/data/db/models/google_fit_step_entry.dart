import 'package:hive/hive.dart';

part 'google_fit_step_entry.g.dart';


@HiveType()
class GoogleFitStepEntry extends HiveObject {
  @HiveField(0)
  String startTimeMillis;

  @HiveField(1)
  String endTimeMillis;

  @HiveField(2)
  int stepCount;

  GoogleFitStepEntry.empty();

  GoogleFitStepEntry(String start, String end, int steps) {
    startTimeMillis = start;
    endTimeMillis = end;
    stepCount = steps;
  }
}