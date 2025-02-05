import 'dart:convert';
import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/store/lead_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';

import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/toastification/toastification.dart';

class EditLead extends StatefulWidget {
  const EditLead({super.key, required this.lead});
  final Lead lead;
  @override
  State<EditLead> createState() => _EditLeadState();
}

class _EditLeadState extends State<EditLead> {
  late List<String> _dropdownItems = [];
  String? _selectedEmployeeId;
  String? _selectedItem;
  String? _selectedStatusId;
  ValueNotifier<List<Country>> countries = ValueNotifier<List<Country>>([]);

  List<String> availableTags = [];
  final List<String> _dropDownTagId = [];
  List<String> selectedTags = [];
  String? _statusSelectedItem;
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
  String? state;
  String? country;
  @override
  @override
  void initState() {
    super.initState();
    infoLog("inital status id ==========${widget.lead.status}");

    // Initialize controllers with lead data
    nameController = TextEditingController(text: widget.lead.name);
    leadValueController = TextEditingController(
      text: widget.lead.leadValue != null
          ? widget.lead.leadValue.toString()
          : '0',
    );
    positionController = TextEditingController(text: widget.lead.title);
    emailController = TextEditingController(text: widget.lead.email);
    websiteController = TextEditingController(text: widget.lead.website);
    companyController = TextEditingController(text: widget.lead.company);
    addressController = TextEditingController(text: widget.lead.address);
    cityController = TextEditingController(text: widget.lead.city);
    zipController = TextEditingController(text: widget.lead.zip);
    stateController = TextEditingController(text: widget.lead.state);
    phoneController = TextEditingController(text: widget.lead.phonenumber);
    descriptionController =
        TextEditingController(text: widget.lead.description);

    // Initialize dropdowns
    _selectedItem =
        leadStore.leadSource.any((source) => source.id == widget.lead.source)
            ? widget.lead.source
            : null;
    _statusSelectedItem =
        leadStore.leadStatus.any((status) => status.id == widget.lead.status)
            ? widget.lead.status
            : null;
    _selectedEmployeeId =
        leadStore.staff.any((staff) => staff.staffId == widget.lead.assigned)
            ? widget.lead.assigned
            : null;

    // Initialize tags
    selectedTags = widget.lead.tags!.map((tag) => tag.name).toList();
    _dropDownTagId.addAll(widget.lead.tags!.map((tag) => tag.id));

    // Initialize country and state
    // Validate country against the available countries in leadStore
    country = leadStore.country
            .any((country) => country.countryId == widget.lead.country)
        ? widget.lead.country
        : null;
    state = widget.lead.state;

    // Handle last contact
    if (widget.lead.lastcontact != null) {
      try {
        DateTime lastContactDate = DateTime.parse(widget.lead.lastcontact!);
        lastContactController = TextEditingController(
          text: DateFormat('yyyy-MM-dd h:mm a').format(lastContactDate),
        );
      } catch (e) {
        lastContactController =
            TextEditingController(text: widget.lead.lastcontact);
      }
    } else {
      lastContactController = TextEditingController();
    }

    setState(() {
      _dropdownItems =
          leadStore.leadSource.map((source) => source.name).toList();
    });
  }


