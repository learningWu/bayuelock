import 'package:bayue_lock/utils/request_user.dart';
import 'package:flutter/material.dart';
import 'package:bayue_lock/common/constant.dart' show APPIcons;
import 'package:bayue_lock/common/constant.dart';
import 'package:bayue_lock/models/user_info.dart';
import 'package:bayue_lock/utils/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileHeaderInfoView extends StatelessWidget {
  const ProfileHeaderInfoView({this.onPressed});

  final VoidCallback onPressed;



  @override
  Widget build(BuildContext context) {
    RequestUser.getUser(context); //获取用户信息

    UserInfo userInfo = UserUtils.getUserInfo();
    Widget avatar;
    if (userInfo.avatar != null && userInfo.avatar != '') {
      avatar = CachedNetworkImage(
        imageUrl: userInfo.avatar,
        placeholder: (context, url) => APPIcons.PlaceHolderAvatar,
        fit: BoxFit.cover,
        height: 60.0,
        width: 60.0,
        errorWidget: (context, url, error) => new Icon(Icons.error),
      );
    } else {
      avatar = APPIcons.PlaceHolderAvatar;
    }

    return Container(
      height: 150,
      color: Colors.white,
      child: FlatButton(
        onPressed: this.onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   ClipOval(
                      child: avatar,
                    ),
                    SizedBox(height: 5,),
                  Text(
                    userInfo.name,
                    style: TextStyle(color: AppColors.DarkTextColor, fontSize: 15),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Text(
                      userInfo.describe ?? '此人很懒，什么都没写~',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 12, color: Color(0xff818181)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
