import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/account_details.dart';

class AccountDetailsHiveManager {
  static final AccountDetailsHiveManager _manager = AccountDetailsHiveManager._create();
  Box<AccountDetails> box;
  bool initialized = false;

  factory AccountDetailsHiveManager() {
    return _manager;
  }

  AccountDetailsHiveManager._create() {
    //do nothing
  }

  Future<AccountDetailsHiveManager> initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (!initialized) {
      Hive.init(directory.path);
      Hive.registerAdapter(AccountDetailsAdapter(), 0);
      initialized = true;
    }
    if (!Hive.isBoxOpen('account')) {
      Box<AccountDetails> box = await Hive.openBox<AccountDetails>('account');
      this.box = box;
    }
    return this;
  }

  void saveNewAccount(GoogleSignInAccount googleAccount) async {
    AccountDetails account = AccountDetails(googleAccount);
    GoogleSignInAuthentication auth = await googleAccount.authentication;
    account.googleAccessToken = auth.accessToken;
    box.put('account', account);
  }

  AccountDetails getAccount(String id) {
    return box.get('account', defaultValue: AccountDetails.empty());
  }
}
