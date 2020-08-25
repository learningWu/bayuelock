import 'package:bayue_lock/models/user_info.dart';
import 'package:bayue_lock/models/user_token.dart';
import 'package:bayue_lock/utils/local_storage.dart';


class UserUtils
{
  static const USER_INFO_KEY = "USER_INFO_KEY";
  static const USER_ACCOUNT_KEY = "USER_ACCOUNT_KEY";
  static const USER_TOKEN_KEY = "USER_TOKEN_KEY";
  static const USER_REFRESH_KEY = "USER_REFRESH_KEY";

  static UserInfo getUserInfo()
  {
    Map userJson = LocalStorage.getObject(USER_INFO_KEY);
    return userJson == null ? null : UserInfo.fromJson(userJson);
  }


  static bool isLogin()
  {
    var res = getUserToken() == null ? false : true;
    return res;
  }

  static saveUserInfo(UserInfo userInfo) {
    if (userInfo != null) {
      LocalStorage.putObject(USER_INFO_KEY, userInfo.toJson());
    }
  }

  static UserToken getUserToken()
  {
    Map userToken = LocalStorage.getObject(USER_TOKEN_KEY);
    return userToken == null ? null : UserToken.fromJson(userToken);
  }

  static String authorizationToken ()
  {
    String token = "Bearer ";
    token += getUserToken().token == null ? '' : getUserToken().token;
    return token;
  }

  static saveUserToken(UserToken userToken)
  {
    if(userToken != null)
    {
      LocalStorage.putObject(USER_TOKEN_KEY, userToken.toJson());
    }
  }

  static saveUserName(String username)
  {
    if (username != null)
    {
      LocalStorage.putString(USER_ACCOUNT_KEY, username);
    }
  }

  static removeUserInfo()
  {
    LocalStorage.remove(USER_INFO_KEY);
    LocalStorage.remove(USER_TOKEN_KEY);
  }

  static String getUserAccount()
  {
    return LocalStorage.getString(USER_ACCOUNT_KEY);
  }

}