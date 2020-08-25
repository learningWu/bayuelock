
import 'package:dio/dio.dart';
import 'package:bayue_lock/common/constant.dart' show AppConfig;

class LogsInterceptor extends InterceptorsWrapper
{
  @override
  onRequest(RequestOptions options) {
    if (AppConfig.DEBUG) {
      print("请求url：${options.path}");
      print('请求头: ' + options.headers.toString());
      if (options.data != null) {
        print('请求参数: ' + options.data.toString());
      }
    }
    return null;
  }

  @override
  onResponse(Response response) {
    if (AppConfig.DEBUG) {
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
    return null; // continue
  }

  @override
  onError(DioError err) {
    if (AppConfig.DEBUG) {
      print('请求异常: ' + err.toString());
      print('请求异常信息: ' + err.response?.toString() ?? "");
    }
    return null;
  }
}