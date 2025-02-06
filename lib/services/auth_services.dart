import 'dart:developer';

import 'package:crm/constants/api_constant.dart';
import 'package:crm/database/function.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Models/user_data.dart';
import '../database/dio/dio/dio_client.dart';
import '../database/dio/exception/api_error_handler.dart';
import '../store/app_store.dart';
import '../utils/default_logger.dart';
import '../widgets/toastification/toastification.dart';

class AuthService {
  static String tag = 'AuthService';

  Future<String?> getFbToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    try {
      String? token = defaultTargetPlatform == TargetPlatform.macOS
          ? await firebaseMessaging.getAPNSToken() ?? 'unable to get token [macos]'
          : await firebaseMessaging.getToken();
      debugPrint('FirebaseMessaging token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting FirebaseMessaging token: $e');
      return null;
    }
  }
  /// login with email and password
  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      var requestData = {
        "username": email,
        "password": password,
        'device_id': await getDeviceId(),
        'fcm_token': await getFbToken(),
      };
      infoLog('Request Data: $requestData');
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(
        ApiConstant.login,
        data: requestData,
      );
      infoLog('API Response: $data');
      if (status) {
        String? token = data['login_token'];
        log('data : token=> $token');
        if (token != null) {
          Map<String, dynamic>? user = data['userData'];
          if (user != null && user.isNotEmpty) {
            ///set user data
            for (var key in user.keys) {
              await setUserDataByFieldName(key, user[key]);
            }
            await appStore.setUser(userFromJson(user));
            await appStore.setToken(token);

            dioClient.updateHeader(token);

            await appStore.setLoggedIn(true);
          }
        }
      } else {
        TF.show(
          context: context,
          message: message ?? 'Login failed',
          type: TF.error,
          style: TF.flat,
        );
      }
    } catch (e) {
      logger.e('login error : $e', tag: tag);
    }
  }

  /// Logout method
  Future<bool> logout({
    required BuildContext context,
    required bool isSessionExpired,
  }) async {
    try {
      await appStore.setUser(null);
      await appStore.setToken('');
      await appStore.setLoggedIn(false);
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      return true; // Logout successful
    } catch (e) {
      print("Logout failed: $e");
      return false; // Logout failed
    }
  }
}

Future<void> setUserDataByFieldName(String fieldName, dynamic value) async {
  try {
    switch (fieldName) {
      case 'firstname':
        await appStore.setFirstName(value);
        break;
      case 'lastname':
        await appStore.setLastName(value);
        break;
      case 'email':
        await appStore.setUserEmail(value ?? '');
        break;
      case 'phone_number':
        await appStore.setPhoneNumber(value ?? '');
        break;
      case 'facebook':
        await appStore.setFacebook(value ?? '');
        break;
      case 'linkedin':
        await appStore.setLinkedin(value ?? '');
        break;
      case 'skype':
        await appStore.setSkype(value ?? '');
        break;
      case 'password':
        await appStore.setPassword(value ?? '');
        break;
      case 'datecreated':
        await appStore.setDateCreated(value ?? '');
        break;
      case 'profile_image':
        await appStore.setProfileImage(value ?? '');
        break;
      case 'last_ip':
        await appStore.setLastIp(value ?? '');
        break;
      case 'last_login':
        await appStore.setLastLogin(value ?? '');
        break;
      case 'last_activity':
        await appStore.setLastActivity(value ?? '');
        break;
      case 'last_password_change':
        await appStore.setLastPasswordChange(value ?? '');
        break;
      case 'new_pass_key':
        await appStore.setNewPassKey(value ?? '');
        break;
      case 'new_pass_key_requested':
        await appStore.setNewPassKeyRequested(value ?? '');
        break;
      case 'admin':
        await appStore.setAdmin(value ?? '');
        break;
      case 'role':
        await appStore.setRole(value ?? '');
        break;
      case 'active':
        await appStore.setActive(value ?? '');
        break;
      case 'default_language':
        await appStore.setDefaultLanguage(value ?? '');
        break;
      case 'direction':
        await appStore.setDirection(value ?? '');
        break;
      case 'media_path_slug':
        await appStore.setMediaPathSlug(value ?? '');
        break;
      case 'is_not_staff':
        await appStore.setIsNotStaff(value ?? '');
        break;
      case 'hourly_rate':
        await appStore.setHourlyRate(value ?? '');
        break;
      case 'two_factor_auth_enabled':
        await appStore.setTwoFactorAuthEnabled(value ?? '');
        break;
      case 'two_factor_auth_code':
        await appStore.setTwoFactorAuthCode(value ?? '');
        break;
      case 'two_factor_auth_code_requested':
        await appStore.setTwoFactorAuthCodeRequested(value ?? '');
        break;
      case 'email_signature':
        await appStore.setEmailSignature(value ?? '');
        break;
      case 'google_auth_secret':
        await appStore.setGoogleAuthSecret(value ?? '');
        break;
      case 'device_id':
        await appStore.setDeviceId(value ?? '');
        break;
      case 'is_login':
        await appStore.setIsLogin(value ?? '');
        break;
      case 'login_ip_address':
        await appStore.setLoginIpAddress(value ?? '');
        break;
      case 'staffid':
        await appStore
            .setStaffId(value ?? 0); // Assuming setStaffId function exists
        break;
      case 'login_token':
        await appStore.setToken(value ?? '');
        break;
      case 'login_time':
        await appStore.setLoginTime(value ?? '');
        break;
      default:
        break;
    }
  } catch (e) {
    logger.e('setUserDataByFieldName error on $fieldName $value : $e');
  }
}
