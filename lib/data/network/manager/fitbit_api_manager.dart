import 'dart:convert';

import 'package:fitbeat/data/db/managers/account_details_manager.dart';
import 'package:fitbeat/data/db/models/account_details.dart';
import 'package:http/http.dart' as http;
import 'package:fitbeat/data/db/models/google_fit_step_entry.dart';
import 'package:convert/convert.dart';

class FitbitApiManager {
  void setSteps(GoogleFitStepEntry stepEntry) async {
    AccountDetails account = AccountDetailsHiveManager().getAccount('account');
    int activityId = 90013; //90013 = walking for Fitbit api
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(int.parse(stepEntry.startTimeMillis));
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(int.parse(stepEntry.endTimeMillis));
    String start = "${startDate.hour}:${startDate.minute}:${startDate.second}";
    int durationMillis = endDate.difference(startDate).inMilliseconds;
    String date = "${startDate.year}-${startDate.month}-${startDate.day}";
    int distance = 0;

    String url = 'https://api.fitbit.com/1/user/-/activities.json';

    Map<String, String> headers = Map<String, String>();
    Map<String, dynamic> body = Map<String, dynamic>();

    headers['Content-Type'] = "application/json;encoding=utf-8";
    headers['Authorization'] = "Bearer ${account.fitbitToken}";

    url+='?activityId=$activityId&startTime=$start&durationMillis=$durationMillis&date=$date&distance=${stepEntry.stepCount}&distanceUnit=steps';

    http.Response httpResponse = await http.post(url, headers: headers).catchError((error) {
      error.toString();
    });

    String httpBody = httpResponse.body;
    httpBody.length;
  }
}
