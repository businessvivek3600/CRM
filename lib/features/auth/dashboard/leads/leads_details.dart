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
                _showDeleteDialog(
                    context);
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

                labelColor: textPrimaryColor,
                unselectedLabelColor:
                    textPrimaryColor.withOpacity(0.6),
                indicatorColor:
                   acceptColor, // Tab indicator color
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
                    lead:   widget.lead,
                  ),
                  RemindersTab(
                    remainder: widget.lead.reminders ?? [],
                    lead:   widget.lead,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeadsScreen(),
                            ),
                          ); // Close dialog
                          // Add delete functionality here
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Lead deleted!"),
                          ));
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
    List<Tag> displayedTags = showAll
        ? leadStore.leadTags
        : leadStore.leadTags.take(3).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Aligns to the right
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
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
                      builder: (context) => const ConvertToCustomer(),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lead.name ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹ ${widget.lead.leadValue}" ?? '0.00',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                 height10(),
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
                  DetailRow(label: 'Position', value: widget.lead.title ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Company', value: widget.lead.company ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Phone', value: widget.lead.phonenumber ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Website', value: widget.lead.website ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Address', value: widget.lead.address ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'City', value: widget.lead.city ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'State', value: widget.lead.state ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Country', value: widget.lead.country ?? 'N/A'),
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
                  DetailRow(label: 'Assigned', value: "${assigned?.firstName} ${assigned?.lastName}" ?? 'N/A'),
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
                            children:[  ...displayedTags.map((tag) => Text("${tag.name}, ")).toList(),
                // Show "..." or "Show Less" button
                if (leadStore.leadTags.length > 3)
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
                      ]    ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  DetailRow(label: 'Last Contact', value: formatDate(widget.lead.lastcontact.toString()) ?? 'N/A'),
                  const Divider(),
                  DetailRow(label: 'Public', value: widget.lead.isPublic == "1" ? "Yes" : "No" ?? 'N/A'),
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
