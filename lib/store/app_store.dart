
import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Models/user_data.dart';
import '../constants/value_constants.dart';
import '../utils/default_logger.dart';

part 'app_store.g.dart';

final appStore = AppStore();

class AppStore =  _AppStore with _$AppStore;

abstract class _AppStore with Store {

///Variables
  @observable
  bool isSessionExpired = false;

  @observable
  bool canAskForExitApp = true;

  @observable
  String token = '';

  @observable
  bool isLoggedIn = false;

  ///User data variable
  @observable
  String staffId = '';

  @observable
  String userEmail = '';

  @observable
  String firstName = '';

  @observable
  String lastName = '';

  @observable
  String facebook = '';

  @observable
  String linkedin = '';

  @observable
  String phoneNumber = '';

  @observable
  String skype = '';

  @observable
  String password = '';

  @observable
  String dateCreated = '';

  @observable
  String profileImage = '';

  @observable
  String lastIp = '';

  @observable
  String lastLogin = '';

  @observable
  String lastActivity = '';

  @observable
  String? lastPasswordChange;

  @observable
  String? newPassKey;

  @observable
  String? newPassKeyRequested;

  @observable
  String admin = '';

  @observable
  String role = '';

  @observable
  String active = '';

  @observable
  String defaultLanguage = '';

  @observable
  String direction = '';

  @observable
  String mediaPathSlug = '';

  @observable
  String isNotStaff = '';

  @observable
  String hourlyRate = '';

  @observable
  String twoFactorAuthEnabled = '';

  @observable
  String? twoFactorAuthCode;

  @observable
  String? twoFactorAuthCodeRequested;

  @observable
  String emailSignature = '';

  @observable
  String? googleAuthSecret;

  @observable
  String deviceId = '';

  @observable
  String isLogin = '';

  @observable
  String? loginIpAddress;

  @observable
  String loginTime = '';

  @observable
  String loginToken = '';

  @observable
  bool rememberMe = false;

  @observable
  bool isLoading = false;


  @action
  void setLoading(bool val) {
    isLoading = val;
  }


  @action
  void setRememberMe(bool value) => rememberMe = value;
  ///---REmember me
  ///
  @action
  void setIsLoggedIn(bool value) => isLoggedIn = value;
  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }


  Future<void> saveCredentials(String email, String password) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
  }

  Future<Map<String, String?>> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email'),
      'password': prefs.getString('password'),
    };
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    setIsLoggedIn(false);
  }


///get full name
  @computed
  String get fullName {
    return '$firstName $lastName'.trim();
  }


  ////
