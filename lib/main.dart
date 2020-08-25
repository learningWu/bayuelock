
import 'package:bayue_lock/common/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluro/fluro.dart';
import 'package:oktoast/oktoast.dart';

import 'utils/local_storage.dart';
import 'route/routes.dart';
import 'route/ba_yue_router.dart';
import 'common/constant.dart' show AppColors;

void main() async {
  await LocalStorage.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final route = new Router();
    Routes.configureRoutes(route);
    BaYueRouter.initWithRouter(route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "八越智能锁",
        debugShowCheckedModeBanner: AppConfig.DEBUG,
        theme: ThemeData(
            primaryColor: AppColors.PrimaryColor,
            backgroundColor: Colors.white),
        onGenerateRoute: BaYueRouter.router().generator,
        initialRoute: Routes.mainPage);
  }
}
