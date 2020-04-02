import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Demo'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Text('123'),
        ),
      ),
    );
  }
}