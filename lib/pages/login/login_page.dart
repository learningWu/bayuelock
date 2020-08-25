import 'package:bayue_lock/models/user_token.dart';
import 'package:bayue_lock/utils/data_handler.dart';
import 'package:bayue_lock/utils/request_user.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import 'package:bayue_lock/route/ba_yue_router.dart';
import 'package:bayue_lock/utils/user.dart';
import 'package:bayue_lock/common/constant.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:bayue_lock/route/routes.dart';


class LoginPage extends StatefulWidget
{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
    GlobalKey<ScaffoldState> registKey = new GlobalKey();

    String _account = UserUtils.getUserAccount().isEmpty ?
    "" :
    UserUtils.getUserAccount();

    String _password = '';

    login() {
      NetworkUtils.login(this._account, this._password).then((res) {
        if (res.status == ResponseStatus.SUCCESS) {
          //保存Token
          DataHandler.saveToken(res.data);

          //保存用户名
          UserUtils.saveUserName(this._account);

          RequestUser.getUser(context);  //获取用户信息

          // 保存成功，跳转到首页
          BaYueRouter.push(context, Routes.mainPage, {},
              clearStack: true, transition: TransitionType.fadeIn);

        } else {
          showToast(res.message, duration: Duration(milliseconds: 1500));
        }
      });
    }

    Widget _buildTipIcon() {
      return new Padding(
        padding: const EdgeInsets.only(
            left: 40.0, right: 40.0, top: 50.0, bottom: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center, //子组件的排列方式为主轴两端对齐
          children: <Widget>[
            new Image.asset(
              './assets/imgs/app_icon.png',
              width: 88.0,
              height: 88.0,
            ),
          ],
        ),
      );
    }

    Widget _buldAccountEdit() {
      var node = FocusNode();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          controller: TextEditingController(text: _account),
          onChanged: (value) {
            _account = value;
          },
          decoration: InputDecoration(
            hintText: '请输入员工编号',
            labelText: '账号',
            hintStyle:
            TextStyle(fontSize: 12.0, color: AppColors.ArrowNormalColor),
          ),
          maxLines: 1,
          maxLength: 30,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(node);
          },
        ),
      );
    }

    Widget _bulidPasswordEdit() {
      var node = new FocusNode();
      Widget passwordEdit = new TextField(
        onChanged: (str) {
          _password = str;
          setState(() {});
        },
        decoration: new InputDecoration(
            hintText: '请输入至少6位密码',
            labelText: '密码',
            hintStyle: new TextStyle(fontSize: 12.0, color: Colors.grey)),
        maxLines: 1,
        maxLength: 6,
        //键盘展示为数字
        //keyboardType: TextInputType.number,
        obscureText: true,
        //只能输入数字
        /*inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],*/
        onSubmitted: (text) {
          FocusScope.of(context).requestFocus(node);
        },
      );

      return new Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
        child: new Stack(
          children: <Widget>[
            passwordEdit,
          ],
        ),
      );
    }

    @override
    Widget build(BuildContext context)
    {
      return new Material(
        child: new Scaffold(
          key: registKey,
          backgroundColor: Colors.white,
          appBar: new AppBar(
            title: new Text('八越智能锁管理系统', style: TextStyle(color: Colors.white)),
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildTipIcon(),
                  _buldAccountEdit(),
                  _bulidPasswordEdit(),
                  _buildLoginBtn(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildLoginBtn() {
      return new Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: new RaisedButton(
          padding: new EdgeInsets.fromLTRB(130.0, 15.0, 130.0, 15.0),
          color: AppColors.PrimaryColor,
          textColor: Colors.white,
          disabledColor: AppColors.DisableTextColor,
          onPressed: (_account.isEmpty || _password.isEmpty)
              ? null
              : () {
            login();
          },
          child: new Text(
            '登 录',
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      );
    }


}