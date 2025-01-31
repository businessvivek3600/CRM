import 'package:country_codes/country_codes.dart';
import 'package:country_list_pick/country_list_pick.dart';

import 'package:crm/Models/leads_model.dart';
import 'package:crm/features/auth/dashboard/customer/convertedto_customer.dart';
import 'package:crm/features/auth/dashboard/leads/addnotes.dart';
import 'package:crm/features/auth/dashboard/leads/leads_screen.dart';
import 'package:crm/features/auth/dashboard/leads/reminders.dart';
import 'package:crm/features/auth/dashboard/leads/update_lead.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../widgets/date_formation.dart';

class LeadDetails extends StatefulWidget {
  const LeadDetails({Key? key, required this.lead}) : super(key: key);
  final Lead lead;
  @override
  State<LeadDetails> createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  @override
  void initState() {
    // TODO: implement initState
    _selectedCountryName = getCountryNames(widget.lead.country);
    super.initState();
  }

  String _selectedCountryName = '';

  String getCountryNames(String countryCode) {
    final countryList = CountryListPick(
      initialSelection: countryCode,
      onChanged: (CountryCode? code) {
        setState(() {
          _selectedCountryName = code?.name ?? 'Unknown';
        });
      },
    );

    return _selectedCountryName;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryPrimaryColor,
          title: Text(
            '#${widget.lead.id} - ${widget.lead.name.toUpperCase()}',
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeadsScreen(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditLead(
                      lead: widget.lead,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                _showDeleteDialog(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Material(
              color: const Color(0xfffef7ff),
              child: TabBar(
                dividerColor: Colors.black.withOpacity(0.1),
                indicatorSize: TabBarIndicatorSize.tab,

                labelColor: textPrimaryColors,
                unselectedLabelColor: textPrimaryColors.withOpacity(0.6),
                indicatorColor: acceptColor, // Tab indicator color
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Notes'),
                  Tab(text: 'Reminder'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProfileTab(lead: widget.lead), // Includes cards
                  AddNotesTab(
                    noteData: widget.lead.notesData ?? [],
                    lead: widget.lead,
                  ),
                  RemindersTab(
                    remainder: widget.lead.reminders ?? [],
                    lead: widget.lead,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Exclamation Mark Icon with Gradient Background
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Delete Lead",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                const Text(
                  "Are you sure that you want to delete this Lead?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeadsScreen(),
                            ),
                          ); // Close dialog
                          // Add delete functionality here
                           // Close dialog
                          final Map<String, dynamic> deleteLead = {
                            'id': widget.lead.id,
                          };
                          // Call API to delete the note
                          final (
                            bool status,
                            Map<String, dynamic> data,
                            String? message
                          ) = await ApiService.deleteLead(deleteLead);
                          if (status) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Lead deleted successfully!"),
                                backgroundColor: completedColor,
                              ),
                            );
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LeadsScreen(),));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(message ?? "Failed to delete lead"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileTab extends StatefulWidget {
  final Lead lead;

  const ProfileTab({required this.lead, super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    final status = leadStore.getStatusById(widget.lead.status);
    final source = leadStore.getSourceById(widget.lead.source);
    final assigned = leadStore.getAssignedById(widget.lead.assigned);
    String countryName = 'N/A';

    for (var c in leadStore.country) {
      if (c.countryId == widget.lead.country) {
        countryName = c.shortName ?? 'N/A'; // Set country name if found
        break;
      }
    }
    List<Tag>? displayedTags =
        showAll ? widget.lead.tags : widget.lead.tags!.take(3).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (widget.lead.permission!.alreadyCustomer != "1")
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Aligns to the right
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(8),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConvertToCustomer(
                          lead: widget.lead,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Convert To Customer',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          // Top Summary Card
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lead Information",
                    style: TextStyle(
                        color: acceptColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  height20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Name
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.lead.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Spacing between name and value
                      // Right side: Lead Value
                      Expanded(
                        flex: 2,
                        child: Text(
                          "₹ ${widget.lead.leadValue ?? '0.00'}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2, // Allow wrapping to two lines
                          overflow: TextOverflow
                              .visible, // Show full text without truncation
                          textAlign: TextAlign.end, // Align text to the right
                        ),
                      ),
                    ],
                  ),

                  height20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            status?.name ?? 'N/A',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            formatDate(widget.lead.dateadded) ?? 'N/A',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Details Card
                  DetailRow(
                      label: 'Position', value: widget.lead.title ?? 'N/A'),
                  const Divider(),
                  DetailRow(
                      label: 'Company', value: widget.lead.company ?? 'N/A'),
                  const Divider(),
                  DetailRow(
                      label: 'Phone', value: widget.lead.phonenumber ?? 'N/A'),
                  const Divider(),
                  DetailRow(
                      label: 'Website', value: widget.lead.website ?? 'N/A'),
                  const Divider(),
                  DetailRow(
                      label: 'Address', value: widget.lead.address ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'City', value: widget.lead.city ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'State', value: widget.lead.state ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Country', value: countryName ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Zip Code', value: widget.lead.zip ?? 'N/A'),
                ],
              ),
            ),
          ),
          height10(),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "General Information",
                    style: TextStyle(
                        color: acceptColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  height20(),
                  DetailRow(label: 'Source', value: source?.name ?? 'N/A'),
                  const Divider(),
                  DetailRow(
                      label: 'Assigned',
                      value: "${assigned?.firstName} ${assigned?.lastName}" ??
                          'N/A'),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tags',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              alignment: WrapAlignment.end,
                              spacing: 2,
                              children: [
                                ...displayedTags!
                                    .map((tag) => Text("${tag.name}, "))
                                    .toList(),
                                // Show "..." or "Show Less" button
                                if (widget.lead.tags!.length > 3)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showAll = !showAll; // Toggle visibility
                                      });
                                    },
                                    child: Text(
                                      showAll ? 'Show Less' : '...',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  DetailRow(
                      label: 'Last Contact',
                      value: formatDate(widget.lead.lastcontact.toString()) ??
                          'N/A'),
                  const Divider(),
                  DetailRow(
                      label: 'Public',
                      value:
                          widget.lead.isPublic == "1" ? "Yes" : "No" ?? 'N/A'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
