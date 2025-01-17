class Dashboard {
  bool status;
  int isLoggedIn;
  String loginToken;
  UserData userData;
  String title;
  List<LeadStatus> leadStatus;
  FirstBox firstBox;
  SecondBox secondBox;
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

  Dashboard copyWith({
    bool? status,
    int? isLoggedIn,
    String? loginToken,
    UserData? userData,
    String? title,
    List<LeadStatus>? leadStatus,
    FirstBox? firstBox,
    SecondBox? secondBox,
    ThirdBox? thirdBox,
    FourthBox? fourthBox,
  }) =>
      Dashboard(
        status: status ?? this.status,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        loginToken: loginToken ?? this.loginToken,
        userData: userData ?? this.userData,
        title: title ?? this.title,
        leadStatus: leadStatus ?? this.leadStatus,
        firstBox: firstBox ?? this.firstBox,
        secondBox: secondBox ?? this.secondBox,
        thirdBox: thirdBox ?? this.thirdBox,
        fourthBox: fourthBox ?? this.fourthBox,
      );
}

class FirstBox {
  int totalLeads;

  FirstBox({
    required this.totalLeads,
  });

  FirstBox copyWith({
    int? totalLeads,
  }) =>
      FirstBox(
        totalLeads: totalLeads ?? this.totalLeads,
      );
}

class FourthBox {
  int totalContactLeads;

  FourthBox({
    required this.totalContactLeads,
  });

  FourthBox copyWith({
    int? totalContactLeads,
  }) =>
      FourthBox(
        totalContactLeads: totalContactLeads ?? this.totalContactLeads,
      );
}

class LeadStatus {
  String id;
  String name;
  String statusorder;
  Color color;
  String isdefault;
  int total;

  LeadStatus({
    required this.id,
    required this.name,
    required this.statusorder,
    required this.color,
    required this.isdefault,
    required this.total,
  });

  LeadStatus copyWith({
    String? id,
    String? name,
    String? statusorder,
    Color? color,
    String? isdefault,
    int? total,
  }) =>
      LeadStatus(
        id: id ?? this.id,
        name: name ?? this.name,
        statusorder: statusorder ?? this.statusorder,
        color: color ?? this.color,
        isdefault: isdefault ?? this.isdefault,
        total: total ?? this.total,
      );
}

enum Color { THE_28_B8_DA, THE_757575, THE_7_CB342 }

class SecondBox {
  int totalCLeads;
  int totalConverted;

  SecondBox({
    required this.totalCLeads,
    required this.totalConverted,
  });

  SecondBox copyWith({
    int? totalCLeads,
    int? totalConverted,
  }) =>
      SecondBox(
        totalCLeads: totalCLeads ?? this.totalCLeads,
        totalConverted: totalConverted ?? this.totalConverted,
      );
}

class ThirdBox {
  int totalNewLeads;

  ThirdBox({
    required this.totalNewLeads,
  });

  ThirdBox copyWith({
    int? totalNewLeads,
  }) =>
      ThirdBox(
        totalNewLeads: totalNewLeads ?? this.totalNewLeads,
      );
}

class UserData {
  String staffid;
  String email;
  String firstname;
  String lastname;
  String facebook;
  String linkedin;
  String phonenumber;
  String skype;
  String password;
  DateTime datecreated;
  dynamic profileImage;
  String lastIp;
  DateTime lastLogin;
  DateTime lastActivity;
  dynamic lastPasswordChange;
  dynamic newPassKey;
  dynamic newPassKeyRequested;
  String admin;
  String role;
  String active;
  String defaultLanguage;
  String direction;
  String mediaPathSlug;
  String isNotStaff;
  String hourlyRate;
  String twoFactorAuthEnabled;
  dynamic twoFactorAuthCode;
  dynamic twoFactorAuthCodeRequested;
  String emailSignature;
  dynamic googleAuthSecret;
  String deviceId;
  String isLogin;
  String loginIpAddress;
  DateTime loginTime;
  String loginToken;

  UserData({
    required this.staffid,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.facebook,
    required this.linkedin,
    required this.phonenumber,
    required this.skype,
    required this.password,
    required this.datecreated,
    required this.profileImage,
    required this.lastIp,
    required this.lastLogin,
    required this.lastActivity,
    required this.lastPasswordChange,
    required this.newPassKey,
    required this.newPassKeyRequested,
    required this.admin,
    required this.role,
    required this.active,
    required this.defaultLanguage,
    required this.direction,
    required this.mediaPathSlug,
    required this.isNotStaff,
    required this.hourlyRate,
    required this.twoFactorAuthEnabled,
    required this.twoFactorAuthCode,
    required this.twoFactorAuthCodeRequested,
    required this.emailSignature,
    required this.googleAuthSecret,
    required this.deviceId,
    required this.isLogin,
    required this.loginIpAddress,
    required this.loginTime,
    required this.loginToken,
  });

  UserData copyWith({
    String? staffid,
    String? email,
    String? firstname,
    String? lastname,
    String? facebook,
    String? linkedin,
    String? phonenumber,
    String? skype,
    String? password,
    DateTime? datecreated,
    dynamic profileImage,
    String? lastIp,
    DateTime? lastLogin,
    DateTime? lastActivity,
    dynamic lastPasswordChange,
    dynamic newPassKey,
    dynamic newPassKeyRequested,
    String? admin,
    String? role,
    String? active,
    String? defaultLanguage,
    String? direction,
    String? mediaPathSlug,
    String? isNotStaff,
    String? hourlyRate,
    String? twoFactorAuthEnabled,
    dynamic twoFactorAuthCode,
    dynamic twoFactorAuthCodeRequested,
    String? emailSignature,
    dynamic googleAuthSecret,
    String? deviceId,
    String? isLogin,
    String? loginIpAddress,
    DateTime? loginTime,
    String? loginToken,
  }) =>
      UserData(
        staffid: staffid ?? this.staffid,
        email: email ?? this.email,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        facebook: facebook ?? this.facebook,
        linkedin: linkedin ?? this.linkedin,
        phonenumber: phonenumber ?? this.phonenumber,
        skype: skype ?? this.skype,
        password: password ?? this.password,
        datecreated: datecreated ?? this.datecreated,
        profileImage: profileImage ?? this.profileImage,
        lastIp: lastIp ?? this.lastIp,
        lastLogin: lastLogin ?? this.lastLogin,
        lastActivity: lastActivity ?? this.lastActivity,
        lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
        newPassKey: newPassKey ?? this.newPassKey,
        newPassKeyRequested: newPassKeyRequested ?? this.newPassKeyRequested,
        admin: admin ?? this.admin,
        role: role ?? this.role,
        active: active ?? this.active,
        defaultLanguage: defaultLanguage ?? this.defaultLanguage,
        direction: direction ?? this.direction,
        mediaPathSlug: mediaPathSlug ?? this.mediaPathSlug,
        isNotStaff: isNotStaff ?? this.isNotStaff,
        hourlyRate: hourlyRate ?? this.hourlyRate,
        twoFactorAuthEnabled: twoFactorAuthEnabled ?? this.twoFactorAuthEnabled,
        twoFactorAuthCode: twoFactorAuthCode ?? this.twoFactorAuthCode,
        twoFactorAuthCodeRequested:
            twoFactorAuthCodeRequested ?? this.twoFactorAuthCodeRequested,
        emailSignature: emailSignature ?? this.emailSignature,
        googleAuthSecret: googleAuthSecret ?? this.googleAuthSecret,
        deviceId: deviceId ?? this.deviceId,
        isLogin: isLogin ?? this.isLogin,
        loginIpAddress: loginIpAddress ?? this.loginIpAddress,
        loginTime: loginTime ?? this.loginTime,
        loginToken: loginToken ?? this.loginToken,
      );
}
