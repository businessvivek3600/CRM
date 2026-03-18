import 'dart:io';

import 'package:crm/Models/leads_model.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:crm/widgets/date_formation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../services/api_services.dart';

class AddNotesTab extends StatefulWidget {
  const AddNotesTab({super.key, required this.noteData, required this.lead});
  final List<NoteData> noteData;
  final Lead lead;

  @override
  State<AddNotesTab> createState() => _AddNotesTabState();
}

class _AddNotesTabState extends State<AddNotesTab> {
  String selectedStatus = "I have not contacted this lead";
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDateTime;
  bool isSubmitting = false;
  String? editingNoteId;

  Future<void> _pickDateTime(StateSetter setModalState) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedDateTime != null
            ? TimeOfDay.fromDateTime(selectedDateTime!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setModalState(() {
          selectedDateTime = combinedDateTime;
          dateTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }
  void _showAddNoteBottomSheet() {

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => _buildBottomSheet(),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildBottomSheet(),
      );
    }
  }
  Widget _buildBottomSheet() {

    return StatefulBuilder(
      builder: (context, setModalState) {

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 10,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// drag handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.note_alt_outlined),
                      8.width,
                      Text("Add Note", style: boldTextStyle(size: 18)),
                    ],
                  ),

                  20.height,

                  /// NOTE FIELD
                  TextFormField(
                    controller: noteController,
                    maxLines: 4,
                    validator: (value) =>
                    value!.isEmpty ? "Note description is required." : null,
                    decoration: InputDecoration(
                      hintText: "Write a note...",
                      filled: true,
                      fillColor: CRMColors.surface,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),

                  16.height,

                  /// STATUS
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CRMColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [

                        RadioListTile(
                          title: const Text("Contacted this lead"),
                          value: "I got in touch with this lead",
                          groupValue: selectedStatus,
                          activeColor: CRMColors.primary,
                          onChanged: (v) => setModalState(() {
                            selectedStatus = v!;
                          }),
                        ),

                        RadioListTile(
                          title: const Text("Not contacted yet"),
                          value: "I have not contacted this lead",
                          groupValue: selectedStatus,
                          activeColor: CRMColors.primary,
                          onChanged: (v) => setModalState(() {
                            selectedStatus = v!;
                          }),
                        ),
                      ],
                    ),
                  ),

                  if (selectedStatus == "I got in touch with this lead") ...[

                    16.height,

                    TextFormField(
                      controller: dateTimeController,
                      readOnly: true,
                      onTap: () => _pickPlatformDate(setModalState),
                      decoration: InputDecoration(
                        hintText: "Select contact date",
                        suffixIcon: const Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: CRMColors.surface,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],

                  24.height,

                  /// SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CRMColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {

                        if (!_formKey.currentState!.validate()) return;

                        FocusScope.of(context).unfocus(); // important fix

                        setModalState(() => isSubmitting = true);

                        final data = {
                          'rel_id': widget.lead.id.toString(),
                          'lead_note_description': noteController.text,
                          'contacted_today':
                          selectedStatus == "I got in touch with this lead" ? "1" : "0",
                          'custom_contact_date': selectedDateTime?.toString() ?? "",
                        };

                        final (status, response, message) =
                        await ApiService.addNote(data);

                        setModalState(() => isSubmitting = false);

                        if (response["status"] == true) {

                          final newNoteData =
                          (response['data'] as List)
                              .map((e) => NoteData.fromJson(e))
                              .toList();

                          setState(() {
                            widget.noteData.insertAll(0, newNoteData);
                            noteController.clear();
                            dateTimeController.clear();
                            selectedStatus = "I have not contacted this lead";
                          });

                          FocusScope.of(context).unfocus(); // fix
                          Navigator.pop(context);            // close sheet

                          toast(response['message']);
                        }
                      },
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Note",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),

                  10.height
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _pickPlatformDate(StateSetter setModalState) async {

    if (Platform.isIOS) {

      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 300,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (date) {

              setModalState(() {

                selectedDateTime = date;

                dateTimeController.text =
                    DateFormat('yyyy-MM-dd HH:mm').format(date);

              });

            },
          ),
        ),
      );

    } else {

      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate == null) return;

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime == null) return;

      final combined = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setModalState(() {

        selectedDateTime = combined;

        dateTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(combined);

      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Notes History",
                          style: boldTextStyle(size: 14, color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                16.height,
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.noteData.length,
                  separatorBuilder: (_, __) => 12.height,
                  itemBuilder: (context, index) {
                    widget.noteData
                        .sort((a, b) => b.dateadded.compareTo(a.dateadded));
                    final note = widget.noteData[index];
                    return _buildNoteItem(note, index);
                  },
                ),
              ],
            ),
          ),
        ),

        /// BOTTOM ACTION CONTAINER
        editingNoteId == null
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 10, spreadRadius: 1)
                  ],
                ),
                child: InkWell(
                  onTap: _showAddNoteBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: CRMColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: CRMColors.primary.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: CRMColors.primary.withOpacity(0.15),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.note_add,
                              size: 18, color: CRMColors.primary),
                        ),
                        12.width,
                        Expanded(
                            child: Text("Add a new note...",
                                style: boldTextStyle(size: 14))),
                        const Icon(Icons.arrow_forward_ios,
                            size: 14, color: CRMColors.primary),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildNoteItem(NoteData note, int index) {
    final TextEditingController descriptionController =
        TextEditingController(text: note.description);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CRMColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: CRMColors.surface,
                backgroundImage: note.smallImage.isNotEmpty
                    ? NetworkImage(note.smallImage)
                    : null,
                child: note.smallImage.isEmpty
                    ? Text(
                        note.firstname.isNotEmpty
                            ? note.firstname[0].toUpperCase()
                            : '',
                        style: boldTextStyle(color: CRMColors.primary))
                    : null,
              ),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${note.firstname} ${note.lastname}',
                        style: boldTextStyle(size: 14)),
                    Text("Note added: ${formatDate(note.dateadded)}",
                        style: secondaryTextStyle(size: 11)),
                  ],
                ),
              ),
              if (note.editDelete == 1)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) => _handleMenuAction(value, note, index),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: "edit", child: Text("Edit")),
                    const PopupMenuItem(
                        value: "delete",
                        child: Text("Delete",
                            style: TextStyle(color: Colors.red))),
                  ],
                )
            ],
          ),
          12.height,
          editingNoteId == note.id
              ? Column(
                  children: [
                    TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder())),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              editingNoteId = null;
                            });
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final editData = {
                              'rel_id': widget.lead.id,
                              'lead_note_description':
                                  descriptionController.text,
                              'id': note.id
                            };
                            final (status, data, msg) =
                                await ApiService.editNote(editData);
                            if (status) {
                              setState(() {
                                note.description = descriptionController.text;
                                editingNoteId = null;
                              });
                            }
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    )
                  ],
                )
              : Text(note.description, style: secondaryTextStyle()),
        ],
      ),
    );
  }

  void _handleMenuAction(String value, NoteData note, int index) {
    if (value == "edit") {
      setState(() {
        editingNoteId = note.id;
      });
    }
    if (value == "delete") {
      showConfirmDialogCustom(
        context,
        title: "Delete Note?",
        onAccept: (c) async {
          final (status, data, msg) =
              await ApiService.deleteNote({'id': note.id});
          if (data["status"]) setState(() => widget.noteData.removeAt(index));
        },
      );
    }
  }
}