  String? getLeadSourceId(String name) {
    try {
      return leadStore.leadSource
          .firstWhere((source) => source.name == name)
          .id;
    } catch (e) {
      return null;
    }
  }
  String? getLeadSourceName(String? id) {

    try {
      return leadStore.leadSource
          .firstWhere((source) => source.id == id)
          .name;
    } catch (e) {
      return null;
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
  String? getLeadStatusName(String? id) {

    try {
      return leadStore.leadStatus
          .firstWhere((status) => status.id == id)
          .name;
    } catch (e) {
      return null;
    }
  }
  String? getLeadStaffId(String name) {
    try {
      return leadStore.staff
          .firstWhere((status) => "${status.firstName} ${status.lastName}" == name)
          .staffId;
    } catch (e) {
      return null; // Return null if the name is not found
    }
  }
  String? getLeadStaffName(String? id) {

    try {
      final staff =  leadStore.staff
          .firstWhere((status) => status.staffId == id);
      return '${staff.firstName} ${staff.lastName}';
    } catch (e) {
      return null;
    }
  }
  Future<void> _selectLastContactDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final DateTime fullDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // Format the date and time as desired
          final formattedDateTime =
              DateFormat('yyyy-MM-dd h:mm a').format(fullDateTime);
          lastContactController.text = formattedDateTime;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Update Leads',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Scrollable form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomDropdown(
                      hint: 'Select Source',
                      items: leadStore.leadSource.map((e) => e.name).toList(),
                      selectedValue: getLeadSourceName(_selectedItem), // Convert ID to name for display
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = getLeadSourceId(value ?? "");
                          errorLog("selected Source id -----$_selectedItem");
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please pick a source for the lead';
                        }
                        return null;
                      }
                  ),


                  const SizedBox(height: 15),
                  CustomDropdown(
                      hint: 'Select Status',
                      items: leadStore.leadStatus.map((e) => e.name).toList(),
                      selectedValue: getLeadStatusName(_statusSelectedItem), // Convert ID to name for display
                      onChanged: (value) {
                        setState(() {
                          _statusSelectedItem = getLeadStatusId(value ?? "");
                          errorLog("selected status id -----$_statusSelectedItem");
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
                      items: leadStore.staff.map((e) => "${e.firstName} ${e.lastName}").toList(),
                      selectedValue: getLeadStaffName( _selectedEmployeeId), // Convert ID to name for display
                      onChanged: (value) {
                        setState(() {
                          _selectedEmployeeId = getLeadStaffId(value ?? "");
                          errorLog("selected employee id -----$_selectedEmployeeId");
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
                                  int index = selectedTags.indexOf(tag);
                                  selectedTags.removeAt(index);
                                  _dropDownTagId.removeAt(index);
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
                                errorLog("tag value---$value");
                                if (!selectedTags.contains(value)) {
                                  selectedTags.add(value); // Add tag name directly
                                }
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        onPressed: () {
                          _showAddTagDialog();
                        },
                      ),
                    ],
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
                  CustomDropdown(
                    hint: 'Select Country',
                    items: leadStore.country.map((item) => item.shortName).toList(),
                    selectedValue: leadStore.country
                        .firstWhere((item) => item.countryId == country, orElse: () => leadStore.country.first)
                        .shortName,
                    onChanged: (value) {
                      setState(() {
                        country = leadStore.country
                            .firstWhere((item) => item.shortName == value)
                            .countryId;
                        state = null; // Reset state when a new country is selected
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
                    label: 'State',
                    hint: 'Enter State',
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
                  CommonTextField(
                    controller: lastContactController,
                    label: 'Last Contact',
                    hint: 'Select Last Contact Date',
                    suffix: Icon(
                      Icons.calendar_month_rounded,
                      color: primaryColor,
                      size: 18,
                    ),
                    onTap: () => _selectLastContactDate(context),
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
          onPressed: () async {
            bool isFieldUpdated(String currentValue, String? initialValue) {
              return currentValue != initialValue;
            }

            // Create form data
            FormData formData = FormData.fromMap({
              "id": widget.lead.id,
              'name':
                  isFieldUpdated(nameController.text, widget.lead.name)
                      ? nameController.text
                      : widget.lead.name,
              'lead_value': isFieldUpdated(leadValueController.text,
                      (widget.lead.leadValue ?? "0.00") as String?)
                  ? leadValueController.text
                  : widget.lead.leadValue ?? "",
              'title':
                  isFieldUpdated(positionController.text, widget.lead.title)
                      ? positionController.text
                      : widget.lead.title ?? "",
              'email': isFieldUpdated(emailController.text, widget.lead.email)
                  ? emailController.text
                  : widget.lead.email ?? "",
              'website':
                  isFieldUpdated(websiteController.text, widget.lead.website)
                      ? websiteController.text
                      : widget.lead.website ?? "",
              'phonenumber':
                  isFieldUpdated(phoneController.text, widget.lead.phonenumber)
                      ? phoneController.text
                      : widget.lead.phonenumber ?? "",
              'company':
                  isFieldUpdated(companyController.text, widget.lead.company)
                      ? companyController.text
                      : widget.lead.company ?? "",
              'address':
                  isFieldUpdated(addressController.text, widget.lead.address)
                      ? addressController.text
                      : widget.lead.address ?? "",
              'city': isFieldUpdated(cityController.text, widget.lead.city)
                  ? cityController.text
                  : widget.lead.city ?? "",
              'zip': isFieldUpdated(zipController.text, widget.lead.zip)
                  ? zipController.text
                  : widget.lead.zip ?? "",
              'state': isFieldUpdated(stateController.text, widget.lead.state)
                  ? stateController.text
                  : widget.lead.state ?? "",
              'country':
                  isFieldUpdated(country ?? " ", widget.lead.country)
                      ? country
                      : widget.lead.country,
              'source': _selectedItem ?? widget.lead.source,
              'status': _statusSelectedItem ?? widget.lead.status,
              'assigned': _selectedEmployeeId ?? widget.lead.assigned,
              'tags': selectedTags.isNotEmpty
                  ? jsonEncode(
                  selectedTags)
                  : widget.lead.tags!.map((tag) => tag.id).toList(),
              'description': isFieldUpdated(
                      descriptionController.text, widget.lead.description)
                  ? descriptionController.text
                  : widget.lead.description ?? "",
              'lastcontact': isFieldUpdated(
                      lastContactController.text, widget.lead.lastcontact ?? '')
                  ? lastContactController.text
                  : widget.lead.lastcontact ?? "",
            });
            try {
              final (
              bool status,
              Map<String, dynamic> response,
              String? message
              ) = await ApiService.addLeads(formData);
              infoLog("💬 -----${response['status']}");
              if (response['status'] == true) {
                Lead lead = Lead.fromJson(response['data'][0]);
                toastLong(response['message'], gravity: ToastGravity.TOP,bgColor: completedColor,textColor: Colors.white,);
                TF.success;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LeadDetails(lead: lead),));

              }  else {
             toast(message, gravity: ToastGravity.TOP, bgColor: Colors.red, textColor: Colors.white);
             infoLog('Error: $status - ');
           }
            } catch (e) {
              infoLog('Exception: $e');
              // Handle network or other errors
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryPrimaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 12),
          ),
          child: const Text(
            'Update',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }
  void _showAddTagDialog() {
    TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Tag"),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(hintText: "Enter tag name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
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
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}


