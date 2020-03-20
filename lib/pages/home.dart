import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets/carousel.dart';

class HomePage extends StatefulWidget {
    @override
    _HomePage createState () => _HomePage();
}

class _HomePage extends State<HomePage> {
    @override
    void initState() {
      super.initState();
    }

    @override
    Widget build (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('HOME PAGE'),
            ),
            body: Column(
                children: <Widget>[
                    Carousel(
                        onPageChanged: (index) {
                            print('onPageChanged $index');
                        },
                        itemCount: 1,
                        color: Colors.amberAccent,
                        itemBuilder: (BuildContext context, int index) {
                            return Container(
                                color: Colors.white,
                                child: Text('$index'),
                            );
                        },
                    ),
                ],
            ),
        );
    }
}