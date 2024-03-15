import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../navigation/custom_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/app_bloc/app_bloc.dart';
import '../config/app_env.dart';
import 'api_response_model.dart';
import 'api_url.dart';
import 'request_data.dart';

abstract class INinjazRest {
  /// [NetworkLinks] field that swap between base url when [get] url.
  Future<ApiResponse> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? userToken,
  });
}

class NinjazRest implements INinjazRest {
  final Dio _dio;
  final AppEnvironment _appEnvironment;
  final bool enableLog;

  final Map<String, dynamic> _headers = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json',
  };

  NinjazRest(this._dio, this._appEnvironment, {this.enableLog = false}) {
    switch (_appEnvironment) {
      case AppEnvironment.production:
        _dio.options.baseUrl = ApiURLs.baseUrl;
        _dio.options.headers = _headers;

        break;
      case AppEnvironment.staging:
        _dio.options.baseUrl = ApiURLs.baseUrl;
        _dio.options.headers = _headers;
        break;
      case AppEnvironment.development:
        _dio.options.baseUrl = ApiURLs.baseUrl;
        _dio.options.headers = _headers;
        break;
    }
  }

  @override
  Future<ApiResponse> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? userToken,
  }) async {
    ApiResponse apiResponse = ApiResponse(page: 1);
    try {
      var requestData = _getRequestData(null, headers, queryParameters);
      requestData.headers.addAll({"app-id": "65f1a22ce5c0462f4a0375ad"});

      final Future<Response> getMethod = _dio.get(
        url,
        options: Options(headers: requestData.headers),
        queryParameters: requestData.params,
      );

      apiResponse = await _executeRequest(method: getMethod);
      return apiResponse;
    } on ApiResponse catch (e) {
      return e;
    }
  }

  RequestData _getRequestData(dynamic data, Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters) {
    Map<String, dynamic> requestHeads;

    if (headers == null) {
      requestHeads = _headers;
    } else {
      requestHeads = headers;
    }

    var requestData = RequestData(
      data: data ??= '',
      headers: requestHeads,
      params: queryParameters ??= {'': ''},
    );
    return requestData;
  }

  Future<ApiResponse> _executeRequest({
    required Future<Response> method,
  }) async {
    ApiResponse apiResponse = ApiResponse(page: 1);
    try {
      final response = await method;

      apiResponse = ApiResponse.fromJson(response.data);

      if (enableLog) _networkLog(response);
      return apiResponse;
    } on DioException catch (e) {
      _traceError(e);

      if (e.response!.statusCode == 404) {
        currentContext!
            .read<AppBloc>()
            .add(UpdateAppEvent(appStatus: AppStatus.serverError));

        throw Exception('unknown error');
        // throw Exception('Refresh token fail with 401');
      }

      // apiResponse.data = e.response == null ? [] : e.response!.data;
      apiResponse = await e.response!.data["message"];
      throw apiResponse;
    }
  }

  Future<String> _errorMessageHandler(ApiResponse response) async {
    final message = response.data is Map ? response.error : "error_message";
    return message!;
  }

  void _traceError(DioException e) {
    String trace = '════════════════════════════════════════ \n'
        '╔╣ Dio [ERROR] info ==> \n'
        '╟ BASE_URL: ${e.requestOptions.baseUrl}\n'
        '╟ PATH: ${e.requestOptions.path}\n'
        '╟ Method: ${e.requestOptions.method}\n'
        '╟ Params: ${e.requestOptions.queryParameters}\n'
        '╟ Body: ${e.requestOptions.data}\n'
        '╟ Header: ${e.requestOptions.headers}\n'
        '╟ statusCode: ${e.response == null ? null : e.response!.statusCode}\n'
        '╟ RESPONSE: ${e.response == null ? null : e.response!.data} \n'
        '╟ stackTrace: ${e.stackTrace} \n'
        '╚ [END] ════════════════════════════════════════╝';
    developer.log(trace);
  }

  void _networkLog(Response response) {
    String trace = '════════════════════════════════════════ \n'
        '╔╣ Dio [RESPONSE] info ==> \n'
        '╟ BASE_URL: ${response.requestOptions.baseUrl}\n'
        '╟ PATH: ${response.requestOptions.path}\n'
        '╟ Method: ${response.requestOptions.method}\n'
        '╟ Params: ${response.requestOptions.queryParameters}\n'
        '╟ Body: ${response.requestOptions.data}\n'
        '╟ Header: ${response.requestOptions.headers}\n'
        '╟ statusCode: ${response.statusCode}\n'
        '╟ RESPONSE: ${jsonEncode(response.data)} \n'
        '╚ [END] ════════════════════════════════════════╝';
    developer.log(trace);
  }
}
