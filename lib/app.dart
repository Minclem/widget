import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgets/routes/container.dart';
import 'package:widgets/routes/router.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    print('app initState =>>>>>>>');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: router,
      initialRoute: ROUTE_HOME_PAGE,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black,
        ),
        bottomAppBarColor: Colors.black,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
