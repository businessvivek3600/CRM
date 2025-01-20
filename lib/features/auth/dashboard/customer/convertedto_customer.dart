import 'package:country_state_picker/components/index.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';

import '../../../../Models/leads_model.dart';

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
  String? countryCode;
  String? countryName;

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
    zipCode = widget.lead.zip;
    countryCode = widget.lead.country;
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
                CountryStatePicker(
                  inputDecoration: InputDecoration(
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  countryLabel: const Label(title: "Country"),
                  stateLabel: const Label(title: "State"),
                  onCountryChanged: (ct) => setState(() {
                    countryCode = ct;

                    /// TODO : Uncomment this
                    // countryName =
                    //     CountryPickerUtils.getCountryByIsoCode(ct).name;
                    state = null;
                  }),
                  onStateChanged: (st) => setState(() {
                    state = st;
                  }),
                  countryHintText: countryName ?? "Select Country",
                  stateHintText: state ?? "Select State",
                  noStateFoundText: "No State Found",
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
                      onPressed: () {
                        // Collect updated data
                        final updatedData = <String, dynamic>{};

                        // Compare each field with the initial value and add only changed fields
                        if (firstName != widget.lead.name) {
                          updatedData['name'] = firstName;
                        }
                        if (position != widget.lead.title) {
                          updatedData['title'] = position;
                        }
                        if (email != widget.lead.email) {
                          updatedData['email'] = email;
                        }
                        if (company != widget.lead.company) {
                          updatedData['company'] = company;
                        }
                        if (phone != widget.lead.phonenumber) {
                          updatedData['phonenumber'] = phone;
                        }
                        if (address != widget.lead.address) {
                          updatedData['address'] = address;
                        }
                        if (city != widget.lead.city) {
                          updatedData['city'] = city;
                        }
                        if (zipCode != widget.lead.zip) {
                          updatedData['zip'] = zipCode;
                        }
                        if (countryCode != widget.lead.country) {
                          updatedData['country'] = countryCode;
                        }
                        if (state != widget.lead.state) {
                          updatedData['state'] = state;
                        }

                        // Handle password if "Send SET password email" is not selected
                        if (!sendSetPasswordEmail &&
                            passwordController.text.isNotEmpty) {
                          updatedData['password'] = passwordController.text;
                        }

                        // Additional options
                        updatedData['sendSetPasswordEmail'] =
                            sendSetPasswordEmail;
                        updatedData['doNotSendWelcomeEmail'] =
                            doNotSendWelcomeEmail;

                        // Send updated data to the API
                        if (updatedData.isNotEmpty) {
                          // Call your API method here and pass `updatedData`
                          print('Updated data to send: $updatedData');
                        } else {
                          print('No changes detected');
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
