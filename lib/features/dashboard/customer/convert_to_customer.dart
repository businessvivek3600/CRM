import 'package:crm/features/dashboard/customer/customer_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/extensions.dart';
import 'package:crm/widgets/common_text_field.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../widgets/custom_dropdown.dart';

class ConvertToCustomer extends StatefulWidget {
  const ConvertToCustomer({super.key, required this.lead});
  final Lead lead;

  @override
  State<ConvertToCustomer> createState() => _ConvertedToCustomerState();
}

class _ConvertedToCustomerState extends State<ConvertToCustomer> {
  // Variables for fields

  late TextEditingController nameController;
  late TextEditingController lastNameController;

  late TextEditingController positionController;
  late TextEditingController emailController;
  late TextEditingController companyController;
  late TextEditingController phoneController;
  late TextEditingController websiteController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipController;

  late bool isPasswordHidden = true;
  bool sendSetPasswordEmail = false;
  bool doNotSendWelcomeEmail = false;
  bool transferNote = false;
  final passwordController = TextEditingController();
  String lastName = '';
  String firstName = '';
  String? country;
  @override
  void initState() {
    super.initState();
    //Initialize variables with lead data

    List<String> nameParts = widget.lead.name.split(' ');

    if (nameParts.length == 1) {
      firstName = nameParts[0];
    } else {
      firstName = nameParts[0];
      lastName = nameParts.sublist(1).join(' ');
    }
    nameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    positionController = TextEditingController(text: widget.lead.title ?? "");
    emailController = TextEditingController(text: widget.lead.email ?? "");
    companyController = TextEditingController(text: widget.lead.company ?? "");
    phoneController =
        TextEditingController(text: widget.lead.phonenumber ?? "");
    addressController = TextEditingController(text: widget.lead.address ?? "");
    cityController = TextEditingController(text: widget.lead.city ?? "");
    stateController = TextEditingController(text: widget.lead.state ?? "");
    errorLog("COUNTRY__________${widget.lead.country}");
    country = widget.lead.country != 0 &&
        leadStore.country.any((c) => c.countryId == widget.lead.country)
        ? widget.lead.country
        : null;
    websiteController = TextEditingController(text: widget.lead.website ?? "");
    zipController = TextEditingController(text: widget.lead.zip ?? "");
    infoLog("company name---${companyController.text.trim()}");
    infoLog("WEBSITE name---${websiteController.text.trim()}");
  }

  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:BackButton(color: Colors.black,),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),

          title:  Text(
          'Convert to Customer',
            style: boldTextStyle( size: 18),
            overflow: TextOverflow.ellipsis,
      ),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sectionHeader("Customer Information"),
                  const SizedBox(height: 8,),
                  CommonTextField(
                    controller: nameController,
                    label: 'First Name *',
                    hint: 'Enter First Name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: lastNameController,
                    label: 'Last Name *',
                    hint: 'Enter Last Name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: positionController,
                    label: 'Position *',
                    hint: 'Enter Position',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: emailController,
                    label: 'Email *',
                    hint: 'Enter Email',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      // Email format validation using RegExp
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: companyController,
                    label: 'Company *',
                    hint: 'Enter Company Name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Company Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: phoneController,
                    label: 'Phone *',
                    hint: 'Enter Phone Number',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: websiteController,
                    label: 'Website',
                    hint: 'Enter your website address',
                  ),
                  const SizedBox(height: 15),
                  sectionHeader("Address Information"),
                  const SizedBox(height: 8),
                  CommonTextField(
                    controller: addressController,
                    label: 'Address',
                    hint: 'Enter Address',
                  ),
                  const SizedBox(height: 15),
                  CustomDropdown(
                    hint: 'Select Country *',
                    items: leadStore.country.map((item) => item.shortName).toList(),
                    selectedValue: (country != null && country != 0)
                        ? leadStore.country.firstWhere((item) => item.countryId == country).shortName
                        : null,
                    onChanged: (value) {
                      setState(() {
                        country = leadStore.country
                            .firstWhere((item) => item.shortName == value)
                            .countryId;

                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please pick a country';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: stateController,
                    label: 'State *',
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
                    controller: cityController,
                    label: 'City *',
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
                    controller: zipController,
                    label: 'Zip Code *',
                    hint: 'Enter Zip Code',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Zip Code is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  sectionHeader("Account Settings"),
                  const SizedBox(height: 8),
                  if (!sendSetPasswordEmail)
                    TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Password *",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                        ),
                      ),
                    ),
                  if (!sendSetPasswordEmail)
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: acceptColor,
                        value: sendSetPasswordEmail,
                        onChanged: (value) {
                          setState(() {
                            sendSetPasswordEmail = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        "Send set password email",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: acceptColor,
                        value: doNotSendWelcomeEmail,
                        onChanged: (value) {
                          setState(() {
                            doNotSendWelcomeEmail = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        "Do not send welcome email",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: transferNote,
                        activeColor: acceptColor,
                        onChanged: (value) {
                          setState(() {
                            transferNote = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        "Transfer lead notes to customer profile",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Back to lead"),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_profileFormKey.currentState!.validate()) {
                            bool isFieldUpdated(
                                String currentValue, String? initialValue) {
                              return currentValue != initialValue;
                            }

                            final updatedData = <String, dynamic>{};
                            // Check for each field and use the initial value if it's null or empty
                            updatedData['firstname'] = isFieldUpdated(
                                    nameController.text, firstName)
                                ? nameController.text.trim()
                                : widget.lead.name.split(' ')[0];
                            updatedData['lastname'] = isFieldUpdated(
                                    lastNameController.text, lastName)
                                ? lastNameController.text.trim()
                                : widget.lead.name
                                    .split(' ')
                                    .sublist(1)
                                    .join(' ');
                            updatedData['title'] = isFieldUpdated(
                                    positionController.text,
                                    widget.lead.title ?? "")
                                ? positionController.text.trim()
                                : widget.lead.title;
                            updatedData['email'] = isFieldUpdated(
                                    emailController.text,
                                    widget.lead.email ?? "")
                                ? emailController.text.trim()
                                : widget.lead.email;
                            updatedData['company'] = isFieldUpdated(
                                    companyController.text,
                                    widget.lead.company ?? "")
                                ? companyController.text.trim()
                                : widget.lead.company;
                            updatedData['phonenumber'] = isFieldUpdated(
                                    phoneController.text,
                                    widget.lead.phonenumber ?? "")
                                ? phoneController.text.trim()
                                : widget.lead.phonenumber;
                            updatedData['website'] = isFieldUpdated(
                                    websiteController.text,
                                    widget.lead.website ?? "")
                                ? websiteController.text.trim()
                                : widget.lead.website;
                            updatedData['address'] = isFieldUpdated(
                                    addressController.text,
                                    widget.lead.address ?? "")
                                ? addressController.text.trim()
                                : widget.lead.address;
                            updatedData['city'] = isFieldUpdated(
                                    cityController.text, widget.lead.city ?? "")
                                ? cityController.text.trim()
                                : widget.lead.city;
                            updatedData['state'] = isFieldUpdated(
                                stateController.text, widget.lead.state ?? "")
                                ? stateController.text.trim()
                                : widget.lead.state;
                            updatedData['zip'] = isFieldUpdated(
                                    zipController.text, widget.lead.zip ?? "")
                                ? zipController.text.trim()
                                : widget.lead.zip;
                            updatedData['country'] =
                                country ?? widget.lead.country;
                            if (!sendSetPasswordEmail &&
                                passwordController.text.isNotEmpty) {
                              updatedData['password'] = passwordController.text;
                            }
                            updatedData['transfer_notes'] =
                                transferNote ? 1 : 0;
                            updatedData['sendPwdEmail'] =
                                sendSetPasswordEmail ? 1 : 0;
                            updatedData['noWelcomeEmail'] =
                                doNotSendWelcomeEmail ? 1 : 0;
                            updatedData['leadid'] = widget.lead.id;
                            final formData = FormData.fromMap(updatedData);

                            if (updatedData.isNotEmpty) {
                              try {
                                final (
                                  bool status,
                                  Map<String, dynamic> response,
                                  String? message
                                ) = await ApiService.convertCustomer(formData);

                                if (status) {
                                    infoLog('Success: $message');
                                    Navigator.pop(context, true);
                                  // Show success message or navigate
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  Navigator.of(context).pop(true);
                                  infoLog('API Error: $response');
                                  // Show error feedback
                                }
                              } catch (error) {
                                infoLog('Error during API request: $error');
                                // Handle network or API error
                              }
                            } else {
                              infoLog('No changes detected.');
                              // Show feedback for no changes
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please fill the required information"),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2)),
                            );
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget sectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: boldTextStyle(size: 16),
        ),
        const SizedBox(height: 6),
        Container(
          height: 2,
          width: 40,
          decoration: BoxDecoration(
            color: CRMColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  Widget requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: primaryTextStyle(size: 14),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }
}
