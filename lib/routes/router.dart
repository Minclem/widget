import 'package:widgets/pages/hero.dart';
import 'package:widgets/pages/home.dart';
import 'package:widgets/pages/notical.dart';

import 'container.dart';

final router = {
  ROUTE_HOME_PAGE: (context) => HomePage(),
  ROUTE_HERO_PAGE: (context) => HeroAnimationRoute(),
  ROUTE_NOTIFICATION: (context) => MessageNotificationPage(),
};
