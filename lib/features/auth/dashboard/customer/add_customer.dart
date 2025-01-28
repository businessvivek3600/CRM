import 'package:crm/features/auth/dashboard/customer/customer_Screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../constants/app_constants.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
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
  final TextEditingController _cityController = TextEditingController();

  final TextEditingController _billingStreetController =
      TextEditingController();
  final TextEditingController _billingZipController = TextEditingController();
  final TextEditingController _billingCityController = TextEditingController();
  final TextEditingController stateShippingController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController stateBillingController = TextEditingController();
  final TextEditingController _shippingStreetController =
      TextEditingController();
  final TextEditingController _shippingZipController = TextEditingController();
  final TextEditingController _shippingCityController = TextEditingController();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  String? country;

  String? countryBilling;

  String? countryShipping;

  bool _sameAsBilling = false;

  void _copyBillingToShipping() {
    if (_sameAsBilling) {
      _shippingStreetController.text = _billingStreetController.text;
      _shippingZipController.text = _billingZipController.text;
      _shippingCityController.text = _billingCityController.text;
      countryShipping = countryBilling;
      stateShippingController.text = stateBillingController.text;
    } else {
      // Clear shipping address fields when "same as billing" is unchecked
      _shippingStreetController.clear();
      _shippingZipController.clear();
      _shippingCityController.clear();
      countryShipping = null;
      stateShippingController.clear();
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
                labelStyle: const TextStyle(fontSize: 18),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                tabs: const [
                  Tab(text: "Profile"),
                  Tab(text: "Billing Details"),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _profileFormKey,
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
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Company Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _vatController,
                              label: 'VAT Number',
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _phoneController,
                              label: 'Phone',
                              formatter: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              hint: 'Enter Phone Number',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Phone number is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _websiteController,
                              label: 'Website',
                              hint: 'Enter Website URL',
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _addressController,
                              label: 'Address',
                              hint: 'Enter Address',
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              value: country,
                              items: leadStore.country
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.countryId,
                                        child: SizedBox(
                                            width: 250,
                                            child: Text(item.shortName)),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  country = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Select  Country',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Country is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: stateController,
                              label: 'Enter State',
                              hint: 'Enter State',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'State is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _cityController,
                              label: 'City',
                              hint: 'Enter City',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'City is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _zipController,
                              label: 'Zip Code',
                              hint: 'Enter Zip Code',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Zip Code is required';
                                }
                                return null;
                              },
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
                              const SizedBox(height: 15),
                              CommonTextField(
                                controller: _billingCityController,
                                label: 'Billing City',
                                hint: 'Billing City',
                              ),
                              const SizedBox(height: 15),
                              CommonTextField(
                                controller: _billingZipController,
                                label: 'Billing Zip',
                                hint: 'Billing Zip',
                              ),
                              const SizedBox(height: 15),
                              DropdownButtonFormField<String>(
                                value: countryBilling,
                                items: leadStore.country
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.countryId,
                                          child: SizedBox(
                                              width: 250,
                                              child: Text(item.shortName)),
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    countryBilling = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Select Billing Country',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              CommonTextField(
                                controller: stateBillingController,
                                label: 'Billing State',
                                hint: 'Enter State',
                              ),
                              const SizedBox(height: 15),
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
                              const SizedBox(height: 15),
                              CommonTextField(
                                controller: _shippingZipController,
                                label: 'Shipping Zip',
                                hint: 'Shipping Zip',
                              ),
                              const SizedBox(height: 15),
                              DropdownButtonFormField<String>(
                                value: countryShipping,
                                items: leadStore.country
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.countryId,
                                          child: SizedBox(
                                              width: 250,
                                              child: Text(item.shortName)),
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    countryShipping = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Select Shipping Country',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              CommonTextField(
                                controller: stateShippingController,
                                label: 'Shipping State',
                                hint: 'Enter State',
                              ),
                              const SizedBox(height: 15),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Bottom Navigation Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 15,right: 1,bottom: 20),
          child: ElevatedButton(
            onPressed: () {
    if (_profileFormKey.currentState!.validate()) {
              final Map<String, dynamic> formData = {
                "company": _companyController.text,
                "vat": _vatController.text,
                "phonenumber": _phoneController.text,
                "website": _websiteController.text,
                "address": _addressController.text,
                "country": country??"",
                "state": stateController.text,
                "zip": _zipController.text,
                "city": _cityController.text,
                'billing_street': _billingStreetController.text,
                'billing_city': _billingCityController.text,
                'billing_state': stateBillingController.text,
                'billing_zip': _billingZipController.text,
                'billing_country': countryBilling??"",
                'shipping_street': _shippingStreetController.text,
                'shipping_city': _shippingCityController.text,
                'shipping_state': stateShippingController.text,
                'shipping_zip': _shippingZipController.text,
                'shipping_country': countryShipping ??"",
              };
              infoLog("Add Customer DATA ----$formData");

              // Call the _saveCustomerData method
              _saveCustomerData(formData);
            }},
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }

  void _saveCustomerData(Map<String, dynamic> formData) async {
    warningLog("Editable customer Data: $formData");

    try {
      final (bool status, Map<String, dynamic> response, String? message) =
          await ApiService.editCustomer(formData);

      // Print the response data to the console
      print("Response status: $status");
      print("Response data: ${response['message']}");
      print("Response message: $message");

      if (status) {
        toastLong(response['message'], gravity: ToastGravity.TOP,bgColor: completedColor,textColor: Colors.white,);
        _companyController.clear();
        _vatController.clear();
        _phoneController.clear();
        _websiteController.clear();
        _addressController.clear();
        _zipController.clear();
        _cityController.clear();
        _billingStreetController.clear();
        _billingZipController.clear();
        _billingCityController.clear();
        stateShippingController.clear();
        stateController.clear();
        stateBillingController.clear();
        _shippingStreetController.clear();
        _shippingZipController.clear();
        _shippingCityController.clear();

        // Reset selected countries and states
        country = null;
        countryBilling = null;
        countryShipping = null;

        // Optionally, uncheck the "Same as billing" checkbox
        setState(() {
          _sameAsBilling = false;
        });

        // Navigate back to the previous screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerScreen(),));
        print("Customer data successfully edited.");
      } else {

        print("Failed to edit customer data: $message");
      }
    } catch (error) {
      print("Error while saving customer data: $error");
    }
  }
}
