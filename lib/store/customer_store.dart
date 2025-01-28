import 'package:mobx/mobx.dart';
import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/services/api_services.dart';

part 'customer_store.g.dart';

final customerStore = CustomerStore();
class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {

  @observable
  ObservableFuture<(bool, Map<String, dynamic>, String?)>? customerFuture;

  @observable
  ObservableList<Customer> customers = ObservableList<Customer>();

  @observable
  bool isShow = true;

  @observable
  String canEdit = "0";
  // Getter for total customers
  @computed
  int get totalCustomer => customers.length;

  // Getter for active customers
  @computed
  int get activeCustomer {
    return customers.where((customer) => customer.active == '1').length;
  }


  @action
  Future<void> fetchCustomerData() async {
    try {
      // Start fetching data
      customerFuture = ObservableFuture(ApiService.getCustomers(page: 0));
      final response = await customerFuture;

      if (response != null && response.$1) {
        // Clear existing customers and populate with new data
        customers.clear();
        final userCustomer = UserCustomer.fromJson(response.$2);
        if (userCustomer.customers.isNotEmpty) {
          customers.addAll(userCustomer.customers);
        }
        canEdit = response.$2['can_edit'] ?? "0";
      } else {
        throw Exception(
            response?.$3 ?? 'Unknown error occurred while fetching data');
      }
    } catch (error) {
      // Log or handle the error as needed
      print('Error fetching customer data: ${error.toString()}');
      throw Exception('Failed to fetch customer data: ${error.toString()}');
    }
  }

  @action
  void toggleShow() {
    isShow = !isShow;
  }
}
