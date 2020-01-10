import 'dart:developer';

import 'package:fitbeat/data/assets/googleAuthInfo.dart';
import 'package:fitbeat/data/db/managers/account_details_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthApiManager {
  GoogleSignIn _googleSignIn;
  static AuthApiManager _instance;

  static Future<AuthApiManager> getInstance() async {
    if (_instance == null) {
      _instance = AuthApiManager();
      var scopes = GoogleAuthInfo.scopes;
      _instance._googleSignIn =
          GoogleSignIn(scopes: scopes, clientId: GoogleAuthInfo.clientId);
    }

    return _instance;
  }

  Future<GoogleSignInAccount> login() async {
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.signIn();
      AccountDetailsHiveManager accountManager = AccountDetailsHiveManager();
      await accountManager.initialize();
      accountManager.saveNewAccount(account);
    } catch (error) {
      print(error);
    }
    return account;
  }

  void authorizeFitbit() async {
    final authEndpoint =
        'https://www.fitbit.com/oauth2/authorize?response_type=token&client_id=22BBXX&redirect_uri=fitbeat%3A%2F%2Fauth&scope=activity';
    if (await canLaunch(authEndpoint)) {
      await launch(authEndpoint);
    } else {
      log('could not launch $authEndpoint', name: 'amp845');
    }
  }
}
