import 'package:bayue_lock/route/route_handler.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


class Routes
{
  static String rootPage = "/";
  static String mainPage = "/main";
  static String loginPage = "/login";
  static String lockPage = "/lock";
  static String permissionApplyDetailPage = "/permissionApplyDetailPage";
  static String lockSingleDetailPage = "/lockSingleDetailPage";
  static String lockAddPage = "/lockAddPage";

  static void configureRoutes(Router router)
  {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return null;
    });

    router.define(rootPage, handler: rootHandler);
    router.define(mainPage, handler: mainHandler);
    router.define(loginPage, handler: loginHandler);
    router.define(lockPage, handler: LockHandler);
    router.define(permissionApplyDetailPage, handler: permissionApplyDetailHandler);
    router.define(lockSingleDetailPage, handler: lockSingleDetailHandler);
    router.define(lockAddPage, handler: lockAddHandler);

  }

}