import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'dart:convert';
import 'dart:async';

//shared_preferences 数据存储
class LocalStorage
{
  static LocalStorage _singleton;
  static SharedPreferences _prefs;
  static Lock _lock = new Lock();

  static Future<LocalStorage> getInstance() async
  {
    if(_singleton == null )
    {
      await _lock.synchronized(()async{
        if(_singleton == null )
        {
          //保持本地实例到完全初始化
          var singleton = LocalStorage._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  LocalStorage._();

  Future _init() async
  {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) {
    if (_prefs == null) return null;
    return _prefs.setString(key, value == null ? "" : json.encode(value));
  }

  /// put string.
  static Future<bool> putString(String key, String value) {
    if (_prefs == null) return null;
    return _prefs.setString(key, value);
  }

  /// remove.
  static Future<bool> remove(String key) {
    if (_prefs == null) return null;
    return _prefs.remove(key);
  }


  static Map getObject(String key)
  {
    if(_prefs == null) return null;
    String _data = _prefs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  static String getString(String key, {String defValue = ''})
  {
     if(_prefs == null) return defValue;
     return _prefs.getString(key) ??  defValue;
  }


  static String getUserInfo(String key, {String defValue = ''})
  {
    if(_prefs = null ) return defValue;

    return _prefs.getString(key) ?? defValue;

  }



}