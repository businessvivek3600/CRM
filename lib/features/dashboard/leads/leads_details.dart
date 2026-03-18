import 'package:crm/features/dashboard/customer/convert_to_customer.dart';
import 'package:crm/features/dashboard/leads/add_notes.dart';
import 'package:crm/features/dashboard/leads/leads_screen.dart';
import 'package:crm/features/dashboard/leads/reminders.dart';
import 'package:crm/features/dashboard/leads/update_lead.dart';
import 'package:crm/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../Models/leads_model.dart';
import '../../../../services/api_services.dart';
import '../../../../store/lead_store.dart';
import '../../../../widgets/date_formation.dart';
import '../../../utils/colors.dart';

class LeadDetails extends StatefulWidget {
  final String lead;
  const LeadDetails({super.key, required this.lead});

  @override
  State<LeadDetails> createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  Lead? lead;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLeadDetails();
  }

  Future<void> _fetchLeadDetails() async {
    setState(() => isLoading = true);
    var (bool status, Map<String, dynamic> data, String? message) =
    await ApiService.getLeadDetails({'leadId': widget.lead});

    if (status && data.containsKey('leads') && (data['leads'] as List).isNotEmpty) {
      setState(() {
        lead = Lead.fromJson(data['leads'][0]);
      });
    } else {
      toast(message ?? 'Failed to load details', bgColor: Colors.red);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: CRMColors.background,
        appBar: AppBar(
          leading:const BackButton(color: Colors.black,),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            lead != null ? '#${lead!.id} - ${lead!.name.toUpperCase()}' : 'Lead Details',
            style: boldTextStyle( size: 18),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,color: Colors.black,),
              onPressed: () async {
                if (lead == null) return;
                final updated = await EditLead(lead: lead!).launch(context);
                if (updated != null) setState(() => lead = updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,color: Colors.redAccent,),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        body: isLoading
            ? buildShimmerEffect(length: 5).paddingAll(16)
            : lead == null
            ? const Center(child: Text("Lead data unavailable"))
            : Column(
          children: [
            // --- CONVERSION ACTION BAR ---
            if (lead!.permission!.alreadyCustomer != "1")
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: CRMColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: CRMColors.primary.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CRMColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1,
                        size: 18,
                        color: CRMColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Convert this lead to customer",
                        style: boldTextStyle(
                          size: 14,
                          color: CRMColors.textPrimary,
                        ),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: CRMColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final converted = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConvertToCustomer(lead: lead!),
                          ),
                        );

                        if (converted == true) {
                          Navigator.pop(context, true); // close LeadDetails
                        }
                      },
                      child: const Text(
                        "Convert",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),

            // --- PROFESSIONAL TAB BAR ---
            Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: CRMColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CRMColors.border),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: CRMColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: CRMColors.textSecondary,
                labelStyle: boldTextStyle(size: 13),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.person_outline, size: 18),
                    text: "Profile",
                  ),
                  Tab(
                    icon: Icon(Icons.notes_outlined, size: 18),
                    text: "Notes",
                  ),
                  Tab(
                    icon: Icon(Icons.notifications_outlined, size: 18),
                    text: "Reminders",
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  ProfileTab(lead: lead!),
                  AddNotesTab(noteData: lead!.notesData ?? [], lead: lead!),
                  RemindersTab(remainder: lead!.reminders ?? [], lead: lead!,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showConfirmDialogCustom(
      context,
      title: "Delete Lead?",
      subTitle: "This action cannot be undone. Are you sure?",
      positiveText: "Delete",
      negativeText: "Cancel",
      primaryColor: Colors.redAccent,
      onAccept: (c) async {
        final (status, _, message) = await ApiService.deleteLead({'id': widget.lead});
        if (status) {
          Navigator.pop(context, true);
        } else {
          toast(message, bgColor: Colors.red);
        }
      },
    );
  }
}

class ProfileTab extends StatelessWidget {
  final Lead lead;
  const ProfileTab({required this.lead, super.key});

  @override
  Widget build(BuildContext context) {
    final status = leadStore.getStatusById(lead.status);
    final source = leadStore.getSourceById(lead.source);
    final assigned = leadStore.getAssignedById(lead.assigned);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Basic Info Section
          _buildInfoSection(
            title: "Lead Information",
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lead.name ?? '--', style: boldTextStyle(size: 18)),
                  Text("₹${lead.leadValue ?? '0'}", style: boldTextStyle(size: 18, color: CRMColors.primary)),
                ],
              ),
              12.height,
              Row(
                children: [
                  _buildStatusChip(status?.name ?? 'No Status', _hexToColor(leadStore.leadSummary.firstWhere((e) => e.id == lead.status, orElse: () => LeadSummary(color: '#64748B', id: '', name: '', statusOrder: '', isDefault: '', total: 0)).color)),
                  const Spacer(),
                  const Icon(Icons.calendar_today, size: 14, color: CRMColors.textMuted),
                  6.width,
                  Text(formatDate(lead.dateadded) ?? '--', style: secondaryTextStyle()),
                ],
              ),
              const Divider(height: 32),
              _buildDetailRow("Company", lead.company),
              _buildDetailRow("Position", lead.title),
              _buildDetailRow("Phone", lead.phonenumber),
              _buildDetailRow("Website", lead.website),
              _buildDetailRow("Location", "${lead.city ?? ''}, ${lead.state ?? ''}".trim()),
            ],
          ),

          16.height,

          // Assignment & Source
          _buildInfoSection(
            title: "General Information",
            children: [
              _buildDetailRow("Source", source?.name),
              _buildDetailRow("Assigned To", "${assigned?.firstName ?? ''} ${assigned?.lastName ?? ''}"),
              _buildDetailRow("Public Lead", lead.isPublic == "1" ? "Yes" : "No"),
            ],
          ),

          16.height,

          // Description
          _buildInfoSection(
            title: "Internal Notes/Description",
            children: [
              Text(lead.description.isEmptyOrNull ? "No description provided." : lead.description!, style: secondaryTextStyle()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CRMColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: boldTextStyle(size: 12, color: CRMColors.textMuted, letterSpacing: 1.2)),
          16.height,
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: secondaryTextStyle()),
          Text(value.isEmptyOrNull ? "N/A" : value!, style: boldTextStyle(size: 14, color: CRMColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: boldTextStyle(size: 12, color: color)),
    );
  }
}

Color _hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor';
  return Color(int.parse(hexColor, radix: 16));
}