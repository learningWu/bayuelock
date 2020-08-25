import 'dart:io';

import 'package:dio/dio.dart';
import 'interceptor/error_interceptor.dart';
import 'interceptor/response_interceptor.dart';
import 'interceptor/logs_interceptor.dart';
import 'package:bayue_lock/utils/user.dart';
import 'code.dart';
import 'package:bayue_lock/models/base_result.dart';



enum HttpMethod{GET, POST}

const HTTPMethodValues = ['GET', 'POST'];

const ContentTypeURLEncoded = 'application/x-www-form-urlencoded';


class HttpManager
{
  Dio _dio = Dio();

  HttpManager()
  {
    _dio.interceptors.add(LogsInterceptor());
    _dio.interceptors.add(ErrorInterceptor(_dio));
    _dio.interceptors.add(ResponseInterceptor());
  }

  request(HttpMethod method, String url, Map<String, dynamic> params,
      {ContentType contentType}) async {
    Options _options;
    Map<String, dynamic> header;

    var type = contentType == null
        ? ContentType.parse(ContentTypeURLEncoded)
        : contentType;

    if (UserUtils.isLogin()) {
      header = {'Authorization': UserUtils.authorizationToken()};
    }

    if (method == HttpMethod.GET) {
      _options = Options(
          method: HTTPMethodValues[method.index],
          contentType: "type",
          headers: header);
    } else {
      _options = Options(
          method: HTTPMethodValues[method.index],
          contentType: "type",
          headers: header);
    }

    Response response;
    try {
      if (method == HttpMethod.GET) {
        response =
        await _dio.get(url, queryParameters: params, options: _options);

      } else {
        response = await _dio.post(url, data: params, options: _options);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
      } else {
        response = Response(statusCode: 999, statusMessage: "请求失败,稍后再试！");
      }

      Map<String,dynamic> errors = new Map<String,dynamic>();

      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        response.statusCode = Code.REQUEST_TIMEOUT;
        response.statusMessage = "请求超时,请稍后再试!";
      }else if(response.statusCode == 422){ //表单提交错误
        errors = response.data['errors'] as Map<String,dynamic> ;
      }
      response.data =
          BaseResult(null, response.statusCode, response.statusMessage, errors);

    }
    return response.data;
  }
}

final HttpManager httpManager = HttpManager();
