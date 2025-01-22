import 'dart:convert';

import 'package:country_state_picker/components/index.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:crm/constants/app_constants.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/extensions.dart';
import 'package:crm/utils/text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';

class AddLeads extends StatefulWidget {
  const AddLeads({super.key});

  @override
  State<AddLeads> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddLeads> {
  String? _selectedSourceId;
  String? _selectedEmployeeId;
  String? _selectedStatusId;

  final List<String> _dropDownTagId = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController leadValueController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController lastContactController = TextEditingController();
  String? state;
  String? country;
  bool isPublic = false;
  bool isContactNow = false;
  List<String> availableTags = [];

  List<String> selectedTags = [];
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode leadValueFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode websiteFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode companyFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode zipFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  // Rest of your variables...

  @override
  void dispose() {
    // Dispose of all focus nodes
    nameFocusNode.dispose();
    leadValueFocusNode.dispose();
    positionFocusNode.dispose();
    emailFocusNode.dispose();
    websiteFocusNode.dispose();
    phoneFocusNode.dispose();
    companyFocusNode.dispose();
    cityFocusNode.dispose();
    zipFocusNode.dispose();
    addressFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

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
                    value: _selectedSourceId,
                    items: leadStore.leadSource
                        .map((item) => DropdownMenuItem<String>(
                              value: item.id,
                              child: Text(item.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSourceId = value;
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
                  DropdownButtonFormField<String>(
                    value: _selectedStatusId,
                    items: leadStore.leadStatus
                        .map((item) => DropdownMenuItem<String>(
                              value: item.id,
                              child: Text(item.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatusId = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _selectedEmployeeId,
                    items: leadStore.staff
                        .map((item) => DropdownMenuItem<String>(
                              value: item.staffId,
                              child: Text("${item.firstName} ${item.lastName}"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEmployeeId = value;
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
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.local_offer,
                        size: 18,
                      ),
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
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                setState(() {
                                  // Remove the tag name and its corresponding ID
                                  int index = selectedTags.indexOf(tag);
                                  selectedTags.removeAt(index);
                                  _dropDownTagId.removeAt(index);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 5),
                  DropdownButton<String>(
                    hint: const Text("Select a tag"),
                    isExpanded: true,
                    value: null,
                    items: leadStore.tags.map((tag) {
                      return DropdownMenuItem<String>(
                        value: tag.id,
                        child: Text(tag.name),
                      );
                    }).toList(),
                    onChanged: (String? tagId) {
                      if (tagId != null) {
                        // Find the tag corresponding to the selected ID
                        Tag? selectedTag = leadStore.tags.firstWhere(
                          (tag) => tag.id == tagId,
                          orElse: null,
                        );

                        if (!_dropDownTagId.contains(selectedTag.id)) {
                          setState(() {
                            // Add the selected tag's ID and name
                            _dropDownTagId.add(selectedTag.id);
                            selectedTags.add(selectedTag.name);
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: nameController,
                    label: 'Name',
                    hint: 'Enter Your Name',
                    focusNode: nameFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(leadValueFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: leadValueController,
                    label: 'Lead Value',
                    hint: 'Lead Value',
                    focusNode: leadValueFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(positionFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: positionController,
                    label: 'Position',
                    hint: 'Position',
                    focusNode: positionFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(emailFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Enter Your Email',
                    focusNode: emailFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(websiteFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: websiteController,
                    label: 'Website',
                    hint: 'Enter Website Name',
                    focusNode: websiteFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(phoneFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: phoneController,
                    label: 'Phone',
                    hint: 'Enter Phone Number',
                    focusNode: phoneFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(companyFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: companyController,
                    label: 'Company',
                    hint: 'Enter Company Name',
                    focusNode: companyFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(cityFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double
                        .infinity, // Allows dropdown to take full available width
                    child: DropdownButtonFormField<String>(
                      value: leadStore.country
                          .firstWhereOrNull((v) => v.countryId == country)
                          ?.countryId,
                      isExpanded: true, // Prevent overflow
                      items: leadStore.country
                          .map((item) => DropdownMenuItem<String>(
                                value: item.countryId,
                                child: Text(item.shortName),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          country = value;
                          state = null;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Country',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
                    controller: cityController,
                    label: 'City',
                    hint: 'Enter Your City',
                    focusNode: cityFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(zipFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: zipController,
                    label: 'Zip Code',
                    hint: 'Enter Zip Code',
                    focusNode: zipFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(addressFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: addressController,
                    label: 'Address',
                    hint: 'Enter Address',
                    focusNode: addressFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(descriptionFocusNode);
                    },
                  ),
                  const SizedBox(height: 15),
                  CommonTextField(
                    controller: descriptionController,
                    maxLines: 3,
                    label: 'Description',
                    hint: 'Tell us more about the project',
                    focusNode: descriptionFocusNode,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          value:
                              isPublic, // Declare this boolean variable in the state
                          onChanged: (bool? value) {
                            setState(() {
                              isPublic = value!;
                            });
                          },
                          title: const Text(
                            'Public',
                            style: TextStyle(fontSize: 14),
                          ),
                          activeColor: acceptColor,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value:
                              isContactNow, // Declare this boolean variable in the state
                          onChanged: (bool? value) {
                            setState(() {
                              isContactNow = value!;
                            });
                          },
                          title: const Text(
                            'Contacted Today',
                            style: TextStyle(fontSize: 14),
                          ),
                          activeColor: acceptColor,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      infoLog("________Tags $_dropDownTagId");
                      // Create form data
                      FormData formData = FormData.fromMap({
                        'name': nameController.text.trim(),
                        'lead_value': leadValueController.text.trim(),
                        'title': positionController.text.trim(),
                        'email': emailController.text.trim(),
                        'website': websiteController.text.trim(),
                        'phonenumber': phoneController.text.trim(),
                        'company': companyController.text.trim(),
                        'address': addressController.text.trim(),
                        'city': cityController.text.trim(),
                        'zip': zipController.text.trim(),
                        'state': stateController.text.trim(),
                        'country': country,
                        'is_public': isPublic ? 1 : 0,
                        'contacted_today': isContactNow ? 1 : 0,
                        'source': _selectedSourceId,
                        'status': _selectedStatusId,
                        'assigned': _selectedEmployeeId,
                        'tags':
                            jsonEncode(_dropDownTagId), // Assuming IDs for tags
                        'description': descriptionController.text.trim(),
                      });

                      try {
                        errorLog("--------${formData.fields}");

                        // Make API call (replace `apiClient.post` with your actual API call method)
                        final (
                          bool status,
                          Map<String, dynamic> response,
                          String? message
                        ) = await ApiService.addLeads(formData);

                        if (status) {
                          print('Success: ${message}');
                          // Handle success (e.g., show a success message or navigate)
                        } else {
                          print('Error: ${status} - ${response}');
                          // Handle API error
                        }
                      } catch (e) {
                        print('Exception: $e');
                        // Handle network or other errors
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 135,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
