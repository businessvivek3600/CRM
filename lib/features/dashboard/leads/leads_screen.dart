
import 'package:crm/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../Models/leads_model.dart';
import '../../../../store/app_store.dart';
import '../../../../store/lead_store.dart';
import '../../../../widgets/date_formation.dart';
import '../../../utils/colors.dart';
import 'add_leads.dart';
import 'leads_details.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  bool isShow = true;
  int currentPage = 0;
  bool isLoadingMore = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _init();
    _scrollController.addListener(_onScroll);
  }

  void _init() async {
    leadStore.leads.clear();
    currentPage = 0;
    hasMore = true;
    await leadStore.getDashboard();
    await leadStore.getLeads(page: currentPage);
    setState(() => isShow = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        hasMore) {
      _loadMoreLeads();
    }
  }

  Future<void> _loadMoreLeads() async {
    setState(() => isLoadingMore = true);

    currentPage++;

    int previousLength = leadStore.leads.length;

    await leadStore.getLeads(page: currentPage);

    setState(() {
      isLoadingMore = false;

      if (leadStore.leads.length == previousLength) {
        hasMore = false; // no new data
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CRMColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SECTION ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: Row(
                children: [
                  Text('Lead Summary',
                      style: boldTextStyle(
                          size: 20, color: CRMColors.textPrimary)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => setState(() => isShow = !isShow),
                    icon: Icon(isShow ? Icons.expand_less : Icons.expand_more,
                        color: CRMColors.textSecondary),
                  ),
                ],
              ),
            ),

            // --- SUMMARY CARDS ---
            if (isShow)
              Observer(builder: (_) {
                if (leadStore.leadSummary.isEmpty) {
                  return buildShimmerEffect(length: 1);
                }
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: leadStore.leadSummary.length,
                    itemBuilder: (context, index) =>
                        SizedBox(height:300,child: _buildSummaryCard(leadStore.leadSummary[index])),
                  ),
                );
              }),

            const SizedBox(height: 14),
            /// --- ADD LEAD ACTION ---
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 6, 20, 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: CRMColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: CRMColors.primary.withOpacity(0.15),
                ),
              ),
              child: Row(
                children: [

                  /// ICON
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

                  /// TEXT
                  Expanded(
                    child: Text(
                      "Add New Lead",
                      style: boldTextStyle(
                        size: 14,
                        color: CRMColors.textPrimary,
                      ),
                    ),
                  ),

                  /// BUTTON
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
                    onPressed: () => const AddLeads().launch(context),
                    child: const Text(
                      "Add Lead",
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
            const SizedBox(height: 14),
            // --- LEADS LIST SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('All Leads',
                  style: boldTextStyle(size: 18, color: CRMColors.textPrimary)),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Observer(builder: (_) {
                if (leadStore.loadingLeads) {
                  return buildShimmerEffect(length: 5);
                }

                if (leadStore.leads.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Leads Found",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: leadStore.leads.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == leadStore.leads.length) {
                      return const Center(child: CircularProgressIndicator())
                          .paddingAll(16);
                    }
                    return _buildLeadCard(leadStore.leads[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(LeadSummary summary) {
    Color statusColor = _hexToColor(summary.color);
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CRMColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CRMColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(summary.total.toString(),
              style: boldTextStyle(size: 22, color: statusColor)),
          4.height,
          Text(summary.name,
              style:
                  secondaryTextStyle(size: 12, color: CRMColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildLeadCard(Lead lead) {
    final status = leadStore.getStatusById(lead.status);
    final source = leadStore.getSourceById(lead.source);
    final statusColor = getStatusColor(lead.status);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LeadDetails(lead: lead.id),
          ),
        );

        if (result == true) {
          _init(); // reload leads list
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CRMColors.border.withOpacity(0.8)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(lead.name ?? "Unnamed Lead",
                            style: boldTextStyle(
                                size: 16, color: CRMColors.textPrimary)),
                      ),
                      Text(lead.leadValue ?? "",
                          style: boldTextStyle(
                              size: 16, color: CRMColors.primary)),
                    ],
                  ),
                  4.height,
                  Text(lead.company ?? "No Company",
                      style:
                          secondaryTextStyle(color: CRMColors.textSecondary)),
                  const Divider(height: 24, thickness: 0.8),
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 3, backgroundColor: statusColor),
                            6.width,
                            Text(status?.name ?? "Unknown",
                                style: boldTextStyle(
                                    size: 12, color: statusColor)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.calendar_month_outlined,
                          size: 14, color: CRMColors.textMuted),
                      4.width,
                      Text(formatDate(lead.dateadded) ?? '',
                          style: secondaryTextStyle(size: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- COLOR HELPERS ---
Color getStatusColor(String statusId) {
  final summary = leadStore.leadSummary.firstWhere(
    (leadSummary) => leadSummary.id == statusId,

    orElse: () => LeadSummary(
        id: '',
        name: '',
        total: 0,
        color: '#5f615c',
        statusOrder: '',
        isDefault: ''), // Default value
  );

// Return the dynamic color or a default color if not found

  return _hexToColor(summary.color);
}

Color _hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor';
  return Color(int.parse(hexColor, radix: 16));
}
