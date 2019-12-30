
import 'package:fitbeat/data/assets/assetManager.dart';
import 'package:fitbeat/data/db/managers/account_details_manager.dart';
import 'package:fitbeat/data/db/managers/google_fit_hive_manager.dart';
import 'package:fitbeat/data/network/manager/auth_api_manager.dart';
import 'package:fitbeat/data/network/manager/google_fit_api_manager.dart';

class SuperManager {
  AccountDetailsHiveManager accountDetailsHiveManager;
  GoogleFitHiveManager googleFitHiveManager;
  AuthApiManager authManager;
  GoogleFitApiManager googleFitManager;
  var stringAssets;

  static final SuperManager _manager = SuperManager._create();
  bool initialized = false;

  factory SuperManager() {
    return _manager;
  }

  SuperManager._create() {
    //do nothing
  }

  Future<SuperManager> initialize() async {
    accountDetailsHiveManager = await AccountDetailsHiveManager().initialize();
    googleFitHiveManager = await GoogleFitHiveManager().initialize();
    authManager = await AuthApiManager.getInstance();
    googleFitManager = GoogleFitApiManager();
    //stringAssets = await AssetManager.getStrings();
    return this;
  }
}