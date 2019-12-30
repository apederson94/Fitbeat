import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'googleAuthInfo.dart';

class AssetManager {
  static Future<GoogleAuthInfo> getGoogleAuthInfo() async {
    String authJson = await rootBundle.loadString("assets/google_auth.json");
    return GoogleAuthInfo(jsonDecode(authJson));
  }

  static Future<dynamic> getStrings() async {
    String stringAssets = await rootBundle.loadString("assets/strings.josn");
    return jsonDecode(stringAssets);
  }
}
