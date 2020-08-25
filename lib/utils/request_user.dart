import 'package:bayue_lock/models/user_token.dart';
import 'package:bayue_lock/utils/data_handler.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:bayue_lock/utils/user.dart';
import 'package:bayue_lock/models/user_info.dart';
import 'package:bayue_lock/route/ba_yue_router.dart';
import 'package:bayue_lock/route/routes.dart';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';



//被动操作类
class RequestUser
{

  static getUser(BuildContext _context)
  {
    NetworkUtils.getUser().then((res){
      if(res.status == 401)
      {
        refreshToken(_context, force:true);
      }else {
        //保存用户信息
        UserInfo userInfo = UserInfo.fromJson(res.data);
        UserUtils.saveUserInfo(userInfo);
      }
    });
  }

  static refreshToken(BuildContext _context,{bool force = false})
  {
    //判断是否有
    UserToken userToken = UserUtils.getUserToken();
    if(userToken != null)
    {
      if(expires(userToken.expiresIn) || force)
      {
        NetworkUtils.refreshToken(userToken.refreshToken).then((res){
          if(res.status == 2000)
          {
            //保存Token
            DataHandler.saveToken(res.data);
            getUser(_context);
          }else{
            removeUserinfo(_context);
          }
        });
      }
    }else{
      removeUserinfo(_context);
    }

  }

  //判断当前token是否到达过期时间
  //返回 true 则过期
  static bool expires(int expires)
  {
    var curDate = new DateTime.now().millisecondsSinceEpoch;
    return curDate > expires;
  }

  static removeUserinfo(BuildContext _context)
  {
    UserUtils.removeUserInfo(); //清除用户信息
    BaYueRouter.push(_context, Routes.loginPage, {},
        clearStack: true, transition: TransitionType.fadeIn);
  }

}