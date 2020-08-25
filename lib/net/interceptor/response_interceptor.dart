import 'package:dio/dio.dart';
import 'package:bayue_lock/models/base_result.dart';
import 'package:bayue_lock/common/constant.dart' show AppConfig;

class ResponseInterceptor extends InterceptorsWrapper
{
  @override
  onResponse(Response response) {
    //RequestOptions options = response.request;
    try {
      if (response.statusCode == 200 || response.statusCode == 201) { //http code
        BaseResult result = BaseResult.resultTransform(response.data);
        return null;
      }else {
        if (AppConfig.DEBUG) {
          print("ResponseInterceptor: $response.statusCode");
        }
      }
    } catch(e) {
      if (AppConfig.DEBUG) {
        print("ResponseInterceptor: $e.toString() + options.path");
      }

      return null;
    }
  }


}