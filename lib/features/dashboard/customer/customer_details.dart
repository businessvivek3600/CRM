import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:crm/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../widgets/custom_dropdown.dart';
import 'customer_screen.dart';

class CustomerDetails extends StatefulWidget {
  final String customer;

  const CustomerDetails({super.key, required this.customer});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  bool _isEditMode = false;
  bool isLoading = false;
  Customer? _editableCustomer;
  Customer? _initialCustomer;

  @override
  void initState() {
    super.initState();

    _fetchCustomerDetails();
  }

  Future<void> _fetchCustomerDetails() async {
    setState(() {
      isLoading = true;
    });

    var (bool status, Map<String, dynamic> data, String? message) =
        await ApiService.getCustomerDetails({'clientId': widget.customer});

    if (status &&
        data.containsKey('customers') &&
        (data['customers'] as List).isNotEmpty) {
      setState(() {
        _editableCustomer = Customer.fromJson(data['customers'][0]);
        _initialCustomer = Customer.fromJson(data['customers'][0]);
      });
    } else {
      toast(message ?? 'Failed to load customer details',
          gravity: ToastGravity.TOP, bgColor: Colors.red);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(
            _initialCustomer?.company ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            if (!_isEditMode)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isEditMode = true;
                  });
                },
              ),
            if (_isEditMode) ...[
              TextButton(
                onPressed: () {
                  setState(() {
                    _editableCustomer = _initialCustomer;
                    _isEditMode = false;
                  });
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await _saveCustomerData();

                  if (!mounted) return;

                  setState(() {
                    _isEditMode = false;
                  });
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ]
          ],
          centerTitle: false,
          leading: const BackButton(color: Colors.black),
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: isLoading
              ? _buildShimmerEffect()
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: CRMColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: CRMColors.border),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: CRMColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: CRMColors.textSecondary,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: "Profile"),
                          Tab(text: "Addresses"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildProfileTab(),
                          _buildBillingShippingTab(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String? getCountryId(String name) {
    try {
      return leadStore.country
          .firstWhere((country) => country.shortName == name)
          .countryId;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveCustomerData() async {
    final FormData formData = FormData.fromMap({
      "id": _initialCustomer!.userId.toString(),
      'active': _initialCustomer!.active.toString(),
      'company': _editableCustomer!.company,
      'vat': _editableCustomer!.vat,
      'phonenumber': _editableCustomer!.phoneNumber,
      'country': _editableCustomer!.country,
      'city': _editableCustomer!.city,
      'zip': _editableCustomer!.zip,
      'state': _editableCustomer!.state,
      'address': _editableCustomer!.address,
      'website': _editableCustomer!.website,
      'billing_street': _editableCustomer!.billingStreet,
      'billing_city': _editableCustomer!.billingCity,
      'billing_state': _editableCustomer!.billingState,
      'billing_zip': _editableCustomer!.billingZip,
      'billing_country': _editableCustomer!.billingCountry,
      'shipping_street': _editableCustomer!.shippingStreet,
      'shipping_city': _editableCustomer!.shippingCity,
      'shipping_state': _editableCustomer!.shippingState,
      'shipping_zip': _editableCustomer!.shippingZip,
      'shipping_country': _editableCustomer!.shippingCountry,
    });
    warningLog("Editable customer Data: $formData");
    var (bool status, Map<String, dynamic> data, String? message) =
        await ApiService.editCustomer(formData);
    if (status) {

      toast(message ?? "Customer updated");

      setState(() {
        _initialCustomer = _editableCustomer;
      });

    } else {

      toast(message ?? "Update failed",
          bgColor: Colors.red,
          gravity: ToastGravity.TOP);

    }
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildShimmerCard(),
          const SizedBox(height: 16),
          _buildShimmerCard(),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            height20(),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableRow(
                      'Company', "", _editableCustomer?.company ?? "", (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(company: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'VAT Number', "", _editableCustomer?.vat ?? "", (value) {
                    _editableCustomer = _editableCustomer?.copyWith(vat: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'Phone', "", _editableCustomer?.phoneNumber ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(phoneNumber: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'Website', "", _editableCustomer?.website ?? '', (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(website: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'Address', "", _editableCustomer?.address ?? "", (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(address: value);
                  }),
                  const Divider(),
                  _buildEditableRow('City', "", _editableCustomer?.city ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(city: value);
                  }),
                  const Divider(),
                  _buildEditableRow('State', "", _editableCustomer?.state ?? '',
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(state: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'Zip Code', "", _editableCustomer?.zip ?? "", (value) {
                    _editableCustomer = _editableCustomer?.copyWith(zip: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Country', 'country',
                      getCountryName(_editableCustomer?.country ?? ""),
                      (value) {
                    _editableCustomer =
                        _editableCustomer!.copyWith(country: value);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(
      String label, String type, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _isEditMode
                  ? (type == 'country' ||
                          type == 'shippingCountry' ||
                          type == 'billingCountry'
                      ? SizedBox(
                          width: double.infinity,
                          child: CustomDropdown(
                            hint: 'Select $type',
                            items: leadStore.country
                                .map((item) => item.shortName)
                                .toList(),
                            selectedValue: leadStore.country
                                    .where((item) =>
                                        item.countryId ==
                                        _getSelectedCountry(type))
                                    .isNotEmpty
                                ? leadStore.country
                                    .firstWhere((item) =>
                                        item.countryId ==
                                        _getSelectedCountry(type))
                                    .shortName
                                : null,
                            onChanged: (selectedValue) {
                              setState(() {
                                _updateCountry(type, selectedValue!);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please pick a country';
                              }
                              return null;
                            },
                          ),
                        )
                      : TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            hintText: label,
                            border: const OutlineInputBorder(),
                          ),
                          controller: TextEditingController(text: value),
                          onChanged: onChanged,
                        ))
                  : Text(
                      type == 'country' ||
                              type == 'shippingCountry' ||
                              type == 'billingCountry'
                          ? getCountryName(_getSelectedCountry(type))
                          : value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSelectedCountry(String type) {
    switch (type) {
      case 'country':
        return _editableCustomer?.country?.isNotEmpty == true
            ? _editableCustomer!.country!
            : '';
      case 'shippingCountry':
        return _editableCustomer?.shippingCountry?.isNotEmpty == true
            ? _editableCustomer!.shippingCountry!
            : '';
      case 'billingCountry':
        return _editableCustomer?.billingCountry?.isNotEmpty == true
            ? _editableCustomer!.billingCountry!
            : '';
      default:
        return '';
    }
  }

  void _updateCountry(String type, String selectedValue) {
    String? countryId = getCountryId(selectedValue); // Convert name to ID
    switch (type) {
      case 'country':
        _editableCustomer = _editableCustomer?.copyWith(country: countryId);
        break;
      case 'billingCountry':
        _editableCustomer =
            _editableCustomer?.copyWith(billingCountry: countryId);
        break;
      case 'shippingCountry':
        _editableCustomer =
            _editableCustomer?.copyWith(shippingCountry: countryId);
        break;
    }
  }

  String getCountryName(String countryCode) {
    final country = leadStore.country.firstWhere(
      (c) => c.countryId == countryCode,
      orElse: () => Country(
          countryId: '',
          shortName: 'N/A',
          callingCode: '',
          longName: ''), // Default fallback
    );
    return country.shortName ?? 'N/A';
  }

  Widget _buildBillingShippingTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader('Billing Address'),
            height10(),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableRow(
                      'Street', "", _editableCustomer?.billingStreet ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(billingStreet: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'City', "", _editableCustomer?.billingCity ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(billingCity: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'State', "", _editableCustomer?.billingState ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(billingState: value);
                    ();
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'Zip Code', "", _editableCustomer?.billingZip ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(billingZip: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Country', 'billingCountry',
                      _editableCustomer?.billingCountry ?? "", (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(billingCountry: value);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Shipping Address'),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableRow(
                      'Street', "", _editableCustomer?.shippingStreet ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(shippingStreet: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'City', "", _editableCustomer?.shippingCity ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(shippingCity: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'State', "", _editableCustomer?.shippingState ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(shippingState: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'Zip Code', "", _editableCustomer?.shippingZip ?? "",
                      (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(shippingZip: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Country', 'shippingCountry',
                      _editableCustomer?.shippingCountry ?? "", (value) {
                    _editableCustomer =
                        _editableCustomer?.copyWith(shippingCountry: value);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
