import 'dart:convert';
import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/features/auth/dashboard/customer/add_customer.dart';
import 'package:crm/services/api_services.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:crm/constants/api_constant.dart';
import 'package:crm/features/auth/dashboard/customer/customerdetails.dart';
import 'package:crm/features/auth/dashboard/home_screen.dart';
import 'package:crm/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  bool isShow = true;
  late Future<UserCustomer> userCustomer;

  // Fetch data from the API
  Future<UserCustomer> fetchCustomerData() async {
    final response =
        await ApiService.getCustomers(page: 0); // Call API to fetch customers

    if (response.$1) {
      // Check if the request was successful
      var data = response.$2; // The data fetched from the API
      UserCustomer userCustomer =
          UserCustomer.fromJson(data); // Parse the data into UserCustomer model

      // Return the userCustomer object
      return userCustomer;
    } else {
      throw Exception('Failed to load customer data');
    }
  }

  @override
  void initState() {
    super.initState();
    userCustomer = fetchCustomerData(); // Initialize the API call
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<UserCustomer>(
        future: userCustomer,
        builder: (context, snapshot) {
          infoLog('Error: ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            warningLog('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.customers.isEmpty) {
            return const Center(child: Text('No customers available.'));
          } else {
            final userCustomer = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding:
                     EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        const Text(
                          'Customer Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isShow =
                                  !isShow; // Toggle the visibility of the list
                            });
                          },
                          icon: Icon(
                            isShow
                                ? Icons
                                    .keyboard_arrow_up_outlined // Show up arrow
                                : Icons
                                    .keyboard_arrow_down_outlined, // Show down arrow
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    isShow
                        ? SingleChildScrollView(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // itemCount: userCustomer.customers.length,
                              itemCount: 6,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 3 / 2),
                              itemBuilder: (context, index) {
                                //   var customer = userCustomer.customers[index];
                                return SizedBox(
                                  height: 220,
                                  child: Card(
                                    elevation: 8,
                                    shadowColor: Colors.black54,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.person),
                                              Text(
                                                '${userCustomer.customers.length}',
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                           SizedBox(height: 10),
                                          Expanded(
                                            child:  Text(
                                              'Total Customers',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Customers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context).colorScheme.primary,
                                size: 25,
                              ),
                            ),
                            const Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var customer = userCustomer.customers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerDetails(
                                    customer:
                                        customer, // Pass the customer object here
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 8,
                              shadowColor: Colors.black54,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: Text(
                                        customer.company.isNotEmpty
                                            ? customer.company[
                                                0] // Use first letter of company as initial
                                            : 'C', // Default to 'C' if no company name
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
                                              : Colors.red, // Border color
                                        ),
                                        foregroundColor: customer.active == '1'
                                            ? Colors.green
                                            : Colors.red, // Text color
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
                        itemCount: userCustomer.customers.length,
                      ),
                    ),
                    
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: secondaryPrimaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCustomer(),
              ));
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        tooltip: 'Add Customer',
      ),
    );
  }
}
