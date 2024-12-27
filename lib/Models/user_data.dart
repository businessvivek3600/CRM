import '../utils/default_logger.dart';

class User {
  String? staffId;
  String? email;
  String? firstName;
  String? lastName;
  String? facebook;
  String? linkedin;
  String? phoneNumber;
  String? skype;
  String? password;
  String? dateCreated;
  String? profileImage;
  String? lastIp;
  String? lastLogin;
  String? lastActivity;
  String? lastPasswordChange;
  String? newPassKey;
  String? newPassKeyRequested;
  String? admin;
  String? role;
  String? active;
  String? defaultLanguage;
  String? direction;
  String? mediaPathSlug;
  String? isNotStaff;
  String? hourlyRate;
  String? twoFactorAuthEnabled;
  String? twoFactorAuthCode;
  String? twoFactorAuthCodeRequested;
  String? emailSignature;
  String? googleAuthSecret;
  String? deviceId;
  String? isLogin;
  String? loginIpAddress;
  String? loginTime;
  String? loginToken;

  User({
    this.staffId,
    this.email,
    this.firstName,
    this.lastName,
    this.facebook,
    this.linkedin,
    this.phoneNumber,
    this.skype,
    this.password,
    this.dateCreated,
    this.profileImage,
    this.lastIp,
    this.lastLogin,
    this.lastActivity,
    this.lastPasswordChange,
    this.newPassKey,
    this.newPassKeyRequested,
    this.admin,
    this.role,
    this.active,
    this.defaultLanguage,
    this.direction,
    this.mediaPathSlug,
    this.isNotStaff,
    this.hourlyRate,
    this.twoFactorAuthEnabled,
    this.twoFactorAuthCode,
    this.twoFactorAuthCodeRequested,
    this.emailSignature,
    this.googleAuthSecret,
    this.deviceId,
    this.isLogin,
    this.loginIpAddress,
    this.loginTime,
    this.loginToken,
  });

  // Factory constructor for creating an instance from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      staffId: json['staffid'],
      email: json['email'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      facebook: json['facebook'],
      linkedin: json['linkedin'],
      phoneNumber: json['phonenumber'],
      skype: json['skype'],
      password: json['password'],
      dateCreated: json['datecreated'],
      profileImage: json['profile_image'],
      lastIp: json['last_ip'],
      lastLogin: json['last_login'],
      lastActivity: json['last_activity'],
      lastPasswordChange: json['last_password_change'],
      newPassKey: json['new_pass_key'],
      newPassKeyRequested: json['new_pass_key_requested'],
      admin: json['admin'],
      role: json['role'],
      active: json['active'],
      defaultLanguage: json['default_language'],
      direction: json['direction'],
      mediaPathSlug: json['media_path_slug'],
      isNotStaff: json['is_not_staff'],
      hourlyRate: json['hourly_rate'],
      twoFactorAuthEnabled: json['two_factor_auth_enabled'],
      twoFactorAuthCode: json['two_factor_auth_code'],
      twoFactorAuthCodeRequested: json['two_factor_auth_code_requested'],
      emailSignature: json['email_signature'],
      googleAuthSecret: json['google_auth_secret'],
      deviceId: json['device_id'],
      isLogin: json['is_login'],
      loginIpAddress: json['login_ip_address'],
      loginTime: json['login_time'],
      loginToken: json['login_token'],
    );
  }

  // Method to convert an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'staffid': staffId,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
      'facebook': facebook,
      'linkedin': linkedin,
      'phonenumber': phoneNumber,
      'skype': skype,
      'password': password,
      'datecreated': dateCreated,
      'profile_image': profileImage,
      'last_ip': lastIp,
      'last_login': lastLogin,
      'last_activity': lastActivity,
      'last_password_change': lastPasswordChange,
      'new_pass_key': newPassKey,
      'new_pass_key_requested': newPassKeyRequested,
      'admin': admin,
      'role': role,
      'active': active,
      'default_language': defaultLanguage,
      'direction': direction,
      'media_path_slug': mediaPathSlug,
      'is_not_staff': isNotStaff,
      'hourly_rate': hourlyRate,
      'two_factor_auth_enabled': twoFactorAuthEnabled,
      'two_factor_auth_code': twoFactorAuthCode,
      'two_factor_auth_code_requested': twoFactorAuthCodeRequested,
      'email_signature': emailSignature,
      'google_auth_secret': googleAuthSecret,
      'device_id': deviceId,
      'is_login': isLogin,
      'login_ip_address': loginIpAddress,
      'login_time': loginTime,
      'login_token': loginToken,
    };
  }
}
User? userFromJson(Map<String, dynamic> json) =>
    tryCatch(() => User.fromJson(json));
