import 'package:crm/features/dashboard/customer/add_customer.dart';
import 'package:crm/features/dashboard/customer/customer_details.dart';
import 'package:crm/store/customer_store.dart';

import 'package:crm/utils/default_logger.dart';
import 'package:crm/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/colors.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    customerStore.customers.clear();
    customerStore.currentPage = 0;
    customerStore.hasMore = true;

    customerStore.fetchCustomerData(page: 0);

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !customerStore.isLoadingMore &&
        customerStore.hasMore) {
      customerStore.loadMoreCustomers();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CRMColors.background,
      body: SafeArea(
        child: Observer(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- HEADER ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Row(
                    children: [
                      Text(
                        'Customer Summary',
                        style: boldTextStyle(
                          size: 20,
                          color: CRMColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => customerStore.toggleShow(),
                        icon: Icon(
                          customerStore.isShow
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: CRMColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// --- SUMMARY GRID ---
                if (customerStore.isShow)
                  Observer(builder: (context) {
                    final counts = customerStore.customersCounts;
                    if (counts == null) {
                      return buildShimmerEffect(length: 1);
                    }
                    return _buildSummaryGrid(counts);
                  }),

                const SizedBox(height: 12),

                /// --- ADD CUSTOMER ACTION CARD ---
                Observer(builder: (_) {
                  if (customerStore.canEdit != 1) {
                    return const SizedBox();
                  }

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 6, 20, 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
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
                            "Add New Customer",
                            style: boldTextStyle(
                              size: 14,
                              color: CRMColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),

                        /// BUTTON
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: CRMColors.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => const AddCustomer().launch(context),
                          child: const Text(
                            "Add Customer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 10),

                /// --- DIRECTORY TITLE ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: CRMColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Directory',
                        style: boldTextStyle(
                          size: 18,
                          color: CRMColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// --- CUSTOMER LIST ---
                Expanded(
                  child: Observer(builder: (_) {
                    if (customerStore.customers.isEmpty && !customerStore.isLoadingMore) {
                      return buildShimmerEffect(length: 5);
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: customerStore.customers.length +
                    (customerStore.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == customerStore.customers.length) {
                          if (customerStore.isLoadingMore) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            ).paddingAll(16);
                          } else {
                            return const SizedBox(); // no loader when finished
                          }
                        }

                        return _buildCustomerCard(
                            customerStore.customers[index]);
                      },
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// SUMMARY GRID
  Widget _buildSummaryGrid(counts) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _summaryCard(
              "Total Customers",
              counts.totalCustomer!,
              Icons.groups_rounded,
              CRMColors.primary,
            ),
          ),
          12.width,
          Expanded(
            child: _summaryCard(
              "Active",
              counts.activeCustomer!,
              Icons.check_circle_outline,
              Colors.green,
            ),
          ),
          12.width,
          Expanded(
            child: _summaryCard(
              "Inactive",
              counts.inactiveCustomer!,
              Icons.cancel_outlined,
              Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: CRMColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          10.height,
          Text(
            value,
            style: boldTextStyle(size: 20, color: CRMColors.textPrimary),
          ),
          Text(
            title,
            style: secondaryTextStyle(size: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(customer) {
    bool isActive = customer.active == '1';

    return GestureDetector(
      onTap: () => CustomerDetails(customer: customer.userId).launch(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CRMColors.border.withOpacity(0.8)),
        ),
        child: Row(
          children: [
            /// Avatar
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: CRMColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: CRMColors.border),
              ),
              alignment: Alignment.center,
              child: Text(
                customer.company.isNotEmpty
                    ? customer.company[0].toUpperCase()
                    : 'C',
                style: boldTextStyle(color: CRMColors.primary, size: 18),
              ),
            ),

            const SizedBox(width: 12),

            /// Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.company,
                    style:
                        boldTextStyle(size: 15, color: CRMColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined,
                          size: 12, color: CRMColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        customer.phoneNumber,
                        style: secondaryTextStyle(
                            size: 13, color: CRMColors.accent),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.blueGrey.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isActive ? "Active" : "Inactive",
                style: boldTextStyle(
                  size: 11,
                  color: isActive ? Colors.blueGrey : Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
