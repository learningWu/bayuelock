import 'package:flutter/material.dart';

class AppColors
{
  static const PrimaryColor = Color(0xFFFF9000);
  static const DividerColor = Color(0xffd9d9d9);
  static const ArrowNormalColor = Color(0xff999999);
  static const BackgroundColor = Color(0xffebebeb);
  static const DarkTextColor = Color(0xFF333333);
  static const MidTextColor = Color(0xFF666666);
  static const LightTextColor = Color(0xFF999999);
  static const DisableTextColor = Color(0xFFDCDCDC);
}

class AppConfig
{
  static const DEBUG = true;
 // static const SERVER = "http://192.168.3.3";
  static const SERVER = "http://api.lock.i9x.cn";
}

class ResponseStatus
{
  static const SUCCESS = 2000;          //操作成功
  static const GET_SUCCESS =2001;       //数据获取成功
  static const ERROR = 4000;            //业务逻辑错误
}

class AppSize {
  static const DividerWidth = 0.5;
}

class Constant {
  static const IconFontFamily = "appIconFont";
}


class APPIcons {
  static const PlaceHolderAvatar = Icon(
    IconData(
      0xe642,
      fontFamily: Constant.IconFontFamily,
    ),
    size: 60.0,
    color: AppColors.ArrowNormalColor,
  );


  static const AddImgData = IconData(
    0xe70a,
    fontFamily: Constant.IconFontFamily,
  );

  static const ProfileListImgData = IconData(
    0xe64d,
    fontFamily: Constant.IconFontFamily,
  );

  static const ProfileAddImgData = IconData(
    0xe60c,
    fontFamily: Constant.IconFontFamily,
  );

  static const ProfileSettingImgData = IconData(
    0xe615,
    fontFamily: Constant.IconFontFamily,
  );

  static const EmptyData = IconData(
    0xe643,
    fontFamily: Constant.IconFontFamily,
  );

  static const NetworkErrorData = IconData(
    0xe86e,
    fontFamily: Constant.IconFontFamily,
  );
}