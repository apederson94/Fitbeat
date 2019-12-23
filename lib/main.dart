import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitbeat/utils/networkManager.dart';
import 'package:googleapis/chat/v1.dart';

class _MyAppState extends State<MyApp> {
  Future<NetworkManager> manager;
  Future<GoogleSignInAccount> account;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    manager = NetworkManager.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("FitBeat", textDirection: TextDirection.ltr,),
            actions: <Widget>[
              !isLoggedIn ? FlatButton(
                color: Colors.white,
                child: Text("Login"),
                onPressed: () {
                  this.manager.then((manager) {
                    manager.login().then((account) {
                      if (account != null) {
                        setState(() {
                          this.manager.then((manager) {
                            manager.account = account;
                            manager.isLoggedIn = true;
                            isLoggedIn = true;
                          });
                        });
                      }
                    });
                  });
                },
              ) :
              IconButton(
                icon: const Icon(Icons.autorenew),
                tooltip: "Refresh Data",
                onPressed: () {
                  //TODO
                },
              ),
            ],
          ),
          body: Center(
              child: FutureBuilder<NetworkManager>(
                future: manager,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final networkManager = snapshot.data;
                    if (networkManager.isLoggedIn) {
                      return Text(
                          "Signed into Google as: ${networkManager.account.displayName}",
                      );
                    } else {
                      return Text("Please login.");
                    }
                  } else if (snapshot.hasError) {
                    return Text("Error occurred. Please try logging in again.");
                  } else {
                    return Text("Please Login.");
                  }
                },
              )
          ),

        )
    );
  }
}

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

