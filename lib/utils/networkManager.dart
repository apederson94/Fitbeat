import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fitbeat/utils/extensions.dart';

class GoogleAuthInfo {
  String clientId;
  String projectId;
  String authUri;
  String tokenUri;
  String authProviderCertUrl;
  String clientSecret;
  List<String> redirectUris;
  List<String> scopes;

  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  GoogleAuthInfo(Map<String, dynamic> jsonObject) {
    final json = jsonObject['installed'];
    clientId = json['client_id'];
    projectId = json['project_id'];
    authUri = json['auth_uri'];
    tokenUri = json['token_uri'];
    authProviderCertUrl = json['auth_provider_x509_cert_url'];
    clientSecret = json['client_secret'];
    List<dynamic> tmpArray = json['redirect_uris'];
    redirectUris = tmpArray.convertToStringList();
    tmpArray = json['scopes'];
    scopes = tmpArray.convertToStringList();
  }
}

class NetworkManager {
  GoogleAuthInfo googleAuthInfo;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount account;
  bool isLoggedIn = false;
  static NetworkManager instance;

  static Future<NetworkManager> getInstance() async {
    if (instance == null) {
      String authJson = await GoogleAuthInfo.getFileData("assets/google_auth.json");
      instance = NetworkManager();
      GoogleAuthInfo authInfo = GoogleAuthInfo(jsonDecode(authJson));
      instance.googleAuthInfo = authInfo;
      var scopes = authInfo.scopes;
      instance._googleSignIn = GoogleSignIn(scopes: scopes, clientId: authInfo.clientId);
    }

    return instance;
  }

  Future<GoogleSignInAccount> login() async {
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }

    return account;
  }
}