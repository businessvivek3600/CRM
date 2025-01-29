import 'package:crm/Models/user_data.dart';

import 'leads_model.dart';

class Dashboard {
  bool status;
  int isLoggedIn;
  String loginToken;
  FirstBox firstBox;
  SecondBox secondBox;
  User userData;
  String title;
  List<LeadStatus> leadStatus;
  ThirdBox thirdBox;
  FourthBox fourthBox;

  Dashboard({
    required this.status,
    required this.isLoggedIn,
    required this.loginToken,
    required this.userData,
    required this.title,
    required this.leadStatus,
    required this.firstBox,
    required this.secondBox,
    required this.thirdBox,
    required this.fourthBox,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      status: json['status'],
      isLoggedIn: json['is_logged_in'],
      loginToken: json['login_token'],
      userData: User.fromJson(json['userData']),
      title: json['title'],
      leadStatus:
          json['leadStatus'].map((e) => LeadStatus.fromJson(e)).toList(),
      firstBox: FirstBox.fromJson(json['first_box']),
      secondBox: SecondBox.fromJson(json['second_box']),
      thirdBox: ThirdBox.fromJson(json['third_box']),
      fourthBox: FourthBox.fromJson(json['fourth_box']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_logged_in': isLoggedIn,
      'login_token': loginToken,
      'title': title,
      'userData': userData,
      'leadStatus': leadStatus,
      'first_box': firstBox.toJson(),
      'second_box': secondBox.toJson(),
      'third_box': thirdBox.toJson(),
      'fourth_box': fourthBox.toJson(),
    };
  }
}

class FirstBox {
  int totalLeads;

  FirstBox({required this.totalLeads});

  factory FirstBox.fromJson(Map<String, dynamic> json) {
    return FirstBox(totalLeads: json['total_leads']);
  }

  Map<String, dynamic> toJson() {
    return {'total_leads': totalLeads};
  }
}

class SecondBox {
  int totalCLeads;
  int totalConverted;

  SecondBox({
    required this.totalCLeads,
    required this.totalConverted,
  });

  factory SecondBox.fromJson(Map<String, dynamic> json) {
    return SecondBox(
      totalCLeads: json['total_c_leads'],
      totalConverted: json['total_converted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_c_leads': totalCLeads,
      'total_converted': totalConverted,
    };
  }
}

class ThirdBox {
  int totalNewLeads;

  ThirdBox({required this.totalNewLeads});

  factory ThirdBox.fromJson(Map<String, dynamic> json) {
    return ThirdBox(totalNewLeads: json['total_new_leads']);
  }

  Map<String, dynamic> toJson() {
    return {'total_new_leads': totalNewLeads};
  }
}

class FourthBox {
  int totalContactLeads;

  FourthBox({required this.totalContactLeads});

  factory FourthBox.fromJson(Map<String, dynamic> json) {
    return FourthBox(totalContactLeads: json['total_contact_leads']);
  }

  Map<String, dynamic> toJson() {
    return {'total_contact_leads': totalContactLeads};
  }
}

enum Color { THE_28_B8_DA, THE_757575, THE_7_CB342 }
