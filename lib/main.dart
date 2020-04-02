import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widgets/app.dart';

void main() async {
  runZoned(() => runApp(App()), onError: (Object error) {
    print(error);
  });
}
