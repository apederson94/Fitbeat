import 'dart:async';

import 'package:fitbeat/data/network/manager/auth_api_manager.dart';
import 'package:fitbeat/data/network/manager/google_fit_api_manager.dart';
import 'package:fitbeat/utils/fitbeat_deeplink.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uni_links/uni_links.dart';

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
      if (deeplink.target == 'auth') {
        Map<String, dynamic> mappedDeeplink =
            utils.parseAuthDeeplink(deeplink.path);
        superManager
          .then((manager) {
            AccountDetails account =
                manager.accountDetailsHiveManager.getAccount('account');
            account.fitbitToken = mappedDeeplink['access_token'];
            account.userId = mappedDeeplink['user_id'];
            account.scopes.add(mappedDeeplink['scope']);
            account.tokenType = mappedDeeplink['token_type'];
            account.expiresIn = mappedDeeplink['expires_in'];
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
                      "Fitbeat",
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
                                      accountBox.get('account');
                                  return Column(
                                    children: <Widget>[
                                      account.displayName != null
                                          ? Text(
                                              'Thanks for logging into google ${account.displayName}!')
                                          : FlatButton(
                                              color: Colors.blueAccent,
                                              child: Text(
                                                "Login",
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
                                          ? Text(
                                              'Thanks for authenticating with Fitbit!')
                                          : FlatButton(
                                              color: Colors.blueAccent,
                                              child: Text('Connect To Fitbit',
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
                            : Text("UH OH!"),
                        FlatButton(
                          color: Colors.blueAccent,
                          child: Text(
                            'Make Request',
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
    title: 'Fitbeat',
    routes: <String, WidgetBuilder>{'/': (context) => HomeScreen()}));

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
