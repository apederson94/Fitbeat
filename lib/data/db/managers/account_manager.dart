import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/account_details.dart';

class AccountManager {
  static final AccountManager _manager = AccountManager._create();
  Box<AccountDetails> box;
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
    if (!Hive.isBoxOpen('account')) {
      Box<AccountDetails> box = await Hive.openBox<AccountDetails>('account');
      this.box = box;
    }
    return this;
  }

  void saveNewAccount(AccountDetails account) {
    box.put('account', account);
  }

  AccountDetails getAccount(String id) {
    return box.get('account', defaultValue: AccountDetails.empty());
  }
}
