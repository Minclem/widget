import 'package:widgets/pages/carousel.dart';
import 'package:widgets/pages/hero.dart';
import 'package:widgets/pages/home.dart';
import 'package:widgets/pages/list.dart';
import 'package:widgets/pages/notical.dart';
import 'package:widgets/pages/test.dart';
import 'package:widgets/pages/webview.dart';
import 'package:widgets/routes/container.dart';

final router = {
  ROUTE_HOME_PAGE: (context) => HomePage(),
  ROUTE_HERO_PAGE: (context) => HeroAnimationRoute(),
  ROUTE_NOTIFICATION: (context) => MessageNotificationPage(),
  ROUTE_TEXT_PAGE: (context) => TextPage(),
  ROUTE_WEBVIEW_PAGE: (context) => IWebview(),
  ROUTE_CAROUSEL_PAGE: (context) => CarouselPage(),
  ROUTE_LIST_PAGE: (context) => ListPage(),
};
