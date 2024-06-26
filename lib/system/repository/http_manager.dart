import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/res/base_res.dart';
import 'package:frechat/system/comm/comm_endpoints.dart';
import 'package:frechat/system/repository/http_interceptor.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:path_provider/path_provider.dart';

import '../call_back_function.dart';
import 'http_exceptions.dart';
import 'http_setting.dart';

///MARK: 參考網站
///https://dhruvnakum.xyz/networking-in-flutter-dio#heading-repository
class DioUtil {
// dio instance
  final Dio _dio = Dio();
  final ResponseErrorFunction? onConnectFail;
  final onGetStringFunction? onConnectSuccess;
  String baseUrl;
  final bool addToken;
  final Map<String, dynamic>? headers;

  DioUtil({
    this.onConnectFail,
    this.onConnectSuccess,
    required this.baseUrl,
    this.addToken = true,
    this.headers,
  }) {
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: HttpSetting.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: HttpSetting.receiveTimeout)
      ..options.responseType = ResponseType.json
      ..options.contentType = Headers.formUrlEncodedContentType
      ..options.headers.addAll(headers ?? {})
      ..interceptors.add(DioInterceptor());
  }

  BaseRes _checkResponse(Response response) {
    debugPrint(response.realUri.toString());
    print('response runtimeType: ${response.data.runtimeType}');
    print('response : ${response.data}');

    if(response.data == '' || response.data == null) {
      return BaseRes(resultCode: 'emptyResultCode');
    }

    final BaseRes result = BaseRes.fromJson(response.data);
    result.printLog();
    /// API请求成功 检查response code， 如果有就return，否则进入Exception
    if (ResponseCode.map.containsKey(result.resultCode)) {
      if(result.resultCode == ResponseCode.CODE_SUCCESS) {
        callSuccessConnect(result.resultCode);
      } else {
        callFailConnect(result.resultCode);
      }
      return result;
    }

    ///取代錯誤code
    response.statusCode = 404;
    response.data['message'] = result.resultCode;
    throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse
    );
  }

  Future<void> _initDio() async {
    if (addToken) {
      // if (GlobalData.userToken.isNotEmpty) {
      //   _dio.options.headers["Authorization"] =
      //       "Bearer ${GlobalData.userToken}";
      // }
    }
  }

  Future<void> addDioHeader(Map<String, String> header) async {
    header.forEach((key, value) {
      _dio.options.headers[key] = value;
      debugPrint("addDioHeader $key:${_dio.options.headers[key]}");
    });
  }

  void callFailConnect(String message) {
    if (onConnectFail != null) {
      onConnectFail!(message);
    }
  }

  void callSuccessConnect(String message) {
    if (onConnectSuccess != null) {
      onConnectSuccess!(message);
    }
  }

  double getDouble(json, String key) {
    return json[key] is int ? (json[key] as int).toDouble() : json[key];
  }

  // Get:-----------------------------------------------------------------------
  Future<BaseRes?> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _initDio();
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _checkResponse(response);
    } on DioException catch (e) {
      final errorMessage = HttpExceptions.fromDioError(e).toString();
      callFailConnect(errorMessage);
      throw errorMessage;
    } catch (e) {
      callFailConnect(e.toString());
      rethrow;
    }
  }

  static Future<XFile?> getUrlAsXFile(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await Dio().get(
        url,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes, headers: options?.headers), // to get the image as bytes
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      // Assuming _checkResponse returns the byte data of the image if everything is okay.
      final urlData = response.data;

      if (urlData == null || !(urlData is List<int>)) {
        throw "Failed to download data.";
      }

      // Save the image to a temporary file
      final directory = await getTemporaryDirectory();
      final filename = url.split('/').last;
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(urlData);

      // Convert to XFile
      return XFile(file.path);
    } on DioException catch (e) {
      final errorMessage = HttpExceptions.fromDioError(e).toString();
      print(errorMessage);
      throw errorMessage;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }


  // Post:----------------------------------------------------------------------
  Future<BaseRes?> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _initDio();
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _checkResponse(response);
    } on DioException catch (e) {
      final errorMessage = HttpExceptions.fromDioError(e).toString();
      callFailConnect(errorMessage);
      throw errorMessage;
    } catch (e) {
      callFailConnect(e.toString());
      rethrow;
    }
  }

// Put:-----------------------------------------------------------------------
  Future<BaseRes?> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _initDio();
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _checkResponse(response);
    } on DioException catch (e) {
      final errorMessage = HttpExceptions.fromDioError(e).toString();
      callFailConnect(errorMessage);
      throw errorMessage;
    } catch (e) {
      callFailConnect(e.toString());
      rethrow;
    }
  }

// Delete:--------------------------------------------------------------------
  Future<BaseRes?> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _initDio();
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return BaseRes.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = HttpExceptions.fromDioError(e).toString();
      callFailConnect(errorMessage);
      throw errorMessage;
    } catch (e) {
      callFailConnect(e.toString());
      rethrow;
    }
  }
}
