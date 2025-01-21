import 'package:country_state_picker/components/index.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/text_field.dart';
import 'package:dio/src/form_data.dart';
import 'package:flutter/material.dart';

import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';

class ConvertToCustomer extends StatefulWidget {
  ConvertToCustomer({super.key, required this.lead});
  final Lead lead;

  @override
  State<ConvertToCustomer> createState() => _ConvertedToCustomerState();
}

class _ConvertedToCustomerState extends State<ConvertToCustomer> {
  // Variables for fields
  String? firstName;
  String? position;
  String? email;
  String? company;
  String? phone;
  String? address;
  String? city;
  String? zipCode;
  String? state;

  String? country;
  late TextEditingController nameController;
  late TextEditingController leadValueController;
  late TextEditingController positionController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController companyController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipController;
  late TextEditingController phoneController;
  late TextEditingController descriptionController;
  late TextEditingController lastContactController;
  bool isPasswordHidden = true;
  bool sendSetPasswordEmail = false;
  bool doNotSendWelcomeEmail = false;
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize variables with lead data
    firstName = widget.lead.name;
    position = widget.lead.title;
    email = widget.lead.email;
    company = widget.lead.company;
    phone = widget.lead.phonenumber;
    address = widget.lead.address;
    city = widget.lead.city;
    stateController = TextEditingController(text: widget.lead.state);
    zipCode = widget.lead.zip;
    country = widget.lead.country;
    state = widget.lead.state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Convert to Customer',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CommonTextField(
                  label: 'First Name',
                  hint: 'Enter First Name',
                  initialValue: firstName, // Set initial value
                  onChanged: (value) => firstName = value,
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 15),
                CommonTextField(
                  label: 'Position',
                  hint: 'Enter Position',
                  initialValue: position,
                  onChanged: (value) => position = value,
                ),
                const SizedBox(height: 15),
                CommonTextField(
                  label: 'Email',
                  hint: 'Enter Email',
                  initialValue: email,
                  onChanged: (value) => email = value,
                ),
                const SizedBox(height: 15),
                CommonTextField(
                  label: 'Company',
                  hint: 'Enter Company Name',
                  initialValue: company,
                  onChanged: (value) => company = value,
                ),
                const SizedBox(height: 15),
                CommonTextField(
                  label: 'Phone',
                  hint: 'Enter Phone Number',
                  initialValue: phone,
                  onChanged: (value) => phone = value,
                ),
                const SizedBox(height: 15),
                CommonTextField(
                  label: 'Address',
                  hint: 'Enter Address',
                  initialValue: address,
                  onChanged: (value) => address = value,
                ),
                const SizedBox(height: 15),
                CommonTextField(
                  label: 'City',
                  hint: 'Enter City',
                  initialValue: city,
                  onChanged: (value) => city = value,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: country,
                  items: leadStore.country
                      .map((item) => DropdownMenuItem<String>(
                            value: item.countryId,
                            child: Text(item.shortName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      country = value;
                      state =
                          null; // Reset state when a new country is selected
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Country',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CommonTextField(
                  controller: stateController,
                  label: 'State',
                  hint: 'Enter State',
                ),
                const SizedBox(height: 15),
                CommonTextField(
                  label: 'Zip Code',
                  hint: 'Enter Zip Code',
                  initialValue: zipCode,
                  onChanged: (value) => zipCode = value,
                ),
                const SizedBox(height: 15),
                if (!sendSetPasswordEmail)
                  TextField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      labelText: "Password",
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
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Checkbox(
                      value: sendSetPasswordEmail,
                      onChanged: (value) {
                        setState(() {
                          sendSetPasswordEmail = value ?? false;
                        });
                      },
                    ),
                    const Text("Send SET password email"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: doNotSendWelcomeEmail,
                      onChanged: (value) {
                        setState(() {
                          doNotSendWelcomeEmail = value ?? false;
                        });
                      },
                    ),
                    const Text("Do not send welcome email"),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Back to lead action
                      },
                      child: const Text("Back to lead"),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Collect updated data
                        final updatedData = <String, dynamic>{};

                        // Compare each field with the initial value and add only changed fields
                        if (firstName?.trim() != widget.lead.name?.trim()) {
                          updatedData['firstname'] = firstName?.trim();
                        }
                        if (position?.trim() != widget.lead.title?.trim()) {
                          updatedData['title'] = position?.trim();
                        }
                        if (email?.trim() != widget.lead.email?.trim()) {
                          updatedData['email'] = email?.trim();
                        }
                        if (company?.trim() != widget.lead.company?.trim()) {
                          updatedData['company'] = company?.trim();
                        }
                        if (phone?.trim() != widget.lead.phonenumber?.trim()) {
                          updatedData['phonenumber'] = phone?.trim();
                        }
                        if (address?.trim() != widget.lead.address?.trim()) {
                          updatedData['address'] = address?.trim();
                        }
                        if (city?.trim() != widget.lead.city?.trim()) {
                          updatedData['city'] = city?.trim();
                        }
                        if (zipCode?.trim() != widget.lead.zip?.trim()) {
                          updatedData['zip'] = zipCode?.trim();
                        }
                        if (country?.trim() != widget.lead.country?.trim()) {
                          updatedData['country'] = country?.trim();
                        }
                        if (stateController.text.trim() != widget.lead.state?.trim()) {
                          updatedData['state'] = stateController.text.trim();
                        }

                        // Handle password if "Send SET password email" is not selected
                        if (!sendSetPasswordEmail &&
                            passwordController.text.isNotEmpty) {
                          updatedData['password'] = passwordController.text;
                        }

                        // Additional options
                        updatedData['sendSetPasswordEmail'] = sendSetPasswordEmail;
                        updatedData['doNotSendWelcomeEmail'] = doNotSendWelcomeEmail;
                        updatedData['leadid'] = widget.lead.id;
                        // Check if any data has changed
                        final formData = FormData.fromMap(updatedData);
                        if (updatedData.isNotEmpty) {
                          try {
                            final (bool status, Map<String, dynamic> response, String? message) =
                            await ApiService.addLeads(formData);

                            if (status) {
                              infoLog('Success: ${message}');
                              // Show success message or navigate
                            } else {
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
    );
  }
}
