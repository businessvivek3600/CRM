import 'package:country_state_picker/components/index.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/constants/app_constants.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class UpdateCustomer extends StatefulWidget {
  const UpdateCustomer({super.key, required Customer customer});

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  String? state;
  String? country;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Update Customer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            // TabBar
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
            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  // Profile Tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const CommonTextField(
                            label: 'Legal Company Name',
                            hint: 'Legal Company Name',
                          ),
                          const SizedBox(height: 15),
                          const CommonTextField(
                            label: 'VAT Number',
                          ),
                          const SizedBox(height: 15),
                          const CommonTextField(
                            label: 'Phone',
                            hint: 'Enter Phone Number',
                          ),
                          const SizedBox(height: 15),
                          const CommonTextField(
                            label: 'Website',
                            hint: 'Enter Website URL',
                          ),
                          const SizedBox(height: 15),
                          const CommonTextField(
                            label: 'Address',
                            hint: 'Enter Address',
                          ),
                          const SizedBox(height: 15),
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
                              focusedBorder: OutlineInputBorder(
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
                            noStateFoundText: "No State Found",
                          ),
                          const SizedBox(height: 15),
                          const CommonTextField(
                            label: 'Zip Code',
                            hint: 'Enter Zip Code',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Billing Details Tab (example placeholder)
                  SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // const SizedBox(height: 15),
                            const CommonTextField(
                              label: 'Billing Street',
                              hint: 'Billing Street',
                            ),
                            const SizedBox(height: 15),
                            const CommonTextField(
                              label: 'Billing City',
                              hint: 'Billing City',
                            ),
                            // const SizedBox(height: 15),
                            // const CommonTextField(
                            //   label: 'Billing State',
                            //   hint: 'Billing State'
                            // ),
                            const SizedBox(height: 15),
                            const CommonTextField(
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
                            SizedBox(height: 15),
                            const SizedBox(height: 15),
                            const CommonTextField(
                              label: 'Shipping Street',
                              hint: 'Shipping Street',
                            ),
                            const SizedBox(height: 15),
                            const CommonTextField(
                              label: 'Shipping City',
                              hint: 'Shipping City',
                            ),
                            // const SizedBox(height: 15),
                            // const CommonTextField(
                            //   label: 'Billing State',
                            //   hint: 'Billing State'
                            // ),
                            const SizedBox(height: 15),
                            const CommonTextField(
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
                debugPrint('Country: $country, State: $state');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a country and state.'),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }
}
