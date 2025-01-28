import 'dart:developer';

import 'package:crm/Models/dashboard_model.dart';
import 'package:crm/constants/api_constant.dart';
import 'package:crm/database/function.dart';
import 'package:crm/utils/colors.dart';
import 'package:dio/dio.dart';
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

  ///--------------------Leads--------------------

  /// Fetch leads from the API
  static Future<(bool, Map<String, dynamic>, String?)> getLeads(
      {int page = 0}) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData('${ApiConstant.getLeads}?page=$page',
              method: ApiMethod.POST);

      if (status && data.isNotEmpty) {
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: completedColor,
          textColor: Colors.white,
        );
        return (true, data, message);
      } else {
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
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

  static Future<(bool, Map<String, dynamic>, String?)> addLeads(
      FormData info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.addLead, data: info);
      log('data : $data');

      if (status) {
        log("message --$message");
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: completedColor,
          textColor: Colors.white,
        );
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  ///__________Convert-lead-to-customer----------
  static Future<(bool, Map<String, dynamic>, String?)> convertCustomer(
      FormData info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.convertToCustomer,
              data: info);
      log('data : $data');
      toastLong(
        data['message'],
        gravity: ToastGravity.TOP,
        bgColor: completedColor,
        textColor: Colors.white,
      );
      if (status) {
        log("message --$message");
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  ///---ADD & Edit & delete note----
  static Future<(bool, Map<String, dynamic>, String?)> addNote(
      Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.addNote, data: info);

      if (data['status']) {
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: completedColor,
          textColor: Colors.white,
        );
        TF.success;
        log('data ________________________-: $data');
        return (status, data, message);
      } else {
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  static Future<(bool, Map<String, dynamic>, String?)> editNote(
      Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.editNote, data: info);
      log('data : $data');
      toastLong(
        data['message'],
        gravity: ToastGravity.TOP,
        bgColor: completedColor,
        textColor: Colors.white,
      );
      if (data['status']) {
        log("message --$message");
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  static Future<(bool, Map<String, dynamic>, String?)> deleteNote(
      Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.deleteNote, data: info);
      log('data : $data');
      toastLong(
        data['message'],
        gravity: ToastGravity.TOP,
        bgColor: completedColor,
        textColor: Colors.white,
      );
      if (status) {
        log("message --$message");
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  ///------------------------Remainders-----------------------
  static Future<(bool, Map<String, dynamic>, String?)> addReminder(
      Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.addReminder, data: info);
      log('data : $data');
      toastLong(
        data['message'],
        gravity: ToastGravity.TOP,
        bgColor: completedColor,
        textColor: Colors.white,
      );
      if (status) {
        log("message --$message");
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  static Future<(bool, Map<String, dynamic>, String?)> editReminder(
      Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.editReminder,
              data: info);
      log('data : $data');
      toastLong(
        data['message'],
        gravity: ToastGravity.TOP,
        bgColor: completedColor,
        textColor: Colors.white,
      );
      if (status) {
        log("message --$message");
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  static Future<(bool, Map<String, dynamic>, String?)> deleteReminder(
      Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.deleteReminder,
              data: info);
      log('data : $data');
      toastLong(
        data['message'],
        gravity: ToastGravity.TOP,
        bgColor: completedColor,
        textColor: Colors.white,
      );
      if (status) {
        log("message --$message");
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  ///------------------------Customers-----------------------
  /// Fetch customers from the API
  static Future<(bool, Map<String, dynamic>, String?)> getCustomers(
      {int page = 0}) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData('${ApiConstant.getCustomer}?page=$page',
              method: ApiMethod.POST);
      toastLong(
        data['message'],
        gravity: ToastGravity.TOP,
        bgColor: completedColor,
        textColor: Colors.white,
      );

      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        toastLong(
          data['message'],
          gravity: ToastGravity.TOP,
          bgColor: buyColor,
          textColor: Colors.white,
        );
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

  ///------------------------Dashboard-----------------------
  /// Fetch Dashboard from the API
  static Future<(bool, Map<String, dynamic>, String?)>
      getDashboardData() async {
    try {
      // Fetch data using the ApiHandler
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConstant.dashboard,
              method: ApiMethod.POST);

      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        message = message?.split('.').first;
        // Optionally log or handle the error
        logger.e('Dashboard API error: $message', tag: 'DashboardAPI');
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      // Handle exceptions gracefully
      logger.e('getDashboardData error: $e', tag: 'DashboardAPI');
    }

    // Return default failure response in case of error
    return (false, <String, dynamic>{}, null);
  }

  ///----------------------Customer----------
  static Future<(bool, Map<String, dynamic>, String?)> editCustomer(
      Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.editCustomer,
              data: info);
      log('data : $data');
      if (status) {
        log("message --$message");
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }

  ///__________Pass user Current Location to api----------
  static Future<(bool, Map<String, dynamic>, String?)> uploadLocation(
      FormData info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await await ApiHandler.fetchData(ApiConstant.userLocation,
              data: info);
      log('data : $data');
      if (status) {
        log("message --$message");
      } else {
        return (false, data, message);
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, '');
  }
}
