import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm/store/lead_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/app_store.dart';
import '../../../../utils/size_utils.dart';

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

    // Initialize controllers with lead data
    nameController = TextEditingController(text: widget.lead.name ?? '');
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

  List<Map<String, dynamic>> formData = [
    {},
    {},
    {},
    {},
    {},
    {},
  ];
  int activeStep = 0;
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
    warningLog(" LOGIN TOKEN ____________${appStore.token}");
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
                    items: leadStore.leadSource
                        .toSet()
                        .map((item) => DropdownMenuItem<String>(
                              value: item.id,
                              child: Text(item.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                        String sourceId = leadStore.leadSource
                                .firstWhere((source) => source.id == value,
                                    orElse: null)
                                ?.id ??
                            '';
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
                    value: _selectedEmployeeId?.isEmpty ?? true
                        ? null
                        : _selectedEmployeeId,
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
                  Container(
                    width: double
                        .infinity, // Allows dropdown to take full available width
                    child: DropdownButtonFormField<String>(
                      value: country,
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
                          state =
                              null; // Reset state when a new country is selected
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
                  SizedBox(height: 15),
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
            infoLog("________Tags1 $_dropDownTagId");
            infoLog("________Source2$_selectedItem");
            infoLog("________Status4 $_selectedStatusId");
            infoLog("________Employee5 $_selectedEmployeeId");
            bool isFieldUpdated(String currentValue, String? initialValue) {
              return currentValue != initialValue;
            }

            // Create form data
            FormData formData = FormData.fromMap({
              "id": widget.lead.id,
              'name':
                  isFieldUpdated(nameController.text, widget.lead.name ?? '')
                      ? nameController.text
                      : widget.lead.name,
              'lead_value': isFieldUpdated(leadValueController.text,
                      (widget.lead.leadValue ?? 0.00) as String?)
                  ? leadValueController.text
                  : widget.lead.leadValue,
              'title':
                  isFieldUpdated(positionController.text, widget.lead.title!)
                      ? positionController.text
                      : widget.lead.title,
              'email': isFieldUpdated(emailController.text, widget.lead.email!)
                  ? emailController.text
                  : widget.lead.email,
              'website':
                  isFieldUpdated(websiteController.text, widget.lead.website!)
                      ? websiteController.text
                      : widget.lead.website,
              'phonenumber':
                  isFieldUpdated(phoneController.text, widget.lead.phonenumber)
                      ? phoneController.text
                      : widget.lead.phonenumber,
              'company':
                  isFieldUpdated(companyController.text, widget.lead.company)
                      ? companyController.text
                      : widget.lead.company,
              'address':
                  isFieldUpdated(addressController.text, widget.lead.address)
                      ? addressController.text
                      : widget.lead.address,
              'city': isFieldUpdated(cityController.text, widget.lead.city)
                  ? cityController.text
                  : widget.lead.city,
              'zip': isFieldUpdated(zipController.text, widget.lead.zip)
                  ? zipController.text
                  : widget.lead.zip,
              'state': isFieldUpdated(stateController.text, widget.lead.state)
                  ? stateController.text
                  : widget.lead.state,
              'country':
                  isFieldUpdated(country ?? " ", widget.lead.country ?? " ")
                      ? country
                      : widget.lead.country,
              'source': _selectedItem ?? widget.lead.source,
              'status': _selectedStatusId ?? widget.lead.status,
              'assigned': _selectedEmployeeId ?? widget.lead.assigned,
              'tags': selectedTags.isNotEmpty
                  ? jsonEncode(_dropDownTagId)
                  : widget.lead.tags!.map((tag) => tag.id).toList(),
              'description': isFieldUpdated(
                      descriptionController.text, widget.lead.description)
                  ? descriptionController.text
                  : widget.lead.description,
              'lastcontact': isFieldUpdated(
                      lastContactController.text, widget.lead.lastcontact ?? '')
                  ? lastContactController.text
                  : widget.lead.lastcontact,
            });
            warningLog("Entered Form data ---$formData");
            infoLog("________Tags6 $_dropDownTagId");
            infoLog("________Source7$_selectedItem");
            infoLog("________Status8 $_selectedStatusId");
            infoLog("________Employee9 $_selectedEmployeeId");
            try {
              // Print data to console for debugging
              errorLog("--------${formData.fields}");

              // Make API call (replace `apiClient.post` with your actual API call method)
              final (
                bool status,
                Map<String, dynamic> response,
                String? message
              ) = await ApiService.addLeads(formData);

              if (status) {
                print('Success: ${message}');
                Fluttertoast.showToast(
                  msg: message ?? 'Conversion successful!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                );
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
}

Widget bodyMedText(
  String text,
  BuildContext context, {
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
  TextStyle? style,
  Color? color,
  bool? isButton,
  double? fontSize,
  FontWeight? fontWeight,
  double? letterSpacing,
  double? lineHeight,
  TextDecoration? decoration,
  double opacity = 1,
  bool autoSize = false,
  double minFontSize = 12,
}) =>
    autoSize
        ? AutoSizeText(
            text,
            minFontSize: minFontSize,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines ?? 3,
            style: GoogleFonts.ubuntu(
              textStyle: style ??
                  getTheme(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: fontWeight,
                      letterSpacing: letterSpacing,
                      color: (color ??
                          (isButton != null
                              ? (isButton
                                  ? (getTheme(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  : null)
                              : null)),
                      decorationColor: color,
                      fontSize: fontSize,
                      height: lineHeight,
                      fontFamily:
                          getTheme(context).textTheme.bodyMedium?.fontFamily,
                      decoration: decoration)
                ..color?.withOpacity(opacity),
            ),
          )
        : Text(
            text,
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines ?? 3,
            style: GoogleFonts.ubuntu(
              textStyle: style ??
                  getTheme(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: fontWeight,
                      letterSpacing: letterSpacing,
                      color: (color ??
                          (isButton != null
                              ? (isButton
                                  ? (getTheme(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  : null)
                              : null)),
                      decorationColor: color,
                      fontSize: fontSize,
                      height: lineHeight,
                      fontFamily:
                          getTheme(context).textTheme.bodyMedium?.fontFamily,
                      decoration: decoration)
                ..color?.withOpacity(opacity),
            ),
          );
