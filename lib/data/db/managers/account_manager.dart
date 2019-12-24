import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/google_account.dart';

class AccountManager {
  static final AccountManager _manager = AccountManager._create();
  Box<GoogleAccount> box;
  bool initialized = false;

  factory AccountManager() {
    return _manager;
  }

  AccountManager._create() {
    //do nothing
  }

  Future<AccountManager> initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (!initialized) {
      Hive.init(directory.path);
      Hive.registerAdapter(GoogleAccountAdapter(), 0);
      initialized = true;
    }
    Box<GoogleAccount> box = await Hive.openBox<GoogleAccount>('account');
    this.box = box;
    return this;
  }

  void saveNewAccount(GoogleAccount account) {
    box.put('account', account);
  }

  GoogleAccount getAccount(String id) {
    return box.get('account', defaultValue: GoogleAccount.empty());
  }
}
