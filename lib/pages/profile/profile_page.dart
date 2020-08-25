import 'package:bayue_lock/utils/request_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './full_width_button.dart';
import './profile_header_info.dart';
import 'package:bayue_lock/common/constant.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:oktoast/oktoast.dart';
import 'package:bayue_lock/common/constant.dart' show APPIcons;



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const SEPARATE_SIZE = 20.0;
  logout() {
    NetworkUtils.logout().then((res) {
      if (res.status == 2000) {
        RequestUser.removeUserinfo(context);
      } else {
        showToast(res.message, duration: Duration(milliseconds: 1500));
      }
    });
  }

  Widget _buildLogoutBtn() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 12),
        color: AppColors.PrimaryColor,
        textColor: Colors.white,
        disabledColor: AppColors.DisableTextColor,
        onPressed: () {
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('提示'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('确定要退出登录吗?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      logout();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Text(
          '退出登录',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      ProfileHeaderInfoView(onPressed: () {
        //跳转到个人信息页面
      }),
      SizedBox(height: SEPARATE_SIZE),
      FullWidthButton(
        iconData: APPIcons.ProfileListImgData,
        title: '个人资料',
        showDivider: true,
        onPressed: () {
          //BaYueRouter.push(context, Routes.myProductListPage, {});
        },
      ),
      SizedBox(height: 40),
      _buildLogoutBtn()
    ]);
  }
}
