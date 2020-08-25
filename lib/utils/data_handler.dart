

import 'package:bayue_lock/models/user_token.dart';
import 'package:bayue_lock/utils/user.dart';

class DataHandler
{
  static saveToken(Map<String,dynamic> res)
  {
    DateTime dt = DateTime.now();
    int exp = res['expiresIn'] as int;
    res['expiresIn'] = dt.add(new Duration(seconds: exp)).millisecondsSinceEpoch;
    //保存Token
    UserToken userToken = UserToken.fromJson(res);
    UserUtils.saveUserToken(userToken);
  }

}