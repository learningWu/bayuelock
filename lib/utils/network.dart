
import 'package:bayue_lock/common/constant.dart';
import 'package:bayue_lock/models/base_result.dart';
import 'package:bayue_lock/net/http_manager.dart';

class NetworkUtils
{

  //登陆账户
  static login(String account, String password) async 
  {
    String url = getUrl("/login");
    var params = {"account": account, "password": password};
    BaseResult result = await httpManager.request(HttpMethod.POST, url, params);
    return result;
  }

  //获取用户信息
  static getUser() async
  {
    String url = getUrl('/user');
    BaseResult result = await httpManager.request(HttpMethod.GET, url, {});
    return result;
  }

  //更换Token
  static refreshToken(String refToken) async
  {
    String url = getUrl('/token/refresh');
    var params = {"refreshToken": refToken};
    BaseResult result = await httpManager.request(HttpMethod.GET, url, params);
    return result;
  }

  //锁初始化密码
  static lockPwd(String lockId) async
  {

    String url = getUrl("/lock/password/"+lockId);
    BaseResult result = await httpManager.request(HttpMethod.GET, url, null);
    return result;

  } 
  
  //获取主页,锁申请列表
  static requestHomeLockApply(int page) async
  {
    String url = getUrl("/permissionApply");
    var params = {"page" : page, "limit":4,"type":1};

    BaseResult result = await httpManager.request(HttpMethod.GET, url, params);
    return result;

  }

  //获取单一锁申请权限
  static requestApply(int id) async
  {
    String url = getUrl('/permissionApply/single/'+id.toString());
    BaseResult result = await httpManager.request(HttpMethod.GET, url, null);
    return result;

  }
  
  //获取角色信息
  static requestRoles() async
  {
    String url = getUrl('/role');
    BaseResult result = await httpManager.request(HttpMethod.GET, url, null);
    return result;
  }

  static requestAddLock(String lockId,String password, String location, String remark, List roles) async
  {

    String url = getUrl('/lock');
    var params = {"lock_card":lockId, "password": password, "location":location
      ,"remark":remark,"roles":roles.toString()};

    BaseResult result = await httpManager.request(HttpMethod.POST, url, params);
    return result;
  }

  //保存权限申请表单
  static requestSave( int id,String remark,int status) async
  {
    String url = getUrl('/permissionApply/consent');
    var params = {"id":id,"remark":remark,"status":status};
    BaseResult result = await httpManager.request(HttpMethod.POST, url, params);
    return result;
  }

  //退出登陆
  static logout() async
  {
    String url = getUrl("/logout");
    BaseResult result = await httpManager.request(HttpMethod.GET, url, null);
    return result;
  }

  static getUrl(String url)
  {
    return AppConfig.SERVER+url;
  }
}