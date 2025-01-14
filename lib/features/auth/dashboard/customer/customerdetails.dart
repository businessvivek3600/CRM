import 'package:crm/Models/usercustomer_model.dart';
import 'package:flutter/material.dart';
import 'package:crm/features/auth/dashboard/customer/customer_Screen.dart';
import 'package:crm/features/auth/dashboard/customer/updatecustomer.dart';
import 'package:crm/utils/colors.dart';

class CustomerDetails extends StatefulWidget {
  final Customer customer;

  const CustomerDetails({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(customer.company),
          backgroundColor: secondaryPrimaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Use pop instead of push
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateCustomer(customer: customer),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        body: Column(
          children: [
            Material(
              color: const Color(0xfffef7ff),
              child: TabBar(
                labelColor: textPrimaryColor,
                unselectedLabelColor: textPrimaryColor.withOpacity(0.6),
                indicatorColor: textPrimaryColor.withOpacity(0.8),
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Billing & Shipping'),
                  Tab(text: 'Contacts'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProfileTab(customer),
                  _buildBillingShippingTab(customer),
                  const Center(child: Text('Contact Information')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(Customer customer) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Company', customer.company),
                  _buildRow('VAT Number', customer.vat),
                  const Divider(),
                  _buildRow('Phone', customer.phoneNumber),
                  _buildRow('Website', customer.website),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Address', customer.address),
                  const Divider(),
                  _buildRow('City', customer.city),
                  _buildRow('State', customer.state),
                  const Divider(),
                  _buildRow('Zip Code', customer.zip),
                  _buildRow('Country', customer.country),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingShippingTab(Customer customer) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Company', customer.company),
                  _buildRow('Website', customer.website),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Address', customer.address),
                  const Divider(),
                  _buildRow('City', customer.city),
                  _buildRow('State', customer.state),
                  const Divider(),
                  _buildRow('Zip Code', customer.zip),
                  _buildRow('Country', customer.country),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            value ?? '--', // Handle null values
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    // Dialog implementation as is
  }
}
