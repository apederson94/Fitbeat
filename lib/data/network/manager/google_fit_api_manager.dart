import 'dart:convert';

import 'package:fitbeat/data/db/managers/google_fit_hive_manager.dart';
import 'package:fitbeat/data/db/models/google_fit_bucket.dart';
import 'package:fitbeat/data/network/manager/fitbit_api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:fitbeat/data/db/managers/account_details_manager.dart';
import 'package:fitbeat/data/db/models/account_details.dart';
import 'package:fitbeat/utils/extensions.dart';

class GoogleFitApiManager {
  String buildGoogleEndpoint(String resourcePath) {
    return 'https://www.googleapis.com/fitness/v1/$resourcePath';
  }

  Future<dynamic> getSteps() async {
    AccountDetails account = AccountDetailsHiveManager().getAccount('account');
    String url = buildGoogleEndpoint('users/me/dataset:aggregate');
    Map<String, String> headers = Map<String, String>();
    Map<String, dynamic> body = Map<String, dynamic>();
    Map<String, String> aggregateBy = Map<String, String>();
    Map<String, dynamic> bucketByTime = Map<String, dynamic>();

    headers['Content-Type'] = "application/json;encoding=utf-8";
    headers['Authorization'] = "Bearer ${account.googleAccessToken}";

    aggregateBy['dataTypeName'] = 'com.google.step_count.delta';
    aggregateBy['dataSourceId'] = 'derived:com.google.step_count.delta:com.google.android.gms:estimated_steps';

    body['aggregateBy'] = [aggregateBy];

    bucketByTime['durationMillis'] = 86400000;
    body['bucketByTime'] = bucketByTime;
    body['startTimeMillis'] = DateTime.now().subtract(Duration(days: 7)).stripTime().millisecondsSinceEpoch;
    body['endTimeMillis'] = DateTime.now().stripTime().millisecondsSinceEpoch;
    http.Response stepsResponse = await http.post(url, headers: headers, body: json.encode(body)).catchError((error) {
      error.toString();
    });
    String responseBody = stepsResponse.body;
    var jsonResponse = jsonDecode(stepsResponse.body);
    GoogleFitBucket bucket = GoogleFitBucket(jsonResponse);

    await GoogleFitHiveManager().initialize();
    GoogleFitHiveManager().saveNewBucket(bucket);

    FitbitApiManager fitbitApiManager = FitbitApiManager();
    bucket.entries.forEach((entry) {
      fitbitApiManager.setSteps(entry);
    });

    return jsonResponse;
  }
}