// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  Computed<String>? _$fullNameComputed;

  @override
  String get fullName => (_$fullNameComputed ??=
          Computed<String>(() => super.fullName, name: '_AppStore.fullName'))
      .value;

  late final _$isSessionExpiredAtom =
      Atom(name: '_AppStore.isSessionExpired', context: context);

  @override
  bool get isSessionExpired {
    _$isSessionExpiredAtom.reportRead();
    return super.isSessionExpired;
  }

  @override
  set isSessionExpired(bool value) {
    _$isSessionExpiredAtom.reportWrite(value, super.isSessionExpired, () {
      super.isSessionExpired = value;
    });
  }

  late final _$canAskForExitAppAtom =
      Atom(name: '_AppStore.canAskForExitApp', context: context);

  @override
  bool get canAskForExitApp {
    _$canAskForExitAppAtom.reportRead();
    return super.canAskForExitApp;
  }

  @override
  set canAskForExitApp(bool value) {
    _$canAskForExitAppAtom.reportWrite(value, super.canAskForExitApp, () {
      super.canAskForExitApp = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AppStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$staffIdAtom = Atom(name: '_AppStore.staffId', context: context);

  @override
  String get staffId {
    _$staffIdAtom.reportRead();
    return super.staffId;
  }

  @override
  set staffId(String value) {
    _$staffIdAtom.reportWrite(value, super.staffId, () {
      super.staffId = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: '_AppStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$firstNameAtom =
      Atom(name: '_AppStore.firstName', context: context);

  @override
  String get firstName {
    _$firstNameAtom.reportRead();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    _$firstNameAtom.reportWrite(value, super.firstName, () {
      super.firstName = value;
    });
  }

  late final _$lastNameAtom =
      Atom(name: '_AppStore.lastName', context: context);

  @override
  String get lastName {
    _$lastNameAtom.reportRead();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    _$lastNameAtom.reportWrite(value, super.lastName, () {
      super.lastName = value;
    });
  }

  late final _$facebookAtom =
      Atom(name: '_AppStore.facebook', context: context);

  @override
  String get facebook {
    _$facebookAtom.reportRead();
    return super.facebook;
  }

  @override
  set facebook(String value) {
    _$facebookAtom.reportWrite(value, super.facebook, () {
      super.facebook = value;
    });
  }

  late final _$linkedinAtom =
      Atom(name: '_AppStore.linkedin', context: context);

  @override
  String get linkedin {
    _$linkedinAtom.reportRead();
    return super.linkedin;
  }

  @override
  set linkedin(String value) {
    _$linkedinAtom.reportWrite(value, super.linkedin, () {
      super.linkedin = value;
    });
  }

  late final _$phoneNumberAtom =
      Atom(name: '_AppStore.phoneNumber', context: context);

  @override
  String get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  late final _$skypeAtom = Atom(name: '_AppStore.skype', context: context);

  @override
  String get skype {
    _$skypeAtom.reportRead();
    return super.skype;
  }

  @override
  set skype(String value) {
    _$skypeAtom.reportWrite(value, super.skype, () {
      super.skype = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_AppStore.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$dateCreatedAtom =
      Atom(name: '_AppStore.dateCreated', context: context);

  @override
  String get dateCreated {
    _$dateCreatedAtom.reportRead();
    return super.dateCreated;
  }

  @override
  set dateCreated(String value) {
    _$dateCreatedAtom.reportWrite(value, super.dateCreated, () {
      super.dateCreated = value;
    });
  }

  late final _$profileImageAtom =
      Atom(name: '_AppStore.profileImage', context: context);

  @override
  String get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(String value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  late final _$lastIpAtom = Atom(name: '_AppStore.lastIp', context: context);

  @override
  String get lastIp {
    _$lastIpAtom.reportRead();
    return super.lastIp;
  }

  @override
  set lastIp(String value) {
    _$lastIpAtom.reportWrite(value, super.lastIp, () {
      super.lastIp = value;
    });
  }

  late final _$lastLoginAtom =
      Atom(name: '_AppStore.lastLogin', context: context);

  @override
  String get lastLogin {
    _$lastLoginAtom.reportRead();
    return super.lastLogin;
  }

  @override
  set lastLogin(String value) {
    _$lastLoginAtom.reportWrite(value, super.lastLogin, () {
      super.lastLogin = value;
    });
  }

  late final _$lastActivityAtom =
      Atom(name: '_AppStore.lastActivity', context: context);

  @override
  String get lastActivity {
    _$lastActivityAtom.reportRead();
    return super.lastActivity;
  }

  @override
  set lastActivity(String value) {
    _$lastActivityAtom.reportWrite(value, super.lastActivity, () {
      super.lastActivity = value;
    });
  }

  late final _$lastPasswordChangeAtom =
      Atom(name: '_AppStore.lastPasswordChange', context: context);

  @override
  String? get lastPasswordChange {
    _$lastPasswordChangeAtom.reportRead();
    return super.lastPasswordChange;
  }

  @override
  set lastPasswordChange(String? value) {
    _$lastPasswordChangeAtom.reportWrite(value, super.lastPasswordChange, () {
      super.lastPasswordChange = value;
    });
  }

  late final _$newPassKeyAtom =
      Atom(name: '_AppStore.newPassKey', context: context);

  @override
  String? get newPassKey {
    _$newPassKeyAtom.reportRead();
    return super.newPassKey;
  }

  @override
  set newPassKey(String? value) {
    _$newPassKeyAtom.reportWrite(value, super.newPassKey, () {
      super.newPassKey = value;
    });
  }

  late final _$newPassKeyRequestedAtom =
      Atom(name: '_AppStore.newPassKeyRequested', context: context);

  @override
  String? get newPassKeyRequested {
    _$newPassKeyRequestedAtom.reportRead();
    return super.newPassKeyRequested;
  }

  @override
  set newPassKeyRequested(String? value) {
    _$newPassKeyRequestedAtom.reportWrite(value, super.newPassKeyRequested, () {
      super.newPassKeyRequested = value;
    });
  }

  late final _$adminAtom = Atom(name: '_AppStore.admin', context: context);

  @override
  String get admin {
    _$adminAtom.reportRead();
    return super.admin;
  }

  @override
  set admin(String value) {
    _$adminAtom.reportWrite(value, super.admin, () {
      super.admin = value;
    });
  }

  late final _$roleAtom = Atom(name: '_AppStore.role', context: context);

  @override
  String get role {
    _$roleAtom.reportRead();
    return super.role;
  }

  @override
  set role(String value) {
    _$roleAtom.reportWrite(value, super.role, () {
      super.role = value;
    });
  }

  late final _$activeAtom = Atom(name: '_AppStore.active', context: context);

  @override
  String get active {
    _$activeAtom.reportRead();
    return super.active;
  }

  @override
  set active(String value) {
    _$activeAtom.reportWrite(value, super.active, () {
      super.active = value;
    });
  }

  late final _$defaultLanguageAtom =
      Atom(name: '_AppStore.defaultLanguage', context: context);

  @override
  String get defaultLanguage {
    _$defaultLanguageAtom.reportRead();
    return super.defaultLanguage;
  }

  @override
  set defaultLanguage(String value) {
    _$defaultLanguageAtom.reportWrite(value, super.defaultLanguage, () {
      super.defaultLanguage = value;
    });
  }

  late final _$directionAtom =
      Atom(name: '_AppStore.direction', context: context);

  @override
  String get direction {
    _$directionAtom.reportRead();
    return super.direction;
  }

  @override
  set direction(String value) {
    _$directionAtom.reportWrite(value, super.direction, () {
      super.direction = value;
    });
  }

  late final _$mediaPathSlugAtom =
      Atom(name: '_AppStore.mediaPathSlug', context: context);

  @override
  String get mediaPathSlug {
    _$mediaPathSlugAtom.reportRead();
    return super.mediaPathSlug;
  }

  @override
  set mediaPathSlug(String value) {
    _$mediaPathSlugAtom.reportWrite(value, super.mediaPathSlug, () {
      super.mediaPathSlug = value;
    });
  }

  late final _$isNotStaffAtom =
      Atom(name: '_AppStore.isNotStaff', context: context);

  @override
  String get isNotStaff {
    _$isNotStaffAtom.reportRead();
    return super.isNotStaff;
  }

  @override
  set isNotStaff(String value) {
    _$isNotStaffAtom.reportWrite(value, super.isNotStaff, () {
      super.isNotStaff = value;
    });
  }

  late final _$hourlyRateAtom =
      Atom(name: '_AppStore.hourlyRate', context: context);

  @override
  String get hourlyRate {
    _$hourlyRateAtom.reportRead();
    return super.hourlyRate;
  }

  @override
  set hourlyRate(String value) {
    _$hourlyRateAtom.reportWrite(value, super.hourlyRate, () {
      super.hourlyRate = value;
    });
  }

  late final _$twoFactorAuthEnabledAtom =
      Atom(name: '_AppStore.twoFactorAuthEnabled', context: context);

  @override
  String get twoFactorAuthEnabled {
    _$twoFactorAuthEnabledAtom.reportRead();
    return super.twoFactorAuthEnabled;
  }

  @override
  set twoFactorAuthEnabled(String value) {
    _$twoFactorAuthEnabledAtom.reportWrite(value, super.twoFactorAuthEnabled,
        () {
      super.twoFactorAuthEnabled = value;
    });
  }

  late final _$twoFactorAuthCodeAtom =
      Atom(name: '_AppStore.twoFactorAuthCode', context: context);

  @override
  String? get twoFactorAuthCode {
    _$twoFactorAuthCodeAtom.reportRead();
    return super.twoFactorAuthCode;
  }

  @override
  set twoFactorAuthCode(String? value) {
    _$twoFactorAuthCodeAtom.reportWrite(value, super.twoFactorAuthCode, () {
      super.twoFactorAuthCode = value;
    });
  }

  late final _$twoFactorAuthCodeRequestedAtom =
      Atom(name: '_AppStore.twoFactorAuthCodeRequested', context: context);

  @override
  String? get twoFactorAuthCodeRequested {
    _$twoFactorAuthCodeRequestedAtom.reportRead();
    return super.twoFactorAuthCodeRequested;
  }

  @override
  set twoFactorAuthCodeRequested(String? value) {
    _$twoFactorAuthCodeRequestedAtom
        .reportWrite(value, super.twoFactorAuthCodeRequested, () {
      super.twoFactorAuthCodeRequested = value;
    });
  }

  late final _$emailSignatureAtom =
      Atom(name: '_AppStore.emailSignature', context: context);

  @override
  String get emailSignature {
    _$emailSignatureAtom.reportRead();
    return super.emailSignature;
  }

  @override
  set emailSignature(String value) {
    _$emailSignatureAtom.reportWrite(value, super.emailSignature, () {
      super.emailSignature = value;
    });
  }

  late final _$googleAuthSecretAtom =
      Atom(name: '_AppStore.googleAuthSecret', context: context);

  @override
  String? get googleAuthSecret {
    _$googleAuthSecretAtom.reportRead();
    return super.googleAuthSecret;
  }

  @override
  set googleAuthSecret(String? value) {
    _$googleAuthSecretAtom.reportWrite(value, super.googleAuthSecret, () {
      super.googleAuthSecret = value;
    });
  }

  late final _$deviceIdAtom =
      Atom(name: '_AppStore.deviceId', context: context);

  @override
  String get deviceId {
    _$deviceIdAtom.reportRead();
    return super.deviceId;
  }

  @override
  set deviceId(String value) {
    _$deviceIdAtom.reportWrite(value, super.deviceId, () {
      super.deviceId = value;
    });
  }

  late final _$isLoginAtom = Atom(name: '_AppStore.isLogin', context: context);

  @override
  String get isLogin {
    _$isLoginAtom.reportRead();
    return super.isLogin;
  }

  @override
  set isLogin(String value) {
    _$isLoginAtom.reportWrite(value, super.isLogin, () {
      super.isLogin = value;
    });
  }

  late final _$loginIpAddressAtom =
      Atom(name: '_AppStore.loginIpAddress', context: context);

  @override
  String? get loginIpAddress {
    _$loginIpAddressAtom.reportRead();
    return super.loginIpAddress;
  }

  @override
  set loginIpAddress(String? value) {
    _$loginIpAddressAtom.reportWrite(value, super.loginIpAddress, () {
      super.loginIpAddress = value;
    });
  }

  late final _$loginTimeAtom =
      Atom(name: '_AppStore.loginTime', context: context);

  @override
  String get loginTime {
    _$loginTimeAtom.reportRead();
    return super.loginTime;
  }

  @override
  set loginTime(String value) {
    _$loginTimeAtom.reportWrite(value, super.loginTime, () {
      super.loginTime = value;
    });
  }

  late final _$loginTokenAtom =
      Atom(name: '_AppStore.loginToken', context: context);

  @override
  String get loginToken {
    _$loginTokenAtom.reportRead();
    return super.loginToken;
  }

  @override
  set loginToken(String value) {
    _$loginTokenAtom.reportWrite(value, super.loginToken, () {
      super.loginToken = value;
    });
  }

  late final _$rememberMeAtom =
      Atom(name: '_AppStore.rememberMe', context: context);

  @override
  bool get rememberMe {
    _$rememberMeAtom.reportRead();
    return super.rememberMe;
  }

  @override
  set rememberMe(bool value) {
    _$rememberMeAtom.reportWrite(value, super.rememberMe, () {
      super.rememberMe = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$userAtom = Atom(name: '_AppStore.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) {
    return _$setLoggedInAsyncAction
        .run(() => super.setLoggedIn(val, isInitializing: isInitializing));
  }

  late final _$setStaffIdAsyncAction =
      AsyncAction('_AppStore.setStaffId', context: context);

  @override
  Future<void> setStaffId(String val, {bool isInitializing = false}) {
    return _$setStaffIdAsyncAction
        .run(() => super.setStaffId(val, isInitializing: isInitializing));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val, {bool isInitializing = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitializing: isInitializing));
  }

  late final _$setFirstNameAsyncAction =
      AsyncAction('_AppStore.setFirstName', context: context);

  @override
  Future<void> setFirstName(String val, {bool isInitializing = false}) {
    return _$setFirstNameAsyncAction
        .run(() => super.setFirstName(val, isInitializing: isInitializing));
  }

  late final _$setLastNameAsyncAction =
      AsyncAction('_AppStore.setLastName', context: context);

  @override
  Future<void> setLastName(String val, {bool isInitializing = false}) {
    return _$setLastNameAsyncAction
        .run(() => super.setLastName(val, isInitializing: isInitializing));
  }

  late final _$setFacebookAsyncAction =
      AsyncAction('_AppStore.setFacebook', context: context);

  @override
  Future<void> setFacebook(String val, {bool isInitializing = false}) {
    return _$setFacebookAsyncAction
        .run(() => super.setFacebook(val, isInitializing: isInitializing));
  }

  late final _$setLinkedinAsyncAction =
      AsyncAction('_AppStore.setLinkedin', context: context);

  @override
  Future<void> setLinkedin(String val, {bool isInitializing = false}) {
    return _$setLinkedinAsyncAction
        .run(() => super.setLinkedin(val, isInitializing: isInitializing));
  }

  late final _$setPhoneNumberAsyncAction =
      AsyncAction('_AppStore.setPhoneNumber', context: context);

  @override
  Future<void> setPhoneNumber(String val, {bool isInitializing = false}) {
    return _$setPhoneNumberAsyncAction
        .run(() => super.setPhoneNumber(val, isInitializing: isInitializing));
  }

  late final _$setSkypeAsyncAction =
      AsyncAction('_AppStore.setSkype', context: context);

  @override
  Future<void> setSkype(String val, {bool isInitializing = false}) {
    return _$setSkypeAsyncAction
        .run(() => super.setSkype(val, isInitializing: isInitializing));
  }

  late final _$setPasswordAsyncAction =
      AsyncAction('_AppStore.setPassword', context: context);

  @override
  Future<void> setPassword(String val, {bool isInitializing = false}) {
    return _$setPasswordAsyncAction
        .run(() => super.setPassword(val, isInitializing: isInitializing));
  }

  late final _$setDateCreatedAsyncAction =
      AsyncAction('_AppStore.setDateCreated', context: context);

  @override
  Future<void> setDateCreated(String val, {bool isInitializing = false}) {
    return _$setDateCreatedAsyncAction
        .run(() => super.setDateCreated(val, isInitializing: isInitializing));
  }

  late final _$setProfileImageAsyncAction =
      AsyncAction('_AppStore.setProfileImage', context: context);

  @override
  Future<void> setProfileImage(String val, {bool isInitializing = false}) {
    return _$setProfileImageAsyncAction
        .run(() => super.setProfileImage(val, isInitializing: isInitializing));
  }

  late final _$setLastIpAsyncAction =
      AsyncAction('_AppStore.setLastIp', context: context);

  @override
  Future<void> setLastIp(String val, {bool isInitializing = false}) {
    return _$setLastIpAsyncAction
        .run(() => super.setLastIp(val, isInitializing: isInitializing));
  }

  late final _$setLastLoginAsyncAction =
      AsyncAction('_AppStore.setLastLogin', context: context);

  @override
  Future<void> setLastLogin(String val, {bool isInitializing = false}) {
    return _$setLastLoginAsyncAction
        .run(() => super.setLastLogin(val, isInitializing: isInitializing));
  }

  late final _$setLastActivityAsyncAction =
      AsyncAction('_AppStore.setLastActivity', context: context);

  @override
  Future<void> setLastActivity(String val, {bool isInitializing = false}) {
    return _$setLastActivityAsyncAction
        .run(() => super.setLastActivity(val, isInitializing: isInitializing));
  }

  late final _$setLastPasswordChangeAsyncAction =
      AsyncAction('_AppStore.setLastPasswordChange', context: context);

  @override
  Future<void> setLastPasswordChange(String? val,
      {bool isInitializing = false}) {
    return _$setLastPasswordChangeAsyncAction.run(
        () => super.setLastPasswordChange(val, isInitializing: isInitializing));
  }

  late final _$setNewPassKeyAsyncAction =
      AsyncAction('_AppStore.setNewPassKey', context: context);

  @override
  Future<void> setNewPassKey(String? val, {bool isInitializing = false}) {
    return _$setNewPassKeyAsyncAction
        .run(() => super.setNewPassKey(val, isInitializing: isInitializing));
  }

  late final _$setNewPassKeyRequestedAsyncAction =
      AsyncAction('_AppStore.setNewPassKeyRequested', context: context);

  @override
  Future<void> setNewPassKeyRequested(String? val,
      {bool isInitializing = false}) {
    return _$setNewPassKeyRequestedAsyncAction.run(() =>
        super.setNewPassKeyRequested(val, isInitializing: isInitializing));
  }

  late final _$setAdminAsyncAction =
      AsyncAction('_AppStore.setAdmin', context: context);

  @override
  Future<void> setAdmin(String val, {bool isInitializing = false}) {
    return _$setAdminAsyncAction
        .run(() => super.setAdmin(val, isInitializing: isInitializing));
  }

  late final _$setRoleAsyncAction =
      AsyncAction('_AppStore.setRole', context: context);

  @override
  Future<void> setRole(String val, {bool isInitializing = false}) {
    return _$setRoleAsyncAction
        .run(() => super.setRole(val, isInitializing: isInitializing));
  }

  late final _$setActiveAsyncAction =
      AsyncAction('_AppStore.setActive', context: context);

  @override
  Future<void> setActive(String val, {bool isInitializing = false}) {
    return _$setActiveAsyncAction
        .run(() => super.setActive(val, isInitializing: isInitializing));
  }

  late final _$setDefaultLanguageAsyncAction =
      AsyncAction('_AppStore.setDefaultLanguage', context: context);

  @override
  Future<void> setDefaultLanguage(String val, {bool isInitializing = false}) {
    return _$setDefaultLanguageAsyncAction.run(
        () => super.setDefaultLanguage(val, isInitializing: isInitializing));
  }

  late final _$setDirectionAsyncAction =
      AsyncAction('_AppStore.setDirection', context: context);

  @override
  Future<void> setDirection(String val, {bool isInitializing = false}) {
    return _$setDirectionAsyncAction
        .run(() => super.setDirection(val, isInitializing: isInitializing));
  }

  late final _$setMediaPathSlugAsyncAction =
      AsyncAction('_AppStore.setMediaPathSlug', context: context);

  @override
  Future<void> setMediaPathSlug(String val, {bool isInitializing = false}) {
    return _$setMediaPathSlugAsyncAction
        .run(() => super.setMediaPathSlug(val, isInitializing: isInitializing));
  }

  late final _$setIsNotStaffAsyncAction =
      AsyncAction('_AppStore.setIsNotStaff', context: context);

  @override
  Future<void> setIsNotStaff(String val, {bool isInitializing = false}) {
    return _$setIsNotStaffAsyncAction
        .run(() => super.setIsNotStaff(val, isInitializing: isInitializing));
  }

  late final _$setHourlyRateAsyncAction =
      AsyncAction('_AppStore.setHourlyRate', context: context);

  @override
  Future<void> setHourlyRate(String val, {bool isInitializing = false}) {
    return _$setHourlyRateAsyncAction
        .run(() => super.setHourlyRate(val, isInitializing: isInitializing));
  }

  late final _$setTwoFactorAuthEnabledAsyncAction =
      AsyncAction('_AppStore.setTwoFactorAuthEnabled', context: context);

  @override
  Future<void> setTwoFactorAuthEnabled(String val,
      {bool isInitializing = false}) {
    return _$setTwoFactorAuthEnabledAsyncAction.run(() =>
        super.setTwoFactorAuthEnabled(val, isInitializing: isInitializing));
  }

  late final _$setTwoFactorAuthCodeAsyncAction =
      AsyncAction('_AppStore.setTwoFactorAuthCode', context: context);

  @override
  Future<void> setTwoFactorAuthCode(String? val,
      {bool isInitializing = false}) {
    return _$setTwoFactorAuthCodeAsyncAction.run(
        () => super.setTwoFactorAuthCode(val, isInitializing: isInitializing));
  }

  late final _$setTwoFactorAuthCodeRequestedAsyncAction =
      AsyncAction('_AppStore.setTwoFactorAuthCodeRequested', context: context);

  @override
  Future<void> setTwoFactorAuthCodeRequested(String? val,
      {bool isInitializing = false}) {
    return _$setTwoFactorAuthCodeRequestedAsyncAction.run(() => super
        .setTwoFactorAuthCodeRequested(val, isInitializing: isInitializing));
  }

  late final _$setEmailSignatureAsyncAction =
      AsyncAction('_AppStore.setEmailSignature', context: context);

  @override
  Future<void> setEmailSignature(String val, {bool isInitializing = false}) {
    return _$setEmailSignatureAsyncAction.run(
        () => super.setEmailSignature(val, isInitializing: isInitializing));
  }

  late final _$setGoogleAuthSecretAsyncAction =
      AsyncAction('_AppStore.setGoogleAuthSecret', context: context);

  @override
  Future<void> setGoogleAuthSecret(String? val, {bool isInitializing = false}) {
    return _$setGoogleAuthSecretAsyncAction.run(
        () => super.setGoogleAuthSecret(val, isInitializing: isInitializing));
  }

  late final _$setDeviceIdAsyncAction =
      AsyncAction('_AppStore.setDeviceId', context: context);

  @override
  Future<void> setDeviceId(String val, {bool isInitializing = false}) {
    return _$setDeviceIdAsyncAction
        .run(() => super.setDeviceId(val, isInitializing: isInitializing));
  }

  late final _$setIsLoginAsyncAction =
      AsyncAction('_AppStore.setIsLogin', context: context);

  @override
  Future<void> setIsLogin(String val, {bool isInitializing = false}) {
    return _$setIsLoginAsyncAction
        .run(() => super.setIsLogin(val, isInitializing: isInitializing));
  }

  late final _$setLoginIpAddressAsyncAction =
      AsyncAction('_AppStore.setLoginIpAddress', context: context);

  @override
  Future<void> setLoginIpAddress(String? val, {bool isInitializing = false}) {
    return _$setLoginIpAddressAsyncAction.run(
        () => super.setLoginIpAddress(val, isInitializing: isInitializing));
  }

  late final _$setLoginTimeAsyncAction =
      AsyncAction('_AppStore.setLoginTime', context: context);

  @override
  Future<void> setLoginTime(String val, {bool isInitializing = false}) {
    return _$setLoginTimeAsyncAction
        .run(() => super.setLoginTime(val, isInitializing: isInitializing));
  }

  late final _$setAskForExitAppAsyncAction =
      AsyncAction('_AppStore.setAskForExitApp', context: context);

  @override
  Future<void> setAskForExitApp(bool val) {
    return _$setAskForExitAppAsyncAction.run(() => super.setAskForExitApp(val));
  }

  late final _$setSessionExpiredAsyncAction =
      AsyncAction('_AppStore.setSessionExpired', context: context);

  @override
  Future<void> setSessionExpired(bool val) {
    return _$setSessionExpiredAsyncAction
        .run(() => super.setSessionExpired(val));
  }

  late final _$setTokenAsyncAction =
      AsyncAction('_AppStore.setToken', context: context);

  @override
  Future<void> setToken(String val, {bool isInitializing = false}) {
    return _$setTokenAsyncAction
        .run(() => super.setToken(val, isInitializing: isInitializing));
  }

  late final _$setUserAsyncAction =
      AsyncAction('_AppStore.setUser', context: context);

  @override
  Future<void> setUser(User? val, {bool isInitializing = false}) {
    return _$setUserAsyncAction
        .run(() => super.setUser(val, isInitializing: isInitializing));
  }

  late final _$loadUserDataAsyncAction =
      AsyncAction('_AppStore.loadUserData', context: context);

  @override
  Future<void> loadUserData() {
    return _$loadUserDataAsyncAction.run(() => super.loadUserData());
  }

  late final _$setUserDataAsyncAction =
      AsyncAction('_AppStore.setUserData', context: context);

  @override
  Future<void> setUserData(Map<String, dynamic> userData,
      {bool isInitializing = false}) {
    return _$setUserDataAsyncAction
        .run(() => super.setUserData(userData, isInitializing: isInitializing));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRememberMe(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setRememberMe');
    try {
      return super.setRememberMe(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoggedIn(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setIsLoggedIn');
    try {
      return super.setIsLoggedIn(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSessionExpired: ${isSessionExpired},
canAskForExitApp: ${canAskForExitApp},
token: ${token},
isLoggedIn: ${isLoggedIn},
staffId: ${staffId},
userEmail: ${userEmail},
firstName: ${firstName},
lastName: ${lastName},
facebook: ${facebook},
linkedin: ${linkedin},
phoneNumber: ${phoneNumber},
skype: ${skype},
password: ${password},
dateCreated: ${dateCreated},
profileImage: ${profileImage},
lastIp: ${lastIp},
lastLogin: ${lastLogin},
lastActivity: ${lastActivity},
lastPasswordChange: ${lastPasswordChange},
newPassKey: ${newPassKey},
newPassKeyRequested: ${newPassKeyRequested},
admin: ${admin},
role: ${role},
active: ${active},
defaultLanguage: ${defaultLanguage},
direction: ${direction},
mediaPathSlug: ${mediaPathSlug},
isNotStaff: ${isNotStaff},
hourlyRate: ${hourlyRate},
twoFactorAuthEnabled: ${twoFactorAuthEnabled},
twoFactorAuthCode: ${twoFactorAuthCode},
twoFactorAuthCodeRequested: ${twoFactorAuthCodeRequested},
emailSignature: ${emailSignature},
googleAuthSecret: ${googleAuthSecret},
deviceId: ${deviceId},
isLogin: ${isLogin},
loginIpAddress: ${loginIpAddress},
loginTime: ${loginTime},
loginToken: ${loginToken},
rememberMe: ${rememberMe},
isLoading: ${isLoading},
user: ${user},
fullName: ${fullName}
    ''';
  }
}
