import 'dart:convert';
import 'dart:io';

import 'package:crm/store/lead_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';

import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/toastification/toastification.dart';
import '../../../widgets/common_text_field.dart';
import 'leads_details.dart';

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
    DateTime now = DateTime.now();

    if (Platform.isIOS) {
      /// iOS STYLE PICKER
      DateTime tempPicked = now;

      await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: CRMColors.border),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Select Last Contact",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text("Done"),
                        onPressed: () {
                          final formatted = DateFormat('yyyy-MM-dd h:mm a').format(tempPicked);
                          setState(() {
                            lastContactController.text = formatted;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: now,
                    mode: CupertinoDatePickerMode.dateAndTime,
                    use24hFormat: false,
                    onDateTimeChanged: (value) {
                      tempPicked = value;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      /// ANDROID MATERIAL PICKERS
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: CRMColors.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: CRMColors.primary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          final DateTime fullDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          final formattedDateTime =
          DateFormat('yyyy-MM-dd h:mm a').format(fullDateTime);

          setState(() {
            lastContactController.text = formattedDateTime;
          });
        }
      }
    }
  }
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Edit Lead',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          leading: const BackButton(color: Colors.black),
        ),

        resizeToAvoidBottomInset: true,

        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    /// SOURCE
                    CustomDropdown(
                      hint: 'Select Source',
                      items: leadStore.leadSource.map((e) => e.name).toList(),
                      selectedValue: getLeadSourceName(_selectedItem),
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = getLeadSourceId(value ?? "");
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    /// STATUS
                    CustomDropdown(
                      hint: 'Select Status',
                      items: leadStore.leadStatus.map((e) => e.name).toList(),
                      selectedValue: getLeadStatusName(_statusSelectedItem),
                      onChanged: (value) {
                        setState(() {
                          _statusSelectedItem = getLeadStatusId(value ?? "");
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    /// ASSIGNED
                    CustomDropdown(
                      hint: 'Assigned Lead',
                      items: leadStore.staff
                          .map((e) => "${e.firstName} ${e.lastName}")
                          .toList(),
                      selectedValue: getLeadStaffName(_selectedEmployeeId),
                      onChanged: (value) {
                        setState(() {
                          _selectedEmployeeId = getLeadStaffId(value ?? "");
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    /// TAGS SECTION (same UI as Add Lead)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: CRMColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: CRMColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Row(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 18,
                                color: CRMColors.textSecondary,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Tags",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CRMColors.textPrimary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// TAG CHIPS
                          if (selectedTags.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: selectedTags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CRMColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: CRMColors.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        tag,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: CRMColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            int index = selectedTags.indexOf(tag);
                                            selectedTags.removeAt(index);
                                            _dropDownTagId.removeAt(index);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: CRMColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                          if (selectedTags.isNotEmpty)
                            const SizedBox(height: 10),

                          /// TAG DROPDOWN
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                  hint: 'Select or Add Tag',
                                  items: leadStore.tags
                                      .map((e) => e.name)
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      setState(() {
                                        if (!selectedTags.contains(value)) {
                                          selectedTags.add(value);
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(width: 8),

                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: CRMColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Colors.white),
                                  onPressed: _showAddTagDialog,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// FORM FIELDS
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
                      hint: 'Enter Phone Number',
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
                      items: leadStore.country
                          .map((e) => e.shortName)
                          .toList(),
                      selectedValue: (country != null)
                          ? leadStore.country
                          .firstWhere(
                              (item) => item.countryId == country)
                          .shortName
                          : null,
                      onChanged: (value) {
                        setState(() {
                          country = leadStore.country
                              .firstWhere((item) => item.shortName == value)
                              .countryId;
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
                      suffix: const Icon(Icons.calendar_month_rounded),
                      onTap: () => _selectLastContactDate(context),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),

        /// UPDATE BUTTON
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
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
                'lead_value': isFieldUpdated(
                  leadValueController.text,
                  widget.lead.leadValue?.toString() ?? "0.00",
                )
                    ? leadValueController.text
                    : widget.lead.leadValue?.toString() ?? "0.00",
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
                'tags': jsonEncode(
                  selectedTags.isNotEmpty
                      ? selectedTags
                      : widget.lead.tags!.map((tag) => tag.name).toList(),
                ),
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
                if (status) {
                  Lead lead = Lead.fromJson(response['data'][0]);
                  toastLong(response['message'], gravity: ToastGravity.TOP,bgColor: completedColor,textColor: Colors.white,);
                  TF.success;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LeadDetails(lead: widget.lead.id),));

                }  else {
                  toast(message, gravity: ToastGravity.TOP, bgColor: Colors.red, textColor: Colors.white);
                  infoLog('Error: $status - ');
                }
              } catch (e) {
                infoLog('Exception: $e');
                throw Exception(e);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CRMColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Update Lead',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
  }
  void _showAddTagDialog() {
    TextEditingController tagController = TextEditingController();

    if (Platform.isIOS) {
      /// IOS STYLE DIALOG
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return CupertinoAlertDialog(
                title: const Text(
                  "Manage Tags",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                content: Column(
                  children: [

                    const SizedBox(height: 10),

                    /// EXISTING TAGS
                    if (selectedTags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: selectedTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: CRMColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(tag,
                                    style: const TextStyle(fontSize: 13)),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setStateDialog(() {
                                      selectedTags.remove(tag);
                                    });
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    CupertinoIcons.clear,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 12),

                    /// INPUT FIELD
                    CupertinoTextField(
                      controller: tagController,
                      placeholder: "Enter tag name",
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CRMColors.border),
                      ),
                    ),
                  ],
                ),

                actions: [
                  CupertinoDialogAction(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),

                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("Add"),
                    onPressed: () {
                      String newTag = tagController.text.trim();

                      if (newTag.isNotEmpty) {
                        setState(() {
                          if (!selectedTags.contains(newTag)) {
                            selectedTags.add(newTag);
                          }

                          if (!leadStore.tags.any((t) => t.name == newTag)) {
                            leadStore.tags.add(Tag(name: newTag, id: ''));
                          }
                        });
                      }

                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      /// ANDROID MATERIAL DIALOG
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                title: const Text(
                  "Manage Tags",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// EXISTING TAGS
                    if (selectedTags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: CRMColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: CRMColors.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setStateDialog(() {
                                      selectedTags.remove(tag);
                                    });
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    if (selectedTags.isNotEmpty)
                      const SizedBox(height: 14),

                    /// TEXT INPUT
                    TextField(
                      controller: tagController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Enter tag name",
                        filled: true,
                        fillColor: CRMColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: CRMColors.border),
                        ),
                      ),
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CRMColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Add"),
                    onPressed: () {
                      String newTag = tagController.text.trim();

                      if (newTag.isNotEmpty) {
                        setState(() {
                          if (!selectedTags.contains(newTag)) {
                            selectedTags.add(newTag);
                          }

                          if (!leadStore.tags.any((t) => t.name == newTag)) {
                            leadStore.tags.add(Tag(name: newTag, id: ''));
                          }
                        });
                      }

                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }
}


