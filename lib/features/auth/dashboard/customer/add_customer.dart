import 'package:country_state_picker/components/index.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../constants/app_constants.dart';
import '../../../../services/api_services.dart';
import '../../../../utils/default_logger.dart';
import '../../../../utils/text_field.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  final TextEditingController _billingStreetController = TextEditingController();
  final TextEditingController _billingZipController = TextEditingController();
  final TextEditingController _billingCityController = TextEditingController();
  final TextEditingController _shippingStreetController = TextEditingController();
  final TextEditingController _shippingZipController = TextEditingController();
  final TextEditingController _shippingCityController = TextEditingController();

  String? country;
  String? state;
  String? countryBilling;
  String? stateBilling;
  String? countryShipping;
  String? stateShipping;
  bool _sameAsBilling = false;
  void _copyBillingToShipping() {
    if (_sameAsBilling) {
      _shippingStreetController.text = _billingStreetController.text;
      _shippingZipController.text = _billingZipController.text;
      _shippingCityController.text = _billingCityController.text;
      countryShipping = countryBilling;
      stateShipping = stateBilling;
    } else {
      // Clear shipping address fields when "same as billing" is unchecked
      _shippingStreetController.clear();
      _shippingZipController.clear();
      _shippingCityController.clear();
      countryShipping = null;
      stateShipping = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Customer'),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                unselectedLabelColor: AppConst.defaultPrimaryColor,
                indicatorColor: waitingColor,
                labelColor: black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2.0,
                labelStyle: TextStyle(fontSize: 18),
                unselectedLabelStyle: TextStyle(fontSize: 16),
                tabs: const [
                  Tab(text: "Profile"),
                  Tab(text: "Billing Details"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Profile Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          CommonTextField(
                            controller: _companyController,
                            label: 'Legal Company Name',
                            hint: 'Legal Company Name',
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: _vatController,
                            label: 'VAT Number',
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: _phoneController,
                            label: 'Phone',
                            hint: 'Enter Phone Number',
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: _websiteController,
                            label: 'Website',
                            hint: 'Enter Website URL',
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: _addressController,
                            label: 'Address',
                            hint: 'Enter Address',
                          ),
                          SizedBox(height: 15),
                          CountryStatePicker(
                            inputDecoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.6)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            countryLabel: const Label(title: "Country"),
                            stateLabel: const Label(title: "State"),
                            onCountryChanged: (ct) => setState(() {
                              country = ct;
                              state = null;
                            }),
                            onStateChanged: (st) => setState(() {
                              state = st;
                            }),
                            countryHintText: "Select Country",
                            stateHintText: "Select State",
                          ),
                          SizedBox(height: 15),
                          CommonTextField(
                            controller: _zipController,
                            label: 'Zip Code',
                            hint: 'Enter Zip Code',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Billing Details Tab
                  SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // const SizedBox(height: 15),
                            CommonTextField(
                              controller: _billingStreetController,
                              label: 'Billing Street',
                              hint: 'Billing Street',
                            ),
                            SizedBox(height: 15),
                            CommonTextField(
                              controller: _billingCityController,
                              label: 'Billing City',
                              hint: 'Billing City',
                            ),
                            SizedBox(height: 15),
                            CommonTextField(
                              controller: _billingZipController,
                              label: 'Billing Zip',
                              hint: 'Billing Zip',
                            ),
                            const SizedBox(height: 15),
                            CountryStatePicker(
                              inputDecoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor), // Primary color
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(
                                        0.6)), // Primary color with opacity
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor), // Primary color border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor), // Focused state border color
                                ),
                                focusColor: Theme.of(context)
                                    .primaryColor, // Focus color
                                hoverColor: Theme.of(context)
                                    .primaryColor, // Hover color
                              ),
                              // countryLabel: const Label(title: "Country"),
                              // stateLabel: const Label(title: "State"),
                              onCountryChanged: (ct) => setState(() {
                                countryBilling = ct;
                                stateBilling = null;
                              }),
                              onStateChanged: (st) => setState(() {
                                stateBilling = st;
                              }),
                              countryHintText: "Select Billing Country",
                              stateHintText: "Billing State",
                              noStateFoundText: "No State Found",
                            ),
                            SizedBox(height: 15),
                            // Checkbox for "Same as Billing Address"
                            Row(
                              children: [
                                Checkbox(
                                  value: _sameAsBilling,
                                  activeColor: acceptColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _sameAsBilling = value!;
                                      _copyBillingToShipping();
                                    });
                                  },
                                ),
                                const Text("Same as billing address"),
                              ],
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _shippingStreetController,
                              label: 'Shipping Street',
                              hint: 'Shipping Street',
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _shippingCityController,
                              label: 'Shipping City',
                              hint: 'Shipping City',
                            ),
                            SizedBox(height: 15),
                            CommonTextField(
                              controller: _shippingZipController,
                              label: 'Shipping Zip',
                              hint: 'Shipping Zip',
                            ),
                            const SizedBox(height: 15),
                            CountryStatePicker(
                              inputDecoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor), // Primary color
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(
                                        0.6)), // Primary color with opacity
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor), // Primary color border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor), // Focused state border color
                                ),
                                focusColor: Theme.of(context)
                                    .primaryColor, // Focus color
                                hoverColor: Theme.of(context)
                                    .primaryColor, // Hover color
                              ),
                              // countryLabel: const Label(title: "Country"),
                              // stateLabel: const Label(title: "State"),
                              onCountryChanged: (ct) => setState(() {
                                countryShipping = ct;
                                stateShipping = null;
                              }),
                              onStateChanged: (st) => setState(() {
                                stateShipping = st;
                              }),
                              countryHintText: "Select Shipping Country",
                              stateHintText: "Shipping State",
                              noStateFoundText: "No State Found",
                            ),
                            const SizedBox(height: 15),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Bottom Navigation Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              if (country != null && state != null) {
                final Map<String, dynamic> formData = {
                  "company": _companyController.text,
                  "vat": _vatController.text,
                  "phonenumber": _phoneController.text,
                  "website": _websiteController.text,
                  "address": _addressController.text,
                  "country": country,
                  "state": state,
                  "zip": _zipController.text,
                  'billing_street': _billingStreetController.text,
                  'billing_city': _billingCityController.text,
                  'billing_state': stateBilling,
                  'billing_zip':_billingZipController.text,
                  'billing_country': countryBilling,
                  'shipping_street': _shippingStreetController.text,
                  'shipping_city':_shippingCityController.text,
                  'shipping_state': stateShipping,
                  'shipping_zip': _shippingZipController.text,
                  'shipping_country': countryShipping,
                };

                // Call the _saveCustomerData method
                _saveCustomerData(formData);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please select a country and state.')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }

  void _saveCustomerData(Map<String, dynamic> formData) async {
    warningLog("Editable customer Data: $formData");

    final (bool status, Map<String, dynamic> response, String? message) =
        await ApiService.editCustomer(formData);

    if (status) {
      infoLog('Success: ${message}');
      // Handle success (e.g., show a success message or navigate)
    } else {
      print('Error: ${status} - ${response}');
      // Handle API error
    }
  }
}
