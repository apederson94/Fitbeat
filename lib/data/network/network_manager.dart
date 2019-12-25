import 'dart:convert';

import 'package:fitbeat/data/db/managers/account_manager.dart';
import 'package:fitbeat/data/db/models/account_details.dart';
import 'package:fitbeat/utils/extensions.dart';
import 'package:fitbeat/utils/utils.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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
  static NetworkManager _instance;

  static Future<NetworkManager> getInstance() async {
    if (_instance == null) {
      String authJson =
          await GoogleAuthInfo.getFileData("assets/google_auth.json");
      _instance = NetworkManager();
      GoogleAuthInfo authInfo = GoogleAuthInfo(jsonDecode(authJson));
      _instance.googleAuthInfo = authInfo;
      var scopes = authInfo.scopes;
      _instance._googleSignIn =
          GoogleSignIn(scopes: scopes, clientId: authInfo.clientId);
    }

    return _instance;
  }

  Future<GoogleSignInAccount> login() async {
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.signIn();
      AccountManager accountManager = AccountManager();
      await accountManager.initialize();
      accountManager.saveNewAccount(AccountDetails(account));
    } catch (error) {
      print(error);
    }
    return account;
  }

  String _buildFitbitUrl(Map<String, dynamic> cryptoKeys) {
    String clientId = '22BBXX';
    String responseType = 'code';
    String scope = 'activity';
    String redirect_uri ='https://fitbeat.page.link/jdF1';
    String code_challenge = cryptoKeys['encoded'].toString();
    String code_challenge_method = 'S256';
    String url =  'https://www.fitbit.com/oauth2/authorize';
    url += '?client_id=$clientId';
    url += '&response_type=$responseType';
    url += '&scope=$scope';
    url += '&redirect_uri=$redirect_uri';
    url += '&code_challenge=$code_challenge';
    url += '&code_challenge_method=$code_challenge_method';

    return url;
  }

  void authorizeFitbit() async {
    Map<String, dynamic> cryptoKeys = utils.createCryptoRandomString();
    String url = _buildFitbitUrl(cryptoKeys);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //TODO
    }
  }
}
