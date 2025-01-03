import 'package:crm/Models/user_data.dart';

class LeadsModel {
  bool status;
  int isLoggedIn;
  String loginToken;
  User userData;
  String title;
  List<Lead> leads;

  LeadsModel({
    required this.status,
    required this.isLoggedIn,
    required this.loginToken,
    required this.userData,
    required this.title,
    required this.leads,
  });

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    return LeadsModel(
      status: json['status'],
      isLoggedIn: json['is_logged_in'],
      loginToken: json['login_token'],
      userData: User.fromJson(json['userData']),
      title: json['title'],
      leads: (json['leads'] as List)
          .map((leadJson) => Lead.fromJson(leadJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_logged_in': isLoggedIn,
      'login_token': loginToken,
      'userData': userData.toJson(),
      'title': title,
      'leads': leads.map((lead) => lead.toJson()).toList(),
    };
  }
}

class Lead {
  String id;
  String hash;
  String name;
  String? title;
  String? company;
  String? description;
  String country;
  String? zip;
  String? city;
  String? state;
  String? address;
  String assigned;
  String dateadded;
  String fromFormId;
  String status;
  String source;
  String? lastcontact;
  String? dateassigned;
  String lastStatusChange;
  String addedfrom;
  String? email;
  String? website;
  String leadorder;
  String? phonenumber;
  String? dateConverted;
  String lost;
  String junk;
  String lastLeadStatus;
  String isImportedFromEmailIntegration;
  String? emailIntegrationUid;
  String isPublic;
  String? defaultLanguage;
  String clientId;
  String? leadValue;

  Lead({
    required this.id,
    required this.hash,
    required this.name,
    this.title,
    this.company,
    this.description,
    required this.country,
    this.zip,
    this.city,
    this.state,
    this.address,
    required this.assigned,
    required this.dateadded,
    required this.fromFormId,
    required this.status,
    required this.source,
    this.lastcontact,
    this.dateassigned,
    required this.lastStatusChange,
    required this.addedfrom,
    this.email,
    this.website,
    required this.leadorder,
    this.phonenumber,
    this.dateConverted,
    required this.lost,
    required this.junk,
    required this.lastLeadStatus,
    required this.isImportedFromEmailIntegration,
    this.emailIntegrationUid,
    required this.isPublic,
    this.defaultLanguage,
    required this.clientId,
    this.leadValue,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] ?? '',
      hash: json['hash'] ?? '',
      name: json['name'] ?? '',
      title: json['title'],
      company: json['company'],
      description: json['description'],
      country: json['country'] ?? '',
      zip: json['zip'],
      city: json['city'],
      state: json['state'],
      address: json['address'],
      assigned: json['assigned'] ?? '',
      dateadded: json['dateadded'] ?? '',
      fromFormId: json['from_form_id'] ?? '',
      status: json['status'] ?? '',
      source: json['source'] ?? '',
      lastcontact: json['lastcontact'],
      dateassigned: json['dateassigned'],
      lastStatusChange: json['last_status_change'] ?? '',
      addedfrom: json['addedfrom'] ?? '',
      email: json['email'],
      website: json['website'],
      leadorder: json['leadorder'] ?? '',
      phonenumber: json['phonenumber'],
      dateConverted: json['date_converted'],
      lost: json['lost'] ?? '',
      junk: json['junk'] ?? '',
      lastLeadStatus: json['last_lead_status'] ?? '',
      isImportedFromEmailIntegration: json['is_imported_from_email_integration'] ?? '',
      emailIntegrationUid: json['email_integration_uid'],
      isPublic: json['is_public'] ?? '',
      defaultLanguage: json['default_language'],
      clientId: json['client_id'] ?? '',
      leadValue: json['lead_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hash': hash,
      'name': name,
      'title': title,
      'company': company,
      'description': description,
      'country': country,
      'zip': zip,
      'city': city,
      'state': state,
      'address': address,
      'assigned': assigned,
      'dateadded': dateadded,
      'from_form_id': fromFormId,
      'status': status,
      'source': source,
      'lastcontact': lastcontact,
      'dateassigned': dateassigned,
      'last_status_change': lastStatusChange,
      'addedfrom': addedfrom,
      'email': email,
      'website': website,
      'leadorder': leadorder,
      'phonenumber': phonenumber,
      'date_converted': dateConverted,
      'lost': lost,
      'junk': junk,
      'last_lead_status': lastLeadStatus,
      'is_imported_from_email_integration': isImportedFromEmailIntegration,
      'email_integration_uid': emailIntegrationUid,
      'is_public': isPublic,
      'default_language': defaultLanguage,
      'client_id': clientId,
      'lead_value': leadValue,
    };
  }
}

