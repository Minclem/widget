import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets/carousel.dart';

class CarouselPage extends StatefulWidget {
  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  int currentInndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAROUSEL DEMO'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Carousel(
              viewportFraction: 1,
              space: 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    // borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              itemCount: 10,
              onPageChanged: (index) {
                setState(() {
                  currentInndex = index;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
