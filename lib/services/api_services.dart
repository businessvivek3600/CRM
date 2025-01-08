import 'dart:developer';

import 'package:crm/constants/api_constant.dart';
import 'package:crm/database/function.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Models/user_data.dart';
import '../constants/enums.dart';
import '../database/dio/dio/dio_client.dart';
import '../database/dio/exception/api_error_handler.dart';
import '../store/app_store.dart';
import '../utils/default_logger.dart';
import '../widgets/toastification/toastification.dart';

class ApiService {
  static String tag = 'ApiService';

  /// Fetch leads from the API
  static Future<(bool, Map<String, dynamic>, String?)> getLeads({int page = 0}) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData('${ApiConstant.getLeads}?page=$page',
              method: ApiMethod.POST);

      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        message = message?.split('.').first;
        // Uncomment below line to show toast notification
        // toast(message ?? 'Something went wrong', gravity: ToastGravity.TOP, bgColor: Colors.red);
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getLeads error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  /// Fetch customers from the API
  static Future<(bool, Map<String, dynamic>, String?)> getCustomers({int page = 0}) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData('${ApiConstant.getCustomer}?page=$page',
              method: ApiMethod.POST);

      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        message = message?.split('.').first;
        // Uncomment below line to show toast notification
        // toast(message ?? 'Something went wrong', gravity: ToastGravity.TOP, bgColor: Colors.red);
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getCustomers error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }
}
