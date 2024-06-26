
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frechat/models/req/error_log_req.dart';
import 'package:frechat/models/res/base_res.dart';
import 'package:frechat/models/res/member_login_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/comm/comm.dart';
import 'package:frechat/system/comm/comm_endpoints.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/repository/http_manager.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/form_data_util.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('= printRequestLog [${DateTime.now()}]=');
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('contentType: ${options.contentType}');
    if (options.data is FormData) {
      print('formData fields:');
      for (MapEntry<String, String> field in options.data.fields) {
        print('{ ${field.key}, ${field.value} }');
      }
    } else {
      print('data: ${options.data}');
    }
    print('queryParameters: ${options.queryParameters}');
    print('baseUrl: ${options.baseUrl}');
    print('responseType: ${options.responseType}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('runtimeType: ${response.runtimeType}');
    _sendErrorLog(response);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }

  _sendErrorLog(Response response) {
    final String endPoint = response.requestOptions.path;
    final bool isErrorLogEndPoint = endPoint == CommEndpoint.sendErrorMsgLog;

    if(isErrorLogEndPoint) {
      return ;
    }

    final BaseRes res = BaseRes.fromJson(response.data);

    if(res.resultCode == ResponseCode.CODE_SUCCESS) {
      return ;
    }

    final String userName = GlobalData.memberInfo?.userName ?? '';
    final Map<String, dynamic> headers = ErrorLogReq(
      userName: userName,
      funcCode: res.f,
      resultCode: res.resultCode,
      resultMsg: res.resultMsg,
    ).toBody();
    DioUtil(baseUrl: AppConfig.baseDebugUri, headers: headers).post(CommEndpoint.sendErrorMsgLog);
  }
}
