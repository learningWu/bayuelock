import 'dart:io';

import 'package:bayue_lock/common/constant.dart';
import 'package:bayue_lock/route/ba_yue_router.dart';
import 'package:bayue_lock/route/routes.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:bayue_lock/models/lock_info.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';



class LockPage extends StatefulWidget
{
  LockPage({Key key}) : super(key: key);
  @override
  _LockPageState createState() => new _LockPageState();
}

class _LockPageState extends State<LockPage>
{

  String notification = "请靠近智能锁...";
  static const MethodChannel methodChannel = MethodChannel('samples.flutter.io/nfcaction');

  static const EventChannel eventChannel =
  EventChannel('samples.flutter.io/nfcUID');
  static const EventChannel nfcDeviceChannel =
  EventChannel('samples.flutter.io/nfcdevice');

  String _batteryLevel = 'Battery level: unknown.';
  String _chargingStatus = 'Battery status: unknown.';
  int _nfcDeviceStatus;
  String _nfcTagUid = null;
  String _nfcTagPassword = 'Nfc 未获取密码.';
  String password = null;

  @override
  void initState()
  {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    nfcDeviceChannel
        .receiveBroadcastStream()
        .listen(_onDeviceEvent, onError: _onDeviceError);
  }

  //有个回调的时候传入
  void _onEvent(Object event) {
    setState(() {
      _nfcTagUid = event;
      _buildLockItem(_nfcTagUid);  //发现Id则触发请求
    });
  }

  void _onError(Object error) {
    setState(() {
      notification = '未找到NFC标签,请重试.';
    });
  }

  void _onDeviceEvent(Object event) {
    setState(() {
      _nfcDeviceStatus = event;
      switch(_nfcDeviceStatus)
      {
        case 0 :
          notification = "手机不支持NFC功能";
          break;
        case 1:
          notification = "NFC已开启,请靠近智能锁";
          break;
        case 2:
          notification = "请开启NFC功能";
          break;
        case 3:
          if(password != null && _nfcDeviceStatus == 3)
          {
            notification = "密码设置成功";
            _jumpLockAdd(password);
          }
          break;
        case 4:
          notification = "请靠近智能锁";
          break;
        case 5:
          notification = "密码初始化失败，请重试";
          break;
      }
    });
  }

  void _onDeviceError(Object error) {
    setState(() {
      _nfcDeviceStatus = -1;
    });
  }

  //设置密码
  Future<void> _writeNfcTagPassword(int password) async
  {
    setState((){
      //_jumpLockAdd(password.toString());
      notification = "密码设置中...";
    });
    await methodChannel.invokeMethod('writeNfcTagPassword', {'password' : password});
  }



  //跳转到锁信息详情页
  _jumpLockInfo()
  {
    if(_nfcTagUid != null) {
      BaYueRouter.push(
          context, Routes.lockSingleDetailPage, {'lockId': _nfcTagUid});
    }
  }

  //跳转到锁添加页
  _jumpLockAdd(String password)
  {
    if(_nfcTagUid != null){
      BaYueRouter.push(context, Routes.lockAddPage, {'lockId':_nfcTagUid, 'password':password});
    }

  }


   Widget _buildLockIcon()
   {
     return new Padding(
       padding: const EdgeInsets.only(
         left: 40.0, right: 40.0, top: 70.0, bottom: 10.0
       ),
       child: new Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children:<Widget>[
         new Image.asset(
           './assets/imgs/app_icon.png',
           width: 200.0,
           height: 200.0,
         )]
       )
     );
   }

   //判断当前锁是否存在,存在则显示数据。不存在,则初始化锁
   _buildLockItem(String lockId)
   {
      NetworkUtils.lockPwd(lockId).then((res)
        {
          if(ResponseStatus.GET_SUCCESS == res.status)
          {
            password = res.data['password'].toString();
            //这里要设置密码并等待回调
            _writeNfcTagPassword(int.parse(password));
            //跳转添加页面
            //_jumpLockAdd(password);
           // BaYueRouter.push(context, Routes.lockAddPage, {'lockId':lockId, 'password':password});
          }else{
            _jumpLockInfo();
            //这里不跳转了，直接处理业务逻辑给锁初始化密码或者跳转到锁的详情页
//            LockInfo lockInfo = LockInfo.fromJson(res.data);
//            BaYueRouter.push(
//                context, Routes.lockSingleDetailPage, {'lockId': lockInfo.lockCard});
          }
//           if(res.status == 2000) //获取密码成功
//           {
//              Map<String, String> params = new Map();
//              params['lockId'] = lockId;
//              params['password'] = res.data['password'];
//              //传入到信息录入页面
//           }else{
//             LockInfo lockInfo = LockInfo.fromJson(res.data);
//             if(lockInfo.key != null)
//             {
//               BaYueRouter.push(
//                   context, Routes.permissionApplyDetailPage, {'lockInfo': lockInfo});
//             }
//             showToast(res.message, duration: Duration(milliseconds: 1500));
//           }
        });
   }


   Widget _buildNotficationMsg()
   {
     return new Text(
         notification,
         textAlign: TextAlign.center,
         style: new TextStyle(
           decorationColor: const Color(0xffffffff), //线的颜色
           decoration: TextDecoration.none, //none无文字装饰   lineThrough删除线   overline文字上面显示线    underline文字下面显示线
           decorationStyle: TextDecorationStyle.solid, //文字装饰的风格  dashed,dotted虚线(简短间隔大小区分)  double三条线  solid两条线
           wordSpacing: 0.0, //单词间隙(负值可以让单词更紧凑)
           letterSpacing: 0.0, //字母间隙(负值可以让字母更紧凑)
           fontStyle: FontStyle.italic, //文字样式，斜体和正常
           fontSize: 20.0, //字体大小
           fontWeight: FontWeight.w900, //字体粗细  粗体和正常
         )
     );
   }

   //锁逻辑
   //1.进入页面判断是否开启NFC,未开启则提示系统开启NFC权限
   //2.检查是否靠近NFC标签
   //3.靠近NFC，回调后台获取密码
    //3.1 如果当前锁已初始化，则展示锁信息
   //4.往Block 4写入密码
   //5.写入成功,弹到信息录入界面
   //6.锁初始化人员填入基本信息

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildLockIcon(),
        SizedBox(height: 5),
        _buildNotficationMsg()
      ],
    );
  }
}