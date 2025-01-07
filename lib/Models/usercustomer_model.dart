class UserCustomer {
  final bool status;
  final int isLoggedIn;
  final String loginToken;
  final String title;
  late final List<Customer> customers;
  final int page;

  UserCustomer({
    required this.status,
    required this.isLoggedIn,
    required this.loginToken,
    required this.title,
    required this.customers,
    required this.page,
  });

  factory UserCustomer.fromJson(Map<String, dynamic> json) {
    return UserCustomer(
      status: json['status'],
      isLoggedIn: json['is_logged_in'],
      loginToken: json['login_token'],
      title: json['title'],
      customers: (json['customers'] as List)
          .map((customer) => Customer.fromJson(customer))
          .toList(),
      page: json['page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_logged_in': isLoggedIn,
      'login_token': loginToken,
      'title': title,
      'customers': customers.map((customer) => customer.toJson()).toList(),
      'page': page,
    };
  }
}

class Customer {
  final String userId;
  final String company;
  final String? vat; // Nullable field
  final String phoneNumber;
  final String country;
  final String city;
  final String zip;
  final String state;
  final String address;
  final String website;
  final String dateCreated;
  final String active;
  final String? leadId; // Nullable field

  Customer({
    required this.userId,
    required this.company,
    this.vat,
    required this.phoneNumber,
    required this.country,
    required this.city,
    required this.zip,
    required this.state,
    required this.address,
    required this.website,
    required this.dateCreated,
    required this.active,
    this.leadId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      userId: json['userid'] ?? '', // Handle potential null value
      company: json['company'] ?? '', // Handle potential null value
      vat: json['vat'], // Nullable, no need for default value
      phoneNumber: json['phonenumber'] ?? '', // Handle potential null value
      country: json['country'] ?? '', // Handle potential null value
      city: json['city'] ?? '', // Handle potential null value
      zip: json['zip'] ?? '', // Handle potential null value
      state: json['state'] ?? '', // Handle potential null value
      address: json['address'] ?? '', // Handle potential null value
      website: json['website'] ?? '', // Handle potential null value
      dateCreated: json['datecreated'] ?? '', // Handle potential null value
      active: json['active'] ?? '', // Handle potential null value
      leadId: json['leadid'], // Nullable, no need for default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'company': company,
      'vat': vat,
      'phonenumber': phoneNumber,
      'country': country,
      'city': city,
      'zip': zip,
      'state': state,
      'address': address,
      'website': website,
      'datecreated': dateCreated,
      'active': active,
      'leadid': leadId,
    };
  }
}
