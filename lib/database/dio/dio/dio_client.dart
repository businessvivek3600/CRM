import 'dart:developer';
import 'dart:io';

import 'package:crm/constants/app_constants.dart';
import 'package:crm/store/app_store.dart';
import 'package:dio/dio.dart';

import '../../../utils/default_logger.dart';
import '../database_index.dart';

late DioClient dioClient;

class DioClient{
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  late Dio dio;
  String? _userToken;

  DioClient({required this.baseUrl, required this.loggingInterceptor}) {
    dio = Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: 30000)
      ..options.receiveTimeout = const Duration(milliseconds: 30000)
      ..httpClientAdapter
      ..options.headers = {
        Headers.contentTypeHeader: 'application/json',
        Headers.acceptHeader: '*/*',
        'x-api-key': "touchwoodtechnologiescrm@741852963",
      }
      ..options.responseType = ResponseType.json;
    dio.interceptors.add(loggingInterceptor);
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.data['status'] == false) {
          if (response.data['message'] == "The Token field is required.") {
            appStore.setSessionExpired(true);
          }
        }
        handler.next(response);
      },
    ));
    logger.f('DioClient ${dio.options.baseUrl}',
        tag: 'DioClient', error: dio.options.headers);
  }
  void updateHeader(String? token, {String? contentType}) {
    dio.options.headers = {
      Headers.acceptHeader: '*/*',
      Headers.wwwAuthenticateHeader : "touchwoodtechnologiescrm@741852963",
      Headers.contentTypeHeader: contentType ?? 'application/json; charset=UTF-8',
      'x-api-key': "touchwoodtechnologiescrm@741852963",
    };
    log('updateUserToken : ${dio.options.headers}');

  }

  Future<Response> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool token = true,
      }) async {
    try {

      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on SocketException catch (err) {
      throw SocketException(err.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> post(
      String uri, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,

        bool token = true,
      }) async {
    try {

      FormData formData = FormData();
      if (data is Map<String, dynamic>) {
        formData.fields
            .addAll(data.entries.toList().map((e) => MapEntry(e.key, e.value)));
      } else {
        if (data == null) {
          formData = FormData();
        } else {
          formData = data as FormData;
        }
      }
      if (token) {
        formData.fields.add(MapEntry('login_token', appStore.token));
      }

      pl('formdata :${formData.fields} ${dio.options.headers}', 'DIO CLIENT');
      var response = await dio.post(
        uri,
        data: formData,
        queryParameters: queryParameters,
        options: options,

      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,

      }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,

      );

      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
      String uri, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,

      }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,

      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}



