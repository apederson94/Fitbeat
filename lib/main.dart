import 'package:fitbeat/data/db/managers/account_manager.dart';
import 'package:fitbeat/data/network/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/firebasedynamiclinks/v1.dart';

class _MyAppState extends State<MyApp> {
  Future<NetworkManager> networkManager;
  Future<AccountManager> accountManager;

  @override
  void initState() {
    super.initState();
    networkManager = NetworkManager.getInstance();
    accountManager = AccountManager().initialize();
    networkManager.then((manager) {
      manager.login();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder(
            future: accountManager,
            builder: (context, AsyncSnapshot<AccountManager> snapshot) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Fitbeat',
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
                                    NetworkManager.getInstance().then((manager) {
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
                  body: Center(
                      child: snapshot.hasData &&
                              !snapshot.data.getAccount('account').isEmpty()
                          ? Text(
                              "Signed into Google as: ${AccountManager().getAccount("account").displayName}",
                            )
                          : Text("Please Login")));
            }),
    routes: <String, WidgetBuilder> {
          '/auth': (context) => Text('VERIFIED FITBIT')
    });
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}
