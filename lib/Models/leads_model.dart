import 'package:crm/Models/user_data.dart';

class LeadsModel {
  List<LeadStatus> status;
  List<LeadSource> sources;
  int isLoggedIn;
  String loginToken;
  User userData;
  String title;
  List<Lead> leads;

  LeadsModel({
    required this.status,
    required this.sources,
    required this.isLoggedIn,
    required this.loginToken,
    required this.userData,
    required this.title,
    required this.leads,
  });

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    return LeadsModel(
      status: (json["status_data"] as List)
          .map((statusJson) => LeadStatus.fromJson(statusJson))
          .toList(),
      sources: (json["sources"] as List)
          .map((sourceJson) => LeadSource.fromJson(sourceJson))
          .toList(),
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
      "status_data": status.map((status) => status.toJson()).toList(),
      "sources": sources.map((source) => source.toJson()).toList(),
      'is_logged_in': isLoggedIn,
      'login_token': loginToken,
      'userData': userData.toJson(),
      'title': title,
      'leads': leads.map((lead) => lead.toJson()).toList(),
    };
  }
}

class LeadStatus {
  String id;
  String name;
  String statusOrder;
  String color;
  String isDefault;
  int total;

  LeadStatus({
    this.id = '',
    this.name = '',
    this.statusOrder = '',
    this.color = '',
    this.isDefault = '',
    this.total = 0,
  });

  factory LeadStatus.fromJson(Map<String, dynamic> json) {
    return LeadStatus(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      statusOrder: json['statusorder'] ?? "",
      color: json['color'] ?? "",
      isDefault: json['isdefault'] ?? "",
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'statusorder': statusOrder,
      'color': color,
      'isdefault': isDefault,
      'total': total,
    };
  }
}

class LeadSource {
  String id;
  String name;

  LeadSource({
    required this.id,
    required this.name,
  });

  factory LeadSource.fromJson(Map<String, dynamic> json) {
    return LeadSource(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

///----Staff-Member------
class Lead {
  String id;
  String? hash;
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
  String? lastStatusChange;
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
  List<Tag>? tags;
  List<NoteData>? notesData;
  List<Reminder>? reminders;

  Lead({
    required this.id,
    this.hash,
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
    this.lastStatusChange,
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
    this.tags,
    this.notesData,
    this.reminders,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] ?? '',
      hash: json['hash'] ?? "",
      name: json['name'] ?? '',
      title: json['title'] ?? "",
      company: json['company'] ?? "",
      description: json['description'] ?? "",
      country: json['country'] ?? '0',
      zip: json['zip'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      address: json['address'] ?? "",
      assigned: json['assigned'] ?? '',
      dateadded: json['dateadded'] ?? '',
      fromFormId: json['from_form_id'] ?? '',
      status: json['status'] ?? '',
      source: json['source'] ?? '',
      lastcontact: json['lastcontact'] ?? "",
      dateassigned: json['dateassigned'] ?? "",
      lastStatusChange: json['last_status_change'],
      addedfrom: json['addedfrom'] ?? '',
      email: json['email'] ?? "",
      website: json['website'] ?? "",
      leadorder: json['leadorder'] ?? '',
      phonenumber: json['phonenumber'] ?? "",
      dateConverted: json['date_converted'],
      lost: json['lost'] ?? '',
      junk: json['junk'] ?? '',
      lastLeadStatus: json['last_lead_status'] ?? '',
      isImportedFromEmailIntegration:
          json['is_imported_from_email_integration'] ?? '',
      emailIntegrationUid: json['email_integration_uid'],
      isPublic: json['is_public'] ?? '',
      defaultLanguage: json['default_language'],
      clientId: json['client_id'] ?? '',
      leadValue: json['lead_value'],
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e))
          .toList(),
      notesData: (json['notes_data'] as List<dynamic>?)
          ?.map((e) => NoteData.fromJson(e))
          .toList(),
      reminders: (json['reminders'] as List<dynamic>?)
          ?.map((e) => Reminder.fromJson(e))
          .toList(),
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
      'tags': tags?.map((e) => e.toJson()).toList(),
      'notes_data': notesData?.map((e) => e.toJson()).toList(),
      'reminders': reminders?.map((e) => e.toJson()).toList(),
    };
  }
}

///----Note-Data------
class NoteData {
  String description;
  String? dateContacted;
  String addedfrom;
  String firstname;
  String lastname;
  String profileImage;
  String dateadded;
  String thumbImage;
  String smallImage;
  int? editDelete;
  String id;

