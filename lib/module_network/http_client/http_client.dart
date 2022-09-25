import 'dart:convert';
import 'package:my_kom/utils/logger/logger.dart';
import 'package:dio/dio.dart';
//import 'package:dio_firebase_performance/dio_firebase_performance.dart';

class ApiClient {
  String? token;
  final _logger = Logger();
  final String tag = 'ApiClient';

 // final performanceInterceptor = DioFirebasePerformanceInterceptor();
  final _client = Dio(BaseOptions(
    sendTimeout: 60000,
    receiveTimeout: 60000,
    connectTimeout: 60000,
   // baseUrl: Urls.BASE_API,
  ));


  Future<Map<String, dynamic>?> get(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      _logger.info(tag, 'Requesting GET to: ' + url);
      _logger.info(tag, 'Headers: ' + headers.toString());
      _logger.info(tag, 'Query: ' + queryParams.toString());

     // _client.interceptors.add(performanceInterceptor);
      
      if (headers != null) {
        if (headers['Authorization'] != null) {
          _logger.info(tag, 'Adding Auth Header');
          _client.options.headers['Authorization'] = headers['Authorization'];
        }
      }
      var response = await _client.get(
        url,
        queryParameters: queryParams,
      );
      return _processResponse(response);
    } catch (e) {
      _logger.error(tag, e.toString() + ', GET: ' + url, StackTrace.current);
      return null;
    }
  }

  Future<Map<String, dynamic>?> post(
    String url,
    Map<String, dynamic> payLoad, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {

    try {
      _logger.info(tag, 'Requesting Post to: ' + url);
      _logger.info(tag, 'POST: ' + jsonEncode(payLoad));
      _logger.info(tag, 'Headers: ' + jsonEncode(headers));

      if (headers != null) {
        if (headers['Authorization'] != null) {
          _logger.info(tag, 'Adding Auth Header');
          _client.options.headers['Authorization'] = headers['Authorization'];
          _client.options.headers['Content-Type'] = headers['application/json'];
        }
      }
    //_client.interceptors.add(performanceInterceptor);
      var response = await _client.post(url,
        queryParameters: queryParams,
        data: json.encode(payLoad)
      );
  return _processResponse(response);
    } catch (e) {
      _logger.error(tag, e.toString() + ', POST: ' + url, StackTrace.current);
      return null;
    }
  }
  Future<Map<String, dynamic>?> put(
    String url,
    Map<String, dynamic> payLoad, {
     Map<String, String>? queryParams ,
    Map<String, String>? headers,
  }) async {
    try {
     
      headers ??= {};
      _client.options.headers['Authorization'] = headers['Authorization'];
      _client.options.headers['Content-Type'] = 'application/json';

      _logger.info(tag, 'Requesting PUT to: ' + url);
      _logger.info(tag, 'PUT: ' + jsonEncode(payLoad));
      _logger.info(tag, 'Headers: ${_client.options.headers}');

      //_client.interceptors.add(performanceInterceptor);

      var response = await _client.put(
        url,
        queryParameters: queryParams,
        data: json.encode(payLoad),
        options: Options(headers: headers),
      );
      return _processResponse(response);
    } catch (e) {
      _logger.error(tag, e.toString() + ', PUT: ' + url, StackTrace.current);
      return null;
    }
  }

  Future<Map<String, dynamic>?> delete(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      _logger.info(tag, 'Requesting DELETE to: ' + url);
      _logger.info(tag, 'Headers: ' + headers.toString());
      _logger.info(tag, 'Query: ' + queryParams.toString());

     // _client.interceptors.add(performanceInterceptor);
      if (headers != null) {
        if (headers['Authorization'] != null) {
          _logger.info(tag, 'Adding Auth Header');
          _client.options.headers['Authorization'] = headers['Authorization'];
        }
      }
      var response = await _client.delete(
        url,
        queryParameters: queryParams,
      );
      return _processResponse(response);
    } catch (e) {
      _logger.error(tag, e.toString() + ', DELETE: ' + url, StackTrace.current);
      return null;
    }
  }

  Map<String, dynamic>? _processResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      _logger.info(tag, response.data.toString());
      return response.data;
    } else if (response.statusCode! <= 400 && response.statusCode! < 500) {
      return null;
    } else {
      _logger.error(
          tag,
          response.statusCode.toString() + '\n\n' + response.data.toString(),
          StackTrace.current);
      return null;
    }
  }
}
