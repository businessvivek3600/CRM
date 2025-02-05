import 'package:crm/features/auth/dashboard/customer/add_customer.dart';
import 'package:crm/features/auth/dashboard/customer/customerdetails.dart';
import 'package:crm/features/auth/dashboard/home_screen.dart';
import 'package:crm/store/customer_store.dart';
import 'package:crm/utils/colors.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  bool isShow = true;
  int currentPage = 0;
  bool hasMore = true;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    customerStore.customers.clear();
    currentPage = 0;
    hasMore = true;
    customerStore.fetchCustomerData(page: currentPage).then((_) {
      setState(() {
        isShow = true;
      });
    });
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
        !isLoadingMore &&
        hasMore) {
      _loadMoreLeads();
    }
  }

  Future<void> _loadMoreLeads() async {
    setState(() {
      isLoadingMore = true;
    });

    currentPage++; // Increment the current page
    int previousLength = customerStore.customers.length;
    await customerStore.fetchCustomerData(page: currentPage);

    setState(() {
      isLoadingMore = false;
      if (customerStore.customers.length == previousLength) {
        hasMore = false; // No new data, stop loading
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    errorLog("${customerStore.canEdit} == ");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryPrimaryColor,
        title: const Text(
          'Customer',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Observer(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Static Header Section
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Customer Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => customerStore.toggleShow(),
                          icon: Icon(
                            customerStore.isShow
                                ? Icons.keyboard_arrow_up_outlined
                                : Icons.keyboard_arrow_down_outlined,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    height10(),
                    customerStore.isShow
                        ? Observer(builder: (context) {
                            final counts = customerStore.customersCounts;
                            if (counts == null) return const SizedBox();
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  3, // Three items: Total, Active, Inactive Customers
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Display 3 items in a row
                                childAspectRatio:
                                    9 / 7, // Adjust card height/width ratio
                              ),
                              itemBuilder: (context, index) {
                                // Define labels and values dynamically based on index
                                String title;
                                String value;
                                Color color;

                                if (index == 0) {
                                  title = 'Total\nCustomers';
                                  value = counts.totalCustomer!;
                                  color = Colors.blue;
                                } else if (index == 1) {
                                  title = 'Active\nCustomers';
                                  value = counts.activeCustomer!;
                                  color = Colors.green;
                                } else {
                                  title = 'Inactive\nCustomers';
                                  value = counts.inactiveCustomer!;
                                  color = Colors.red;
                                }

                                return Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          title,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          value,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          })
                        : const SizedBox(),
                  ],
                ),
                height20(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Customers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                height10(),
                // Customer List
                Observer(builder: (_) {
                  return Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount:
                          customerStore.customers.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == customerStore.customers.length) {
                          return hasMore
                              ? const Center(child: CircularProgressIndicator())
                              : const Center(
                                  child: Text("No more data",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)));
                        }

                        var customer = customerStore.customers[
                            index]; // This line was causing the error

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerDetails(customer: customer),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Text(
                                      customer.company.isNotEmpty
                                          ? customer.company[0]
                                          : 'C',
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          customer.company,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          customer.phoneNumber,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: customer.active == '1'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      foregroundColor: customer.active == '1'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    child: Text(
                                      customer.active == '1'
                                          ? "Active"
                                          : "Not Active",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Observer(builder: (_) {
        infoLog("canEdit or create a floating  - ${customerStore.canEdit}");
        return (customerStore.canEdit ==
                1) // Ensure comparison results in a bool
            ? FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: secondaryPrimaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCustomer(),
                    ),
                  );
                },
                tooltip: 'Add Customer',
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            : Container();
      }),
    );
  }
}
