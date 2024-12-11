import 'package:country_state_picker/components/index.dart';
import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../../constants/app_constants.dart';
import '../../../../../../utils/text_field.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  String? state;
  String? country;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Customer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(

                unselectedLabelColor: AppConst.defaultPrimaryColor,
                indicatorColor:waitingColor,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Legal Company Name',
                            hint: 'Legal Company Name',
                          ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'VAT Number',
                          ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Phone',
                            hint: 'Enter Phone Number',
                          ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Website',
                            hint: 'Enter Website URL',
                          ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Address',
                            hint: 'Enter Address',
                          ),
                          const SizedBox(height: 20),
                          CountryStatePicker(
                            inputDecoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor), // Primary color
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(0.6)), // Primary color with opacity
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor), // Primary color border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor), // Focused state border color
                              ),
                              focusColor: Theme.of(context).primaryColor, // Focus color
                              hoverColor: Theme.of(context).primaryColor, // Hover color
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
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Zip Code',
                            hint: 'Enter Zip Code',
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (country != null && state != null) {
                                // Submit billing details logic
                                debugPrint('Country: $country, State: $state');
                              } else {
                                // Show error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a country and state.'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Billing Details Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Billing Street',
                            hint: 'Billing Street',
                          ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Billing City',
                            hint: 'Billing City',
                          ),
                          // const SizedBox(height: 20),
                          // const CommonTextField(
                          //   label: 'Billing State',
                          //   hint: 'Billing State'
                          // ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Billing Zip',
                            hint: 'Billing Zip',
                          ),
                          const SizedBox(height: 20),
                          CountryStatePicker(
                            inputDecoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor), // Primary color
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(0.6)), // Primary color with opacity
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor), // Primary color border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor), // Focused state border color
                              ),
                              focusColor: Theme.of(context).primaryColor, // Focus color
                              hoverColor: Theme.of(context).primaryColor, // Hover color
                            ),
                            // countryLabel: const Label(title: "Country"),
                            // stateLabel: const Label(title: "State"),
                            onCountryChanged: (ct) => setState(() {
                              country = ct;
                              state = null;
                            }),
                            onStateChanged: (st) => setState(() {
                              state = st;
                            }),
                            countryHintText: "Select Billing Country",
                            stateHintText: "Billing State",
                            noStateFoundText: "No State Found",
                          ),
                          SizedBox(height: 20),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Shipping Street',
                            hint: 'Shipping Street',
                          ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Shipping City',
                            hint: 'Shipping City',
                          ),
                          // const SizedBox(height: 20),
                          // const CommonTextField(
                          //   label: 'Billing State',
                          //   hint: 'Billing State'
                          // ),
                          const SizedBox(height: 20),
                          const CommonTextField(
                            label: 'Shipping Zip',
                            hint: 'Shipping Zip',
                          ),
                          const SizedBox(height: 20),
                          CountryStatePicker(
                            inputDecoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor), // Primary color
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(0.6)), // Primary color with opacity
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor), // Primary color border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor), // Focused state border color
                              ),
                              focusColor: Theme.of(context).primaryColor, // Focus color
                              hoverColor: Theme.of(context).primaryColor, // Hover color
                            ),
                            // countryLabel: const Label(title: "Country"),
                            // stateLabel: const Label(title: "State"),
                            onCountryChanged: (ct) => setState(() {
                              country = ct;
                              state = null;
                            }),
                            onStateChanged: (st) => setState(() {
                              state = st;
                            }),
                            countryHintText: "Select Shipping Country",
                            stateHintText: "Shipping State",
                            noStateFoundText: "No State Found",
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (country != null && state != null) {
                                // Submit billing details logic
                                debugPrint('Country: $country, State: $state');
                              } else {
                                // Show error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a country and state.'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
