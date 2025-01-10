import 'package:country_state_picker/components/index.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/size_utils.dart';

class Addleads extends StatefulWidget {
  const Addleads({super.key});

  @override
  State<Addleads> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Addleads> {
  final List<String> _dropdownItems = [
    'Facebook',
    'Google',
    'Instagram',
    'LinkedIn',
    'Pinterest',
    'Reddit',
    'Snapchat',
    'Twitter',
    'Youtube'
  ];
  final List<Map<String, dynamic>> _statusdropdownItems = [
    {'label': 'New Lead', 'color': Colors.blue},
    {'label': 'Contacted', 'color': Colors.green},
    {'label': 'Qualified', 'color': Colors.yellow},
    {'label': 'Negotiating', 'color': Colors.pink},
    {'label': 'Closed - Won', 'color': Colors.green},
    {'label': 'Closed - Lost', 'color': Colors.red},
    {'label': 'Pending', 'color': Colors.orange},
    {'label': 'On Hold', 'color': Colors.grey},
    {'label': 'Reopened', 'color': Colors.purple},
    {'label': 'Converted', 'color': Colors.blue},
    {'label': 'Customer', 'color': Colors.green},
  ];
  String? _selectedItem;
  Map<String, dynamic>? _statusselectedItem;
  TextEditingController nameController = TextEditingController();
  TextEditingController leadValueController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController lastContactController = TextEditingController();
  String? state;
  String? country;
  bool isPublic = false;
  bool isContactNow = false;
  List<String> availableTags = [
    "Android and iOS",
    "application",
    "B2B",
    "Binary",
    "Binary Global Income",
    "Binary MLM Software",
    "Binary plan",
  ];

  List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Add New Leads',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LeadsScreen(),
              ),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: true, // Adjusts UI when keyboard appears
      body: Column(
        children: [
          // Scrollable form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedItem,
                    items: _dropdownItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Source',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: _statusselectedItem,
                    items: _statusdropdownItems.map((item) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: item,
                        child: Text(
                          item['label'],
                          style: TextStyle(
                            color: item['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _statusselectedItem = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Assigned Lead',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _selectedItem,
                    items: _dropdownItems
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Employee',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.local_offer,size: 18,),

                      Text(
                        " Tags",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: selectedTags
                        .map((tag) => Chip(
                      label: Text(tag),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          selectedTags.remove(tag);
                        });
                      },
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 5),
                  DropdownButton<String>(
                    hint: Text("Select a tag"),
                    isExpanded: true,
                    items: availableTags.map((String tag) {
                      return DropdownMenuItem<String>(
                        value: tag,
                        child: Text(tag),
                      );
                    }).toList(),
                    onChanged: (String? tag) {
                      if (tag != null && !selectedTags.contains(tag)) {
                        setState(() {
                          selectedTags.add(tag);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: nameController,
                    label: 'Name',
                    hint: 'Enter Your Name',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: leadValueController,
                    label: 'Lead Value',
                    hint: 'Lead Value',
                    // suffix: Text("₹",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: positionController,
                    label: 'Position',
                    hint: 'Position',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Enter Your Email',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: websiteController,
                    label: 'Website',
                    hint: 'Enter Website Name',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: phoneController,
                    label: 'Phone',
                    hint: 'Enter Website Phone Number',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: companyController,
                    label: 'Company',
                    hint: 'Enter Company Name',
                  ),
                  const SizedBox(height: 15),
                  CountryStatePicker(
                    inputDecoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      hintStyle: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6)),
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
                  CommonTextField(
                    controller: cityController,
                    label: 'City',
                    hint: 'Enter Your City',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: zipController,
                    label: 'Zip Code',
                    hint: 'Enter Zip Code',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: addressController,
                    label: 'Address',
                    hint: 'Enter Address',
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: descriptionController,
                    maxLines: 3,
                    label: 'Description',
                    hint: 'Tell us more about project',
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          value: isPublic, // Declare this boolean variable in the state
                          onChanged: (bool? value) {
                            setState(() {
                              isPublic = value!;
                            });
                          },
                          title: const Text('Public',style: TextStyle(fontSize: 14),),
                          activeColor:acceptColor,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: isContactNow, // Declare this boolean variable in the state
                          onChanged: (bool? value) {
                            setState(() {
                              isContactNow = value!;
                            });
                          },
                          title: const Text('Contacted Today',style: TextStyle(fontSize: 14),),
                          activeColor:acceptColor,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Submit',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryPrimaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 135,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
