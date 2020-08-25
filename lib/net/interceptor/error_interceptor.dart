

import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';


class ErrorInterceptor extends InterceptorsWrapper
{
  final Dio _dio;
  ErrorInterceptor(this._dio);

  @override
  onRequest(RequestOptions options) async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
  }
}