import 'user_data.dart';

class LoginResponse {
  bool? status;
  int? isLoggedIn;
  String? loginToken;
  User? userData;
  String? message;

  LoginResponse({
    this.status,
    this.isLoggedIn,
    this.loginToken,
    this.userData,
    this.message,
  });

  // Factory constructor for creating an instance from a JSON map
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      isLoggedIn: json['is_logged_in'],
      loginToken: json['login_token'],
      userData: json['userData'] != null ? User.fromJson(json['userData']) : null,
      message: json['message'],
    );
  }

  // Method to convert an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_logged_in': isLoggedIn,
      'login_token': loginToken,
      'userData': userData?.toJson(),
      'message': message,
    };
  }
}