///set User_data
  @action
  Future<void> setStaffId(String val, {bool isInitializing = false}) async {
    staffId = val;
    if (!isInitializing) await setValue(STAFF_ID, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitializing = false}) async {
    firstName = val;
    if (!isInitializing) await setValue(FIRST_NAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitializing = false}) async {
    lastName = val;
    if (!isInitializing) await setValue(LAST_NAME, val);
  }

  @action
  Future<void> setFacebook(String val, {bool isInitializing = false}) async {
    facebook = val;
    if (!isInitializing) await setValue(FACEBOOK, val);
  }

  @action
  Future<void> setLinkedin(String val, {bool isInitializing = false}) async {
    linkedin = val;
    if (!isInitializing) await setValue(LINKEDIN, val);
  }

  @action
  Future<void> setPhoneNumber(String val, {bool isInitializing = false}) async {
    phoneNumber = val;
    if (!isInitializing) await setValue(PHONE_NUMBER, val);
  }

  @action
  Future<void> setSkype(String val, {bool isInitializing = false}) async {
    skype = val;
    if (!isInitializing) await setValue(SKYPE, val);
  }

  @action
  Future<void> setPassword(String val, {bool isInitializing = false}) async {
    password = val;
    if (!isInitializing) await setValue(PASSWORD, val);
  }

  @action
  Future<void> setDateCreated(String val, {bool isInitializing = false}) async {
    dateCreated = val;
    if (!isInitializing) await setValue(DATE_CREATED, val);
  }

  @action
  Future<void> setProfileImage(String val, {bool isInitializing = false}) async {
    profileImage = val;
    if (!isInitializing) await setValue(PROFILE_IMAGE, val);
  }

  @action
  Future<void> setLastIp(String val, {bool isInitializing = false}) async {
    lastIp = val;
    if (!isInitializing) await setValue(LAST_IP, val);
  }

  @action
  Future<void> setLastLogin(String val, {bool isInitializing = false}) async {
    lastLogin = val;
    if (!isInitializing) await setValue(LAST_LOGIN, val);
  }

  @action
  Future<void> setLastActivity(String val, {bool isInitializing = false}) async {
    lastActivity = val;
    if (!isInitializing) await setValue(LAST_ACTIVITY, val);
  }

  @action
  Future<void> setLastPasswordChange(String? val, {bool isInitializing = false}) async {
    lastPasswordChange = val;
    if (!isInitializing) await setValue(LAST_PASSWORD_CHANGE, val);
  }

  @action
  Future<void> setNewPassKey(String? val, {bool isInitializing = false}) async {
    newPassKey = val;
    if (!isInitializing) await setValue(NEW_PASS_KEY, val);
  }

  @action
  Future<void> setNewPassKeyRequested(String? val, {bool isInitializing = false}) async {
    newPassKeyRequested = val;
    if (!isInitializing) await setValue(NEW_PASS_KEY_REQUESTED, val);
  }

  @action
  Future<void> setAdmin(String val, {bool isInitializing = false}) async {
    admin = val;
    if (!isInitializing) await setValue(ADMIN, val);
  }

  @action
  Future<void> setRole(String val, {bool isInitializing = false}) async {
    role = val;
    if (!isInitializing) await setValue(ROLE, val);
  }

  @action
  Future<void> setActive(String val, {bool isInitializing = false}) async {
    active = val;
    if (!isInitializing) await setValue(ACTIVE, val);
  }

  @action
  Future<void> setDefaultLanguage(String val, {bool isInitializing = false}) async {
    defaultLanguage = val;
    if (!isInitializing) await setValue(DEFAULT_LANGUAGE, val);
  }

  @action
  Future<void> setDirection(String val, {bool isInitializing = false}) async {
    direction = val;
    if (!isInitializing) await setValue(DIRECTION, val);
  }

  @action
  Future<void> setMediaPathSlug(String val, {bool isInitializing = false}) async {
    mediaPathSlug = val;
    if (!isInitializing) await setValue(MEDIA_PATH_SLUG, val);
  }

  @action
  Future<void> setIsNotStaff(String val, {bool isInitializing = false}) async {
    isNotStaff = val;
    if (!isInitializing) await setValue(IS_NOT_STAFF, val);
  }

  @action
  Future<void> setHourlyRate(String val, {bool isInitializing = false}) async {
    hourlyRate = val;
    if (!isInitializing) await setValue(HOURLY_RATE, val);
  }

  @action
  Future<void> setTwoFactorAuthEnabled(String val, {bool isInitializing = false}) async {
    twoFactorAuthEnabled = val;
    if (!isInitializing) await setValue(TWO_FACTOR_AUTH_ENABLED, val);
  }

  @action
  Future<void> setTwoFactorAuthCode(String? val, {bool isInitializing = false}) async {
    twoFactorAuthCode = val;
    if (!isInitializing) await setValue(TWO_FACTOR_AUTH_CODE, val);
  }

  @action
  Future<void> setTwoFactorAuthCodeRequested(String? val, {bool isInitializing = false}) async {
    twoFactorAuthCodeRequested = val;
    if (!isInitializing) await setValue(TWO_FACTOR_AUTH_CODE_REQUESTED, val);
  }

  @action
  Future<void> setEmailSignature(String val, {bool isInitializing = false}) async {
    emailSignature = val;
    if (!isInitializing) await setValue(EMAIL_SIGNATURE, val);
  }

  @action
  Future<void> setGoogleAuthSecret(String? val, {bool isInitializing = false}) async {
    googleAuthSecret = val;
    if (!isInitializing) await setValue(GOOGLE_AUTH_SECRET, val);
  }

  @action
  Future<void> setDeviceId(String val, {bool isInitializing = false}) async {
    deviceId = val;
    if (!isInitializing) await setValue(DEVICE_ID, val);
  }

  @action
  Future<void> setIsLogin(String val, {bool isInitializing = false}) async {
    isLogin = val;
    if (!isInitializing) await setValue(IS_LOGIN, val);
  }

  @action
  Future<void> setLoginIpAddress(String? val, {bool isInitializing = false}) async {
    loginIpAddress = val;
    if (!isInitializing) await setValue(LOGIN_IP_ADDRESS, val);
  }

  @action
  Future<void> setLoginTime(String val, {bool isInitializing = false}) async {
    loginTime = val;
    if (!isInitializing) await setValue(LOGIN_TIME, val);
  }





  ///For Exit App----
  @action
  Future<void> setAskForExitApp(bool val) async {
    canAskForExitApp = val;
    pl('setAskForExitApp: $val [$canAskForExitApp]');
  }


  ///For Login session
  @action
  Future<void> setSessionExpired(bool val) async {
    isSessionExpired = val;
    setAskForExitApp(!val);
    pl('setSessionExpired: $val [$isSessionExpired]');
  }

  ///set token
  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(TOKEN, val);
  }

  /// USER DATA -> START
  @observable
  User? user;

  @action
  Future<void> setUser(User? val, {bool isInitializing = false}) async {
    user = val;
    if (!isInitializing) {
      await setValue(USER_DATA, jsonEncode(val?.toJson()));
    }
  }


  @action
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString(USER_DATA);

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      await setUserData(userData, isInitializing: true);
      setLoggedIn(true); // Mark the user as logged in
    } else {
      setLoggedIn(false); // Mark the user as not logged in
    }
  }
  @action
  Future<void> setUserData(Map<String, dynamic> userData, {bool isInitializing = false}) async {
    await setStaffId(userData['staffid'] ?? '', isInitializing: isInitializing);
    await setUserEmail(userData['email'] ?? '', isInitializing: isInitializing);
    await setFirstName(userData['firstname'] ?? '', isInitializing: isInitializing);
    await setLastName(userData['lastname'] ?? '', isInitializing: isInitializing);
    await setFacebook(userData['facebook'] ?? '', isInitializing: isInitializing);
    await setLinkedin(userData['linkedin'] ?? '', isInitializing: isInitializing);
    await setPhoneNumber(userData['phonenumber'] ?? '', isInitializing: isInitializing);
    await setSkype(userData['skype'] ?? '', isInitializing: isInitializing);
    await setPassword(userData['password'] ?? '', isInitializing: isInitializing);
    await setDateCreated(userData['datecreated'] ?? '', isInitializing: isInitializing);
    await setProfileImage(userData['thumb_image'] ?? '', isInitializing: isInitializing);
    await setLastIp(userData['last_ip'] ?? '', isInitializing: isInitializing);
    await setLastLogin(userData['last_login'] ?? '', isInitializing: isInitializing);
    await setLastActivity(userData['last_activity'] ?? '', isInitializing: isInitializing);
    await setLastPasswordChange(userData['last_password_change'], isInitializing: isInitializing);
    await setNewPassKey(userData['new_pass_key'], isInitializing: isInitializing);
    await setNewPassKeyRequested(userData['new_pass_key_requested'], isInitializing: isInitializing);
    await setAdmin(userData['admin'] ?? '', isInitializing: isInitializing);
    await setRole(userData['role'] ?? '', isInitializing: isInitializing);
    await setActive(userData['active'] ?? '', isInitializing: isInitializing);
    await setDefaultLanguage(userData['default_language'] ?? '', isInitializing: isInitializing);
    await setDirection(userData['direction'] ?? '', isInitializing: isInitializing);
    await setMediaPathSlug(userData['media_path_slug'] ?? '', isInitializing: isInitializing);
    await setIsNotStaff(userData['is_not_staff'] ?? '', isInitializing: isInitializing);
    await setHourlyRate(userData['hourly_rate'] ?? '', isInitializing: isInitializing);
    await setTwoFactorAuthEnabled(userData['two_factor_auth_enabled'] ?? '', isInitializing: isInitializing);
    await setTwoFactorAuthCode(userData['two_factor_auth_code'], isInitializing: isInitializing);
    await setTwoFactorAuthCodeRequested(userData['two_factor_auth_code_requested'], isInitializing: isInitializing);
    await setEmailSignature(userData['email_signature'] ?? '', isInitializing: isInitializing);
    await setGoogleAuthSecret(userData['google_auth_secret'], isInitializing: isInitializing);
    await setDeviceId(userData['device_id'] ?? '', isInitializing: isInitializing);
    await setIsLogin(userData['is_login'] ?? '', isInitializing: isInitializing);
    await setLoginIpAddress(userData['login_ip_address'], isInitializing: isInitializing);
    await setLoginTime(userData['login_time'] ?? '', isInitializing: isInitializing);
  }

}