import 'package:crm/features/dashboard/customer/customer_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../constants/app_constants.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../utils/default_logger.dart';
import '../../../widgets/common_text_field.dart';
import '../../../../widgets/custom_dropdown.dart';

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
      _shippingStreetController.clear();
      _shippingZipController.clear();
      _shippingCityController.clear();
      countryShipping = null;
      stateShippingController.clear();
    }
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

  String? getCountryName(String id) {
    try {
      return leadStore.country
          .firstWhere((country) => country.countryId == id)
          .shortName;
    } catch (e) {
      return null; // Return null if the ID is not found
    }
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
          title: const Text(
            'Add Customer', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          ),
          centerTitle: false,
          leading: const BackButton(color: Colors.black,),
        ),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
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
              child: Form(
                key: _profileFormKey,
                child: TabBarView(
                  children: [
                    // Profile Tab
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            height10(),
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
                            CustomDropdown(
                              hint: 'Select Country',
                              items: leadStore.country
                                  .map((e) => e.shortName)
                                  .toList(),
                              selectedValue: getCountryName(country ?? ""),
                              onChanged: (value) {
                                setState(() {
                                  country = getCountryId(value ?? "");
                                  warningLog("Selected Country: $country");
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: stateController,
                              label: 'Enter State',
                              hint: 'Enter State',

                            ),
                            const SizedBox(height: 15),
                            CommonTextField(
                              controller: _cityController,
                              label: 'City',
                              hint: 'Enter City',

                            ),
                            const SizedBox(height: 15),
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
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _sectionHeader("Billing Address"),
                              const SizedBox(height: 10),
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
                              CustomDropdown(
                                hint: 'Select Country',
                                items: leadStore.country
                                    .map((e) => e.shortName)
                                    .toList(),
                                selectedValue: getCountryName(countryBilling ?? ""),
                                  onChanged: (value) {
                                    setState(() {
                                      countryBilling = getCountryId(value ?? "");

                                      if (_sameAsBilling) {
                                        countryShipping = countryBilling;
                                      }
                                    });
                                  },
                              ),
                              const SizedBox(height: 15),
                              CommonTextField(
                                controller: stateBillingController,
                                label: 'Billing State',
                                hint: 'Enter State',
                              ),
                              // const SizedBox(height: 15),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              //   decoration: BoxDecoration(
                              //     color: CRMColors.surface,
                              //     borderRadius: BorderRadius.circular(10),
                              //     border: Border.all(color: CRMColors.border),
                              //   ),
                              //   child: Row(
                              //     children: [
                              //       Checkbox(
                              //         value: _sameAsBilling,
                              //         activeColor: CRMColors.primary,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             _sameAsBilling = value!;
                              //             _copyBillingToShipping();
                              //           });
                              //         },
                              //       ),
                              //       const Text(
                              //         "Shipping address same as billing",
                              //         style: TextStyle(fontSize: 14),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              const SizedBox(height: 20),
                              _sectionHeader("Shipping Address"),
                              const SizedBox(height: 10),
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
                              CustomDropdown(
                                hint: 'Select Country',
                                items: leadStore.country
                                    .map((item) => item.shortName)
                                    .toList(),
                                selectedValue: getCountryName(countryShipping ?? ""),
                                  onChanged: (value) {
                                    setState(() {
                                      countryShipping = getCountryId(value ?? "");
                                    });
                                  },
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
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              if (_profileFormKey.currentState!.validate()) {
                FormData formData = FormData.fromMap({
                  "company": _companyController.text,
                  "vat": _vatController.text,
                  "phonenumber": _phoneController.text,
                  "website": _websiteController.text,
                  "address": _addressController.text,
                  "country": country ?? "",
                  "state": stateController.text,
                  "zip": _zipController.text,
                  "city": _cityController.text,
                  'billing_street': _billingStreetController.text,
                  'billing_city': _billingCityController.text,
                  'billing_state': stateBillingController.text,
                  'billing_zip': _billingZipController.text,
                  'billing_country': countryBilling ?? "",
                  'shipping_street': _shippingStreetController.text,
                  'shipping_city': _shippingCityController.text,
                  'shipping_state': stateShippingController.text,
                  'shipping_zip': _shippingZipController.text,
                  'shipping_country': countryShipping ?? "",
                });
                infoLog("Add Customer DATA ----$formData");

                // Call the _saveCustomerData method
                _saveCustomerData(formData);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CRMColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Add Customer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),

          ),
        ),
      ),
    );
  }
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: CRMColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: boldTextStyle(
              size: 16,
              color: CRMColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
  void _saveCustomerData(FormData formData) async {
    warningLog("Editable customer Data: $formData");

    try {
      final (bool status, Map<String, dynamic> response, String? message) =
          await ApiService.editCustomer(formData);

      // Print the response data to the console
     log("Response status: $status");
      log("Response data: ${response['message']}");
    log("Response message: $message");

      if (status) {
        toastLong(
          response['message'],
          gravity: ToastGravity.TOP,
          bgColor: completedColor,
          textColor: Colors.white,
        );
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerScreen(),
            ));
        print("Customer data successfully edited.");
      } else {
        print("Failed to edit customer data: $message");
      }
    } catch (error) {
      print("Error while saving customer data: $error");
    }
  }
}
