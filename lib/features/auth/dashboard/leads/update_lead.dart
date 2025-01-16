import 'package:country_state_picker/components/index.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:crm/features/auth/dashboard/leads/leads_details.dart';
import 'package:crm/store/lead_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Models/leads_model.dart';
import '../../../../utils/size_utils.dart';

class EditLead extends StatefulWidget {
  const EditLead({super.key, required this.lead});
  final Lead lead;
  @override
  State<EditLead> createState() => _EditLeadState();
}

class _EditLeadState extends State<EditLead> {
  late  List<String> _dropdownItems = [];
  String? _selectedEmployeeId;
  String? _selectedItem;
  String? _selectedStatusId;
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
  late TextEditingController zipController;
  late TextEditingController phoneController;
  late TextEditingController descriptionController;
  late TextEditingController lastContactController;
  String? state;
  String? country;
  @override
  void initState() {
    super.initState();

    // Initialize controllers with lead data
    nameController = TextEditingController(text: widget.lead.name ?? 'empty');
    leadValueController = TextEditingController(text:"₹ ${widget.lead.leadValue?.toString()}");
    positionController = TextEditingController(text: widget.lead.title);
    emailController = TextEditingController(text: widget.lead.email);
    websiteController = TextEditingController(text: widget.lead.website);
    companyController = TextEditingController(text: widget.lead.company);
    addressController = TextEditingController(text: widget.lead.address);
    cityController = TextEditingController(text: widget.lead.city);
    zipController = TextEditingController(text: widget.lead.zip);
    phoneController = TextEditingController(text: widget.lead.phonenumber);
    descriptionController = TextEditingController(text: widget.lead.description);
    if (widget.lead.lastcontact != null) {
      try {
        DateTime lastContactDate = DateTime.parse(widget.lead.lastcontact!);
        String formattedDateTime = DateFormat('yyyy-MM-dd h:mm a').format(lastContactDate);
        lastContactController = TextEditingController(text: formattedDateTime);
      } catch (e) {
        lastContactController = TextEditingController(text: widget.lead.lastcontact);
      }
    } else {
      lastContactController = TextEditingController();

    }
    country = widget.lead.country;
    state = widget.lead.state;
    setState(() {
      _dropdownItems = leadStore.leadSource.map((source) => source.name).toList();
    });

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
          final formattedDateTime = DateFormat('yyyy-MM-dd h:mm a').format(fullDateTime);
          lastContactController.text = formattedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    infoLog("initial Value -----${widget.lead.name}");
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
                  DropdownButtonFormField<String>(

                    value: _statusSelectedItem,
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
                      labelText: 'Select Status',
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
                    suffix: Icon(Icons.calendar_month_rounded,color: primaryColor,size: 18,),
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
          onPressed: () {},
          child: const Text(
            'Update',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryPrimaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 12),
          ),
        ),
      ),
    );
  }
}
