import 'dart:convert';

import 'package:bayue_lock/models/lock_info.dart';
import 'package:bayue_lock/pages/home/permission_apply_detail_view.dart';
import 'package:bayue_lock/pages/lock/lock_add_page.dart';
import 'package:bayue_lock/pages/lock/lock_detail_page.dart';
import 'package:bayue_lock/pages/lock/lock_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:bayue_lock/utils/user.dart';
import 'package:bayue_lock/pages/application_page.dart';
import 'package:bayue_lock/pages/Login/login_page.dart';


var rootHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params)
{
  return UserUtils.isLogin() ? ApplicationPage() : LoginPage();
});

var mainHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ApplicationPage();
});

var loginHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var LockHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params){
  return LockPage();
});

var permissionApplyDetailHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params){
  String applyId = params['applyId']?.first;
   return PermissionApplyDetail(applyId:int.parse(applyId));
});


var lockSingleDetailHandler = Handler(handlerFunc: (BuildContext context,Map<String, List<String>> params){
  String lockId = params['lockId']?.first;
  return LockDetailPage(lockId: lockId);
});

var lockAddHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params){
  String lockId = params['lockId']?.first;
  String password = params['password']?.first;
  return LockAddPage(lockId:lockId, password: password);
});