  NoteData({
    required this.description,
    this.dateContacted,
    required this.addedfrom,
    required this.firstname,
    required this.lastname,
    required this.profileImage,
    required this.dateadded,
    required this.thumbImage,
    required this.smallImage,
    this.editDelete,
    required this.id,
  });

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
      description: json['description'] ?? '',
      dateContacted: json['date_contacted'],
      addedfrom: json['addedfrom'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      profileImage: json['profile_image'] ?? '',
      dateadded: json['dateadded'] ?? '',
      thumbImage: json['thumb_image'] ?? '',
      smallImage: json['small_image'] ?? '',
      editDelete: json['can_edit_delete'] ?? 0,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'date_contacted': dateContacted,
      'addedfrom': addedfrom,
      'firstname': firstname,
      'lastname': lastname,
      'profile_image': profileImage,
      'dateadded': dateadded,
      'thumb_image': thumbImage,
      'small_image': smallImage,
      'can_edit_delete': editDelete,
      'id': id,
    };
  }
}

///----Reminder------
class Reminder {
  String id;
  String description;
  String date;
  String isnotified;
  String staffid;
  String firstname;
  String lastname;
  String profileImage;
  String thumbImage;
  String smallImage;
  String creator;
  int canEdit;
  int canDelete;

  Reminder({
    required this.id,
    required this.description,
    required this.date,
    required this.isnotified,
    required this.staffid,
    required this.firstname,
    required this.lastname,
    required this.profileImage,
    required this.thumbImage,
    required this.smallImage,
    required this.creator,
    required this.canEdit,
    required this.canDelete,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      isnotified: json['isnotified'] ?? '',
      staffid: json['staffid'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      profileImage: json['profile_image'] ?? '',
      thumbImage: json['thumb_image'] ?? '',
      smallImage: json['small_image'] ?? '',
      creator: json['creator'] ?? '',
      canEdit: json['can_edit'] ?? 0,
      canDelete: json['can_delete'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'date': date,
      'isnotified': isnotified,
      'staffid': staffid,
      'firstname': firstname,
      'lastname': lastname,
      'profile_image': profileImage,
      'thumb_image': thumbImage,
      'small_image': smallImage,
      'creator': creator,
      'can_edit': canEdit,
      'can_delete': canDelete,
    };
  }
}

///----Staff-Member------
class Staff {
  final String staffId;
  final String firstName;
  final String lastName;

  Staff({this.staffId = '', this.firstName = '', this.lastName = ''});

  // Factory constructor for creating a new instance from a JSON map
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      staffId: json['staffid'] ?? "",
      firstName: json['firstname'] ?? "",
      lastName: json['lastname'] ?? "",
    );
  }

  // Method for converting the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'staffid': staffId,
      'firstname': firstName,
      'lastname': lastName,
    };
  }
}

///----Tags ----
class Tag {
  final String id;
  final String name;

  Tag({required this.id, required this.name});

  // Factory constructor for creating a new instance from a JSON map
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'].toString(),
      name: json['name'],
    );
  }

  // Method for converting the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
    };
  }
}

class Country {
  final String countryId;
  final String shortName;
  final String longName;
  final String callingCode;

  Country({
    required this.countryId,
    required this.shortName,
    required this.longName,
    required this.callingCode,
  });

  /// Factory method to create a `Country` object from a JSON map
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryId: json['country_id'] as String? ?? '',
      shortName: json['short_name'] as String? ?? '',
      longName: json['long_name'] as String? ?? '',
      callingCode: json['calling_code'] as String? ?? '',
    );
  }

  /// Method to convert a `Country` object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'country_id': countryId,
      'short_name': shortName,
      'long_name': longName,
      'calling_code': callingCode,
    };
  }
}

class StateModel {
  String? id;
  String? name;
  String? countryId;

  StateModel({this.id, this.name, this.countryId});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    return data;
  }
}

class LeadSummary {
  String id;
  String name;
  String statusOrder;
  String color;
  String isDefault;
  int total;

  LeadSummary({
    required this.id,
    required this.name,
    required this.statusOrder,
    required this.color,
    required this.isDefault,
    required this.total,
  });

  // Factory method to create a StatusData instance from JSON
  factory LeadSummary.fromJson(Map<String, dynamic> json) {
    return LeadSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      statusOrder: json['statusorder'] ?? '',
      color: json['color'] ?? '',
      isDefault: json['isdefault'] ?? '',
      total: json['total'] ?? 0,
    );
  }

  // Method to convert a StatusData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'statusorder': statusOrder,
      'color': color,
      'isdefault': isDefault,
      'total': total,
    };
  }
}
