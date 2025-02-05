import 'package:mobx/mobx.dart';
import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/services/api_services.dart';

import '../utils/default_logger.dart';

part 'customer_store.g.dart';

final customerStore = CustomerStore();
class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {

  @observable
  List<Customer> customers = [];

  @observable
CustomerCounts? customersCounts ;

  @observable
  bool isShow = true;

  @observable
  int canEdit = 0;
  // Getter for total customers
  @computed
  int get totalCustomer => customers.length;

  // Getter for active customers
  @computed
  int get activeCustomer {
    return customers.where((customer) => customer.active == '1').length;
  }


  @action
  Future<void> fetchCustomerData({int page = 0}) async {
    try {

      // Start fetching data
      var (status, data, message) = await ApiService.getCustomers(page: page);

      if (status) {
        canEdit = data['can_create'] ?? 0;
        infoLog("canEdit  - ${data['can_create']}");
      List<Customer> _customers = [];
        tryCatch(() =>  _customers = (data['customers'] as List).map((e) {
          return Customer.fromJson(e);
        }).toList());
        customers.addAll(_customers);
        errorLog("response data -- ${data['counts']}");
        customersCounts = CustomerCounts.fromJson(data['counts']);
      } else {
        throw Exception(
            message ?? 'Unknown error occurred while fetching data');
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
