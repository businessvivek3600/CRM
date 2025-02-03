import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/extensions.dart';
import 'package:crm/utils/text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../widgets/custom_dropdown.dart';

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
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
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

  String? selectedSource;

  String? getLeadSourceId(String name) {
    try {
      return leadStore.leadSource
          .firstWhere((source) => source.name == name)
          .id;
    } catch (e) {
      return null; // Return null if the name is not found
    }
  }

  String? getLeadStatusId(String name) {
    try {
      return leadStore.leadStatus
          .firstWhere((status) => status.name == name)
          .id;
    } catch (e) {
      return null; // Return null if the name is not found
    }
  }

  String? getStaffId(String name) {
    try {
      return leadStore.staff
          .firstWhere((staff) => "${staff.firstName} ${staff.lastName}" == name)
          .staffId;
    } catch (e) {
      return null;
    }
  }

  String? getCountryId(String name) {
    try {
      return leadStore.country
          .firstWhere((country) => country.shortName == name)
          .countryId;
    } catch (e) {
      return null; // Return null if the name is not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Add New Lead',
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
              child: Form(
                key: _profileFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus(); // Close the keyboard and dropdown
                      },
                      child: CustomDropdown(
                        hint: 'Select Source',
                        items: leadStore.leadSource.map((e) => e.name).toList(),
                        selectedValue: selectedSource,
                        onChanged: (value) {
                          setState(() {
                            selectedSource = getLeadSourceId(value ?? "");
                            warningLog("Selected Source: $selectedSource");
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please pick a source for the lead';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomDropdown(
                      hint: 'Select Status',
                      items: leadStore.leadStatus.map((e) => e.name).toList(),
                      selectedValue: _selectedStatusId,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusId = getLeadStatusId(value ?? "");
                          warningLog("Selected Status: $_selectedStatusId");
                        });
                      },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please pick a status for the lead';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 15),
                    CustomDropdown(
                      hint: 'Assigned Lead',
                      items: leadStore.staff
                          .map((e) => "${e.firstName} ${e.lastName}")
                          .toList(),
                      selectedValue: _selectedEmployeeId,
                      onChanged: (value) {
                        setState(() {
                          _selectedEmployeeId = getStaffId(value ?? "");
                          warningLog("Selected Staff: $_selectedEmployeeId");
                        });
                      },
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
                            selectedTags.remove(tag);
                          });
                        },
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            hint: 'Select or Add a Tag',
                            items: leadStore.tags.map((e) => e.name).toList(),
                            onChanged: (value) {
                              if (value != null && value.isNotEmpty) {
                                setState(() {
                                  if (!selectedTags.contains(value)) {
                                    selectedTags.add(value); // Add tag name directly
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            _showAddTagDialog(); // Show input dialog for a new tag
                          },
                        ),
                      ],
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
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
                      formatter: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[\d+\-]*$')),
                      ],
                      focusNode: phoneFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(companyFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A valid phone number is required';
                        }
                        return null;
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
                    CustomDropdown(
                      hint: 'Select Country',
                      items: leadStore.country.map((e) => e.shortName).toList(),
                      selectedValue: country,
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
                        FocusScope.of(context)
                            .requestFocus(descriptionFocusNode);
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
                        if (_profileFormKey.currentState!.validate()) {
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
                            'source': selectedSource,
                            'status': _selectedStatusId,
                            'assigned': _selectedEmployeeId,
                            'tags': jsonEncode(
                                selectedTags), // Assuming IDs for tags
                            'description': descriptionController.text.trim(),
                          });

                          try {
                            final (
                              bool status,
                              Map<String, dynamic> response,
                              String? message
                            ) = await ApiService.addLeads(formData);

                            if (status) {
                              toastLong(
                                message ?? "Lead added successfully",
                                gravity: ToastGravity.TOP,
                                bgColor: completedColor,
                                textColor: Colors.white,
                              );
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LeadsScreen(),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(message ?? "Something went wrong!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              print('Error: ${status} - ${response}');
                              // Handle API error
                            }
                          } catch (e) {
                            print('Exception: $e');
                            // Handle network or other errors
                          }
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
          ),
        ],
      ),
    );
  }
  void _showAddTagDialog() {
    TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Tag"),
          content: TextField(
            controller: tagController,
            decoration: InputDecoration(hintText: "Enter tag name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String newTag = tagController.text.trim();
                if (newTag.isNotEmpty) {
                  setState(() {
                    if (!selectedTags.contains(newTag)) {
                      selectedTags.add(newTag);
                    }

                    if (!leadStore.tags.any((tag) => tag.name == newTag)) {
                      leadStore.tags.add(Tag(name: newTag, id: '')); // Add to tag list
                    }
                  });
                }
                Navigator.pop(context); // Close dialog after adding
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

}
