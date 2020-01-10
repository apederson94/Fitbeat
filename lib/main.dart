import 'dart:async';

import 'package:fitbeat/data/network/manager/auth_api_manager.dart';
import 'package:fitbeat/data/network/manager/google_fit_api_manager.dart';
import 'package:fitbeat/utils/fitbeat_deeplink.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'data/assets/stringConstants.dart';
import 'data/db/models/account_details.dart';
import 'data/super_manager.dart';
import 'utils/utils.dart';

class _HomeScreenState extends State<HomeScreen> {
  Future<SuperManager> superManager;
  StreamSubscription _deeplinkSub;

  @override
  void initState() {
    super.initState();
    superManager = SuperManager().initialize();
    superManager.then((manager) {
      manager.authManager.login();
    });
    initUniLinks();
  }

  void handleDeeplink(String link) async {
    try {
      //String initialLink = await getInitialLink();
      FitbeatDeeplink deeplink = FitbeatDeeplink(link);
      if (deeplink.target == StringConstants.auth) {
        Map<String, dynamic> mappedDeeplink =
            utils.parseAuthDeeplink(deeplink.path);
        superManager.then((manager) {
          AccountDetails account = manager.accountDetailsHiveManager
              .getAccount(StringConstants.account);
          account.fitbitToken = mappedDeeplink[StringConstants.accessTokenSC];
          account.userId = mappedDeeplink[StringConstants.userIdSC];
          account.scopes.add(mappedDeeplink[StringConstants.scope]);
          account.tokenType = mappedDeeplink[StringConstants.tokenTypeSC];
          account.expiresIn = mappedDeeplink[StringConstants.expiresInSC];
          account.save();
        });
      }
    } catch (PlatformException) {
      //TODO
    }
  }

  void initUniLinks() async {
    _deeplinkSub = getLinksStream().listen((String link) {
      handleDeeplink(link);
    }, onError: (err) {
      utils.log_amp(err.toString());
    });

    handleDeeplink(await getInitialLink());
  }

  @override
  void dispose() {
    _deeplinkSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder(
            future: superManager,
            builder: (context, AsyncSnapshot<SuperManager> snapshot) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      StringConstants.fitbeatTitle,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  body: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        snapshot.hasData
                            ? WatchBoxBuilder(
                                box:
                                    snapshot.data.accountDetailsHiveManager.box,
                                builder: (context, accountBox) {
                                  AccountDetails account =
                                      accountBox.get(StringConstants.account);
                                  return Column(
                                    children: <Widget>[
                                      account.displayName != null
                                          ? Text(StringConstants
                                                  .thanksForLoggingIn +
                                              account.displayName)
                                          : FlatButton(
                                              color: Colors.blueAccent,
                                              child: Text(
                                                StringConstants.pleaseLogin,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                snapshot.data
                                                    .accountDetailsHiveManager
                                                    .saveNewAccount(
                                                        await snapshot
                                                            .data.authManager
                                                            .login());
                                              }),
                                      account.fitbitToken != null
                                          ? Text(StringConstants
                                              .fitbitAuthenticated)
                                          : FlatButton(
                                              color: Colors.blueAccent,
                                              child: Text(
                                                  StringConstants
                                                      .connectToFitbit,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                AuthApiManager.getInstance()
                                                    .then((manager) {
                                                  manager.authorizeFitbit();
                                                });
                                              },
                                            ),
                                    ],
                                  );
                                },
                              )
                            : Text(StringConstants.uhOh),
                        FlatButton(
                          color: Colors.blueAccent,
                          child: Text(
                            StringConstants.makeRequest,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await GoogleFitApiManager().getSteps();
                          },
                        ),
                      ])));
            }));
  }
}

void main() => runApp(MaterialApp(
    title: StringConstants.fitbeatTitle,
    routes: <String, WidgetBuilder>{'/': (context) => HomeScreen()}));

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
