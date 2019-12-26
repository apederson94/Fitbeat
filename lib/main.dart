import 'dart:async';

import 'package:fitbeat/data/db/managers/account_manager.dart';
import 'package:fitbeat/data/network/network_manager.dart';
import 'package:fitbeat/utils/fitbeat_deeplink.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

import 'data/db/models/account_details.dart';
import 'utils/utils.dart';

class _HomeScreenState extends State<HomeScreen> {
  Future<NetworkManager> networkManager;
  Future<AccountManager> accountManager;
  StreamSubscription _deeplinkSub;

  @override
  void initState() {
    super.initState();
    networkManager = NetworkManager.getInstance();
    accountManager = AccountManager().initialize();
    networkManager.then((manager) {
      manager.login();
    });
    initUniLinks();
  }

  void handleDeeplink(String deeplink) async {
    try {
      String initialLink = await getInitialLink();
      FitbeatDeeplink deeplink = FitbeatDeeplink(initialLink);
      if (deeplink.target == 'auth') {
        Map<String, dynamic> mappedDeeplink =
            utils.parseAuthDeeplink(deeplink.path);
        accountManager.then((manager) {
          AccountDetails account = manager.getAccount('account');
          account.fitbitToken = mappedDeeplink['access_token'];
          account.userId = mappedDeeplink['user_id'];
          account.scopes.add(mappedDeeplink['scope']);
          account.tokenType = mappedDeeplink['token_type'];
          account.expiresIn = mappedDeeplink['expires_in'];
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
            future: accountManager,
            builder: (context, AsyncSnapshot<AccountManager> snapshot) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Fitbeat",
                      textDirection: TextDirection.ltr,
                    ),
                    actions: <Widget>[
                      snapshot.hasData &&
                              !snapshot.data.getAccount('account').isEmpty() &&
                              snapshot.data.getAccount('account').fitbitToken !=
                                  null
                          ? IconButton(
                              icon: const Icon(Icons.autorenew),
                              tooltip: "Refresh Data",
                              onPressed: () {
                                //TODO
                              })
                          : snapshot.hasData &&
                                  snapshot.data
                                          .getAccount('account')
                                          .fitbitToken ==
                                      null
                              ? FlatButton(
                                  child: Text('Connect To Fitbit',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    NetworkManager.getInstance()
                                        .then((manager) {
                                      manager.authorizeFitbit();
                                    });
                                  },
                                )
                              : FlatButton(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    NetworkManager.getInstance()
                                        .then((manager) async {
                                      setState(() {
                                        accountManager =
                                            AccountManager().initialize();
                                      });
                                    });
                                  }),
                    ],
                  ),
                  body: Column(children: [
                    Center(
                        child: snapshot.hasData &&
                                !snapshot.data.getAccount('account').isEmpty()
                            ? Text(
                                "Authenticated with Google!",
                              )
                            : Text("Please Login")),
                    Center(
                      child: snapshot.hasData &&
                              !snapshot.data.getAccount('account').isEmpty() &&
                              snapshot.data.getAccount('account').fitbitToken !=
                                  null
                          ? Text('Authenticated With Fitbit!')
                          : Text('Please authenticate with Fitbit.'),
                    )
                  ]));
            }));
  }
}

void main() =>
    runApp(MaterialApp(title: 'Fitbeat', routes: <String, WidgetBuilder>{
      '/': (context) => HomeScreen(),
      '/jdF1': (context) => Text('VERIFIED FITBIT'),
      '/auth': (context) => Text('VERIFIED FITBIT')
    }));

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
