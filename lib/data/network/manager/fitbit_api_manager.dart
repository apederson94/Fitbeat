import 'package:fitbeat/data/db/managers/account_details_manager.dart';
import 'package:fitbeat/data/db/models/account_details.dart';
import 'package:fitbeat/data/db/models/google_fit_step_entry.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FitbitApiManager {
  void setSteps(GoogleFitStepEntry stepEntry) async {
    AccountDetails account = AccountDetailsHiveManager().getAccount('account');
    int activityId =
        90013; //90013 = walking for Fitbit api. walking & running only activities with steps
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(stepEntry.startTimeMillis));
    //DateFormat timeFormat = DateFormat("hh:MM:00");
    DateFormat calDateFormat = DateFormat("yyyy-MM-dd");
    String startTime = '00:00:00';
    int durationMillis =
    86400000; //1 day in milliseconds because Google Fit returned steps for a day without active time. will fix that bug later
    String date = calDateFormat.format(startDate);

    String url = 'https://api.fitbit.com/1/user/-/activities.json';

    Map<String, String> headers = Map<String, String>();

    headers['Content-Type'] = "application/json;encoding=utf-8";
    headers['Authorization'] = "Bearer ${account.fitbitToken}";

    url +=
        '?activityId=$activityId&startTime=$startTime&durationMillis=$durationMillis&date=$date&distance=${stepEntry.stepCount}&distanceUnit=steps';

    http.Response httpResponse =
        await http.post(url, headers: headers).catchError((error) {
      error.toString();
    });

    String httpBody = httpResponse.body;
  }
}
