import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/services/api_services.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'customer_store.g.dart';

final customerStore = CustomerStore();

class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {
  @observable
  ValueNotifier<bool> loadingCustomers = ValueNotifier(true);

  @observable
  List<Customer> customers = [];

  @action
  Future<void> getCustomers({int page = 0}) async {
    infoLog("Customers Page Count --------$page");
    loadingCustomers.value = true; // Set loading state
    var (status, data, message) =
        await ApiService.getCustomers(page: page); // Call API service
    infoLog("API Response Data for page: ${data['customers']}");
    if (status) {
      List<Customer> _customers = [];
      tryCatch(() => _customers = (data['customers'] as List).map((e) {
            return Customer.fromJson(e);
          }).toList());
      customers = _customers;
      pl('Fetched customers count: ${_customers.length}');
      for (var customer in customers) {
        warningLog("Customer: ${customer.toJson()}");
      }
    }
    loadingCustomers.value = false; // Ensure loading state is updated
  }
}
