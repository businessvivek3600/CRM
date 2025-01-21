import 'package:crm/features/auth/dashboard/customer/add_customer.dart';
import 'package:crm/features/auth/dashboard/customer/customerdetails.dart';
import 'package:crm/features/auth/dashboard/home_screen.dart';
import 'package:crm/store/customer_store.dart';
import 'package:crm/utils/colors.dart';
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
  final CustomerStore customerStore = CustomerStore();

  @override
  void initState() {
    super.initState();
    customerStore.fetchCustomerData();
  }

  @override
  Widget build(BuildContext context) {
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
            if (customerStore.customerFuture?.status == FutureStatus.pending) {
              return const Center(child: CircularProgressIndicator());
            } else if (customerStore.customerFuture?.status ==
                FutureStatus.rejected) {
              return const Center(child: Text('Error loading data'));
            } else if (customerStore.customers.isEmpty) {
              return const Center(child: Text('No customers available.'));
            }

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
                        ? GridView.builder(
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
                                value = '${customerStore.totalCustomer}';
                                color = Colors.blue;
                              } else if (index == 1) {
                                title = 'Active\nCustomers';
                                value = '${customerStore.activeCustomer}';
                                color = Colors.green;
                              } else {
                                title = 'Inactive\nCustomers';
                                value =
                                    '${customerStore.totalCustomer - customerStore.activeCustomer}';
                                color = Colors.red;
                              }

                              return Card(
                                elevation: 4,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          )
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
                          const    Text(
                            'Customers',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    // Row(
                    //   children: [
                    //     IconButton(
                    //       onPressed: () {},
                    //       icon: Icon(
                    //         Icons.filter_list,
                    //         color: Theme.of(context).colorScheme.primary,
                    //         size: 25,
                    //       ),
                    //     ),
                    //     const Text(
                    //       'Filter',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
height10(),
                // Customer List
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      var customer = customerStore.customers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerDetails(
                                  customer: customerStore.customers[index]!),
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
                                      fontWeight: FontWeight.bold,
                                    ),
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
                    itemCount: customerStore.customers.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
