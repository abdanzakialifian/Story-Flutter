import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggerInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if (kDebugMode) {
      print("----- Request -----");
      log(data.toString());
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (kDebugMode) {
      print("----- Response -----");
      log(data.body.toString());
    }
    return data;
  }
}
