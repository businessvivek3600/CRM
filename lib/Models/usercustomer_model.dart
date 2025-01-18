class UserCustomer {
  final bool status;
  final int isLoggedIn;
  final String loginToken;
  final String title;
  late final List<Customer> customers;
  final int page;
  final int totalCustomer;
  final int activeCustomer;
  final int inactiveCustomer;

  UserCustomer({
    required this.status,
    required this.isLoggedIn,
    required this.loginToken,
    required this.title,
    required this.customers,
    required this.page,
    required this.totalCustomer,
    required this.activeCustomer,
    required this.inactiveCustomer,
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
      totalCustomer: int.parse(json['total_customer'] ?? '0'),
      activeCustomer: int.parse(json['active_customer'] ?? '0'),
      inactiveCustomer: int.parse(json['inactive_customer'] ?? '0'),
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
      'total_customer': totalCustomer,
      'active_customer': activeCustomer,
      'inactive_customer': inactiveCustomer,
    };
  }
}

class Customer {
  final String userId;
  final String company;
  final String? vat;
  final String phoneNumber;
  final String country;
  final String city;
  final String zip;
  final String state;
  final String address;
  final String website;
  final String dateCreated;
  final String active;
  final String? leadId;
  final String? billingStreet;
  final String? billingCity;
  final String? billingState;
  final String? billingZip;
  final String? billingCountry;
  final String? shippingStreet;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingZip;
  final String? shippingCountry;

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
    this.billingStreet,
    this.billingCity,
    this.billingState,
    this.billingZip,
    this.billingCountry,
    this.shippingStreet,
    this.shippingCity,
    this.shippingState,
    this.shippingZip,
    this.shippingCountry,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      userId: json['userid'] ?? '',
      company: json['company'] ?? '',
      vat: json['vat'],
      phoneNumber: json['phonenumber'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      zip: json['zip'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      website: json['website'] ?? '',
      dateCreated: json['datecreated'] ?? '',
      active: json['active'] ?? '',
      leadId: json['leadid'],
      billingStreet: json['billing_street'],
      billingCity: json['billing_city'],
      billingState: json['billing_state'],
      billingZip: json['billing_zip'],
      billingCountry: json['billing_country'],
      shippingStreet: json['shipping_street'],
      shippingCity: json['shipping_city'],
      shippingState: json['shipping_state'],
      shippingZip: json['shipping_zip'],
      shippingCountry: json['shipping_country'],
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
      'billing_street': billingStreet,
      'billing_city': billingCity,
      'billing_state': billingState,
      'billing_zip': billingZip,
      'billing_country': billingCountry,
      'shipping_street': shippingStreet,
      'shipping_city': shippingCity,
      'shipping_state': shippingState,
      'shipping_zip': shippingZip,
      'shipping_country': shippingCountry,
    };
  }

  // Add the copyWith method
  Customer copyWith({
    String? userId,
    String? company,
    String? vat,
    String? phoneNumber,
    String? country,
    String? city,
    String? zip,
    String? state,
    String? address,
    String? website,
    String? dateCreated,
    String? active,
    String? leadId,
    String? billingStreet,
    String? billingCity,
    String? billingState,
    String? billingZip,
    String? billingCountry,
    String? shippingStreet,
    String? shippingCity,
    String? shippingState,
    String? shippingZip,
    String? shippingCountry,
  }) {
    return Customer(
      userId: userId ?? this.userId,
      company: company ?? this.company,
      vat: vat ?? this.vat,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      state: state ?? this.state,
      address: address ?? this.address,
      website: website ?? this.website,
      dateCreated: dateCreated ?? this.dateCreated,
      active: active ?? this.active,
      leadId: leadId ?? this.leadId,
      billingStreet: billingStreet ?? this.billingStreet,
      billingCity: billingCity ?? this.billingCity,
      billingState: billingState ?? this.billingState,
      billingZip: billingZip ?? this.billingZip,
      billingCountry: billingCountry ?? this.billingCountry,
      shippingStreet: shippingStreet ?? this.shippingStreet,
      shippingCity: shippingCity ?? this.shippingCity,
      shippingState: shippingState ?? this.shippingState,
      shippingZip: shippingZip ?? this.shippingZip,
      shippingCountry: shippingCountry ?? this.shippingCountry,
    );
  }
}

class CustomerCounts {
  final String totalCustomer;
  final String activeCustomer;
  final String inactiveCustomer;

  CustomerCounts({
    required this.totalCustomer,
    required this.activeCustomer,
    required this.inactiveCustomer,
  });

  // Factory method to create a CustomerCounts from JSON
  factory CustomerCounts.fromJson(Map<String, dynamic> json) {
    return CustomerCounts(
      totalCustomer: json['total_customer'] as String,
      activeCustomer: json['active_customer'] as String,
      inactiveCustomer: json['inactive_customer'] as String,
    );
  }

  // Method to convert CustomerCounts to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_customer': totalCustomer,
      'active_customer': activeCustomer,
      'inactive_customer': inactiveCustomer,
    };
  }
}
