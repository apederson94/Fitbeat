import 'dart:async';

import 'package:fitbeat/data/assets/fitbeatConstants.dart';
import 'package:fitbeat/data/db/models/account_details.dart';
import 'package:fitbeat/data/network/manager/auth_api_manager.dart';
import 'package:fitbeat/data/network/manager/google_fit_api_manager.dart';
import 'package:fitbeat/data/super_manager.dart';
import 'package:fitbeat/utils/fitbeat_deeplink.dart';
import 'package:fitbeat/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'fitbeatButton.dart';

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
      if (deeplink.target == FitbeatConstants.auth) {
        Map<String, dynamic> mappedDeeplink =
            Utils.parseAuthDeeplink(deeplink.path);
        superManager.then((manager) {
          AccountDetails account = manager.accountDetailsHiveManager
              .getAccount(FitbeatConstants.account);
          account.fitbitToken = mappedDeeplink[FitbeatConstants.accessTokenSC];
          account.userId = mappedDeeplink[FitbeatConstants.userIdSC];
          account.scopes.add(mappedDeeplink[FitbeatConstants.scope]);
          account.tokenType = mappedDeeplink[FitbeatConstants.tokenTypeSC];
          account.expiresIn = mappedDeeplink[FitbeatConstants.expiresInSC];
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
      Utils.logAmp(err.toString());
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
                      FitbeatConstants.fitbeatTitle,
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
                                      accountBox.get(FitbeatConstants.account);
                                  return Column(
                                    children: account != null
                                        ? <Widget>[
                                            account.displayName != null
                                                ? Text(FitbeatConstants
                                                        .thanksForLoggingIn +
                                                    account.displayName)
                                                : FitbeatButton.create(
                                                    text: FitbeatConstants
                                                        .pleaseLogin,
                                                    onPressed: () async {
                                                      snapshot.data
                                                          .accountDetailsHiveManager
                                                          .saveNewAccount(
                                                              await snapshot
                                                                  .data
                                                                  .authManager
                                                                  .login());
                                                    }),
                                            account.fitbitToken != null
                                                ? Text(FitbeatConstants
                                                    .fitbitAuthenticated)
                                                : FitbeatButton.create(
                                                    text: FitbeatConstants
                                                        .connectToFitbit,
                                                    onPressed: () {
                                                      AuthApiManager
                                                              .getInstance()
                                                          .then((manager) {
                                                        manager
                                                            .authorizeFitbit();
                                                      });
                                                    })
                                          ]
                                        : <Widget>[
                                            FitbeatButton.create(
                                                text: FitbeatConstants
                                                    .pleaseLogin,
                                                onPressed: () async {
                                                  snapshot.data
                                                      .accountDetailsHiveManager
                                                      .saveNewAccount(
                                                          await snapshot
                                                              .data.authManager
                                                              .login());
                                                })
                                          ],
                                  );
                                },
                              )
                            : Text(FitbeatConstants.uhOh),
                        FitbeatButton.create(
                          text: FitbeatConstants.makeRequest,
                          onPressed: () async {
                            await GoogleFitApiManager().getSteps();
                          },
                        ),
                        FitbeatButton.create(
                            text: FitbeatConstants.viewSteps,
                            onPressed: () {
                              Navigator.pushNamed(context, '/steps');
                            })
                      ])));
            }));
  }
}

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
