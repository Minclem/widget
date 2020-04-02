import 'package:flutter/material.dart';
import 'package:widgets/pages/music.dart';
import 'package:widgets/routes/container.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentViewIndex = 0;
  List<Widget> listView = [
    IndexPage(),
    MuiscPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void tapViewContainer(int index) {
    setState(() {
      currentViewIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME PAGE'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        // shape: AutomaticNotchedShape(),
        elevation: 0,
        // notchMargin: 6,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () => tapViewContainer(0),
            ),
            SizedBox(), //中间位置空出
            IconButton(
              icon: Icon(
                Icons.queue_music,
                color: Colors.white,
              ),
              onPressed: () => tapViewContainer(1),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {},
        shape: new BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)),
      ),
      body: listView[currentViewIndex],
    );
  }
}

class RouteButtonItem {
  String value;
  String route;

  RouteButtonItem({
    this.value,
    this.route,
  });
}

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RouteButtonItem> routes = [
      RouteButtonItem(value: 'open notify', route: ROUTE_NOTIFICATION),
      RouteButtonItem(value: 'open test', route: ROUTE_TEXT_PAGE),
      RouteButtonItem(value: 'open webview', route: ROUTE_WEBVIEW_PAGE),
      RouteButtonItem(value: 'open carousel', route: ROUTE_CAROUSEL_PAGE),
      RouteButtonItem(value: 'open list', route: ROUTE_LIST_PAGE),
    ];

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
            for (var i = 0; i < routes.length; i++)
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Text(routes[i].value),
                onPressed: () {
                  Navigator.pushNamed(context, routes[i].route);
                },
              )
          ],
        ),
      ),
    );
  }
}
