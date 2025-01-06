import 'package:country_state_picker/components/index.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';

class ConvertToCustomer extends StatefulWidget {
  const ConvertToCustomer({super.key});

  @override
  State<ConvertToCustomer> createState() => _ConvertedToCustomerState();
}

class _ConvertedToCustomerState extends State<ConvertToCustomer> {
  String? state;
  String? country;

  bool isPasswordHidden = true;
  bool sendSetPasswordEmail = false;
  bool doNotSendWelcomeEmail = false;
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Convert to Customer',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeadDetailsScreen(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CommonTextField(
                  label: 'First Name',
                  hint: 'Enter First Name',
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'Last Name ',
                  hint: 'Enter Last Name',
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'Position ',
                  hint: 'Enter Position',
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'Email ',
                  hint: 'Enter Email',
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'Company ',
                  hint: 'Enter Company Name',
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'Phone ',
                  hint: 'Enter Phone Number',
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'Address',
                  hint: 'Enter Address',
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'City',
                  hint: 'Enter City',
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
                    country = ct;
                    state = null;
                  }),
                  onStateChanged: (st) => setState(() {
                    state = st;
                  }),
                  countryHintText: "Select Country",
                  stateHintText: "Select State",
                  noStateFoundText: "No State Found",
                ),
                const SizedBox(height: 15),
                const CommonTextField(
                  label: 'Zip Code',
                  hint: 'Enter Zip Code',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeadDetailsScreen(),
                          ),
                        );
                      },
                      child: const Text("Back to lead"),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Save action
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
