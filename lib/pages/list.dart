import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widgets/widgets/operationItem.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool offstage = false;
  Size win = MediaQueryData.fromWindow(window).size;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      setState(() {
        offstage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              // backgroundColor: Colors.blue,
              // color: Colors.white,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return OperationItem(
                        height: 80,
                        children: <Widget>[
                          Container(
                            width: win.width,
                            color: Colors.black26,
                          ),
                          Container(
                            width: 80.0,
                            color: Colors.red,
                            child: Text('DEL ITEM'),
                          ),
                          Container(
                            width: 80.0,
                            color: Colors.yellow,
                            child: Text('EDIT'),
                          ),
                        ],
                      );
                    },
                  )),
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1)).then((_) {
                  print('下拉刷新结束!!');
                });
              },
            ),
            Offstage(
              offstage: offstage,
              child: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
