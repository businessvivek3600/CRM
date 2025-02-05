import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crm/features/auth/dashboard/customer/customer_Screen.dart';
import 'package:crm/features/auth/dashboard/customer/updatecustomer.dart';
import 'package:crm/utils/colors.dart';

import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';

class CustomerDetails extends StatefulWidget {
  final Customer customer;

  const CustomerDetails({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  bool _isEditMode = false;
  late Customer _editableCustomer;
  late Customer _initialCustomer;

  @override
  void initState() {
    super.initState();
    _editableCustomer = widget.customer;
    _initialCustomer = widget.customer;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.customer.company),
          backgroundColor: secondaryPrimaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerScreen(),
                  ));
            },
          ),
          actions: [
            _isEditMode
                ? SizedBox()
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        if (_isEditMode) {
                          _saveCustomerData();
                        }
                        _isEditMode = !_isEditMode;
                      });
                    },
                  ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Material(
                color: const Color(0xfffef7ff),
                child: TabBar(
                  dividerColor: Colors.black.withOpacity(0.1),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: textPrimaryColors,
                  unselectedLabelColor: textPrimaryColors.withOpacity(0.6),
                  indicatorColor: acceptColor,
                  tabs: const [
                    Tab(text: 'Profile'),
                    Tab(text: 'Billing & Shipping'),
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
              if (_isEditMode)
                BottomAppBar(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _editableCustomer = _initialCustomer;
                              _isEditMode = false;
                            });
                          },
                          child: const Text('Cancel',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      width30(),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _saveCustomerData();
                              _isEditMode = false;
                            });
                          },
                          child: const Text('Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _saveCustomerData() async {

      final FormData formData = FormData.fromMap({
        "id": widget.customer.userId.toString(),
        'active': widget.customer.active.toString(),
        'company': _editableCustomer.company,
        'vat': _editableCustomer.vat,
        'phonenumber': _editableCustomer.phoneNumber,
        'country': _editableCustomer.country,
        'city': _editableCustomer.city,
        'zip': _editableCustomer.zip,
        'state': _editableCustomer.state,
        'address': _editableCustomer.address,
        'website': _editableCustomer.website,
        'billing_street': _editableCustomer.billingStreet,
        'billing_city': _editableCustomer.billingCity,
        'billing_state': _editableCustomer.billingState,
        'billing_zip': _editableCustomer.billingZip,
        'billing_country': _editableCustomer.billingCountry,
        'shipping_street': _editableCustomer.shippingStreet,
        'shipping_city': _editableCustomer.shippingCity,
        'shipping_state': _editableCustomer.shippingState,
        'shipping_zip': _editableCustomer.shippingZip,
        'shipping_country': _editableCustomer.shippingCountry,
      });
      warningLog("Editable customer Data: $formData");
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiService.editCustomer(formData);
      warningLog("STATUS customer Data: $status");
      warningLog("RESPONSE customer Data: $data");
      warningLog("MESSAGE customer Data: $message");
      if (status) {
        infoLog('Success: $message');
      } else {
        print('Error: $status - $data');
      }

  }

  bool _hasCustomerChanged() {
    return _editableCustomer != _initialCustomer;
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
                      'Company', "", _editableCustomer.company ?? "", (value) {
                    _editableCustomer =
                        _editableCustomer.copyWith(company: value);
                  }),
                  const Divider(),
                  _buildEditableRow(
                      'VAT Number', "", _editableCustomer.vat ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(vat: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Phone', "", _editableCustomer.phoneNumber,
                      (value) {
                    _editableCustomer =
                        _editableCustomer.copyWith(phoneNumber: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Website', "", _editableCustomer.website,
                      (value) {
                    _editableCustomer =
                        _editableCustomer.copyWith(website: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Address', "", _editableCustomer.address,
                      (value) {
                    _editableCustomer =
                        _editableCustomer.copyWith(address: value);
                  }),
                  const Divider(),
                  _buildEditableRow('City', "", _editableCustomer.city,
                      (value) {
                    _editableCustomer = _editableCustomer.copyWith(city: value);
                  }),
                  const Divider(),
                  _buildEditableRow('State', "", _editableCustomer.state,
                      (value) {
                    _editableCustomer =
                        _editableCustomer.copyWith(state: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Zip Code', "", _editableCustomer.zip,
                      (value) {
                    _editableCustomer = _editableCustomer.copyWith(zip: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Country', 'country',
                      getCountryName(_editableCustomer.country), (value) {
                    _editableCustomer =
                        _editableCustomer.copyWith(country: value);
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
                          child: DropdownButtonFormField<String>(
                            value: leadStore.country.any((c) => c.countryId == _getSelectedCountry(type))
                                ? _getSelectedCountry(type)
                                : null,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            items: leadStore.country.map((c) {
                              return DropdownMenuItem<String>(
                                value: c.countryId,
                                child: SizedBox(
                                  width: 100,
                                  child: Text(
                                    c.shortName ?? 'N/A',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedValue) {
                              if (selectedValue != null) {
                                setState(() {
                                  _updateCountry(type, selectedValue);
                                });
                              }
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
        return _editableCustomer.country;
      case 'shippingCountry':
        return _editableCustomer.shippingCountry!;
      case 'billingCountry':
        return _editableCustomer.billingCountry!;
      default:
        return '';
    }
  }

  void _updateCountry(String type, String selectedValue) {
    switch (type) {
      case 'country':
        _editableCustomer = _editableCustomer.copyWith(country: selectedValue);
        break;
      case 'shippingCountry':
        _editableCustomer =
            _editableCustomer.copyWith(shippingCountry: selectedValue);
        break;
      case 'billingCountry':
        _editableCustomer =
            _editableCustomer.copyWith(billingCountry: selectedValue);
        break;
      default:
        return null;
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
  bool _sameAsShipping = false;

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
                  _buildEditableRow('Street', "", _editableCustomer.billingStreet ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(billingStreet: value);
                    if (_sameAsShipping) _copyBillingToShipping();
                  }),
                  const Divider(),
                  _buildEditableRow('City', "", _editableCustomer.billingCity ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(billingCity: value);
                    if (_sameAsShipping) _copyBillingToShipping();
                  }),
                  const Divider(),
                  _buildEditableRow('State', "", _editableCustomer.billingState ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(billingState: value);
                    if (_sameAsShipping) _copyBillingToShipping();
                  }),
                  const Divider(),
                  _buildEditableRow('Zip Code', "", _editableCustomer.billingZip ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(billingZip: value);
                    if (_sameAsShipping) _copyBillingToShipping();
                  }),
                  const Divider(),
                  _buildEditableRow('Country', 'billingCountry', _editableCustomer.billingCountry ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(billingCountry: value);
                    if (_sameAsShipping) _copyBillingToShipping();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
           _buildSectionHeader('Shipping Address'),
            if(_isEditMode)   Column(
              children: [
                height10(),
                CheckboxListTile(
                  title: const Text("Same as Billing Address"),
                  value: _sameAsShipping,
                  onChanged: (value) {
                    setState(() {
                      _sameAsShipping = value!;
                      if (_sameAsShipping) {
                        _copyBillingToShipping();
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),

            height10(),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableRow('Street', "", _editableCustomer.shippingStreet ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(shippingStreet: value);
                  }),
                  const Divider(),
                  _buildEditableRow('City', "", _editableCustomer.shippingCity ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(shippingCity: value);
                  }),
                  const Divider(),
                  _buildEditableRow('State', "", _editableCustomer.shippingState ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(shippingState: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Zip Code', "", _editableCustomer.shippingZip ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(shippingZip: value);
                  }),
                  const Divider(),
                  _buildEditableRow('Country', 'shippingCountry', _editableCustomer.shippingCountry ?? "", (value) {
                    _editableCustomer = _editableCustomer.copyWith(shippingCountry: value);
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

  void _copyBillingToShipping() {
    setState(() {
      _editableCustomer = _editableCustomer.copyWith(
        shippingStreet: _editableCustomer.billingStreet,
        shippingCity: _editableCustomer.billingCity,
        shippingState: _editableCustomer.billingState,
        shippingZip: _editableCustomer.billingZip,
        shippingCountry: _editableCustomer.billingCountry,
      );
    });
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
