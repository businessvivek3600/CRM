import 'package:mobx/mobx.dart';
import 'package:crm/Models/usercustomer_model.dart';
import 'package:crm/services/api_services.dart';

import '../utils/default_logger.dart';

part 'customer_store.g.dart';

final customerStore = CustomerStore();
class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {
  @observable
  ObservableList<Customer> customers = ObservableList<Customer>();

  @observable
  CustomerCounts? customersCounts;

  @observable
  bool isShow = true;

  @observable
  int canEdit = 0;

  @observable
  int currentPage = 0;

  @observable
  bool hasMore = true;

  @observable
  bool isLoadingMore = false;


  @computed
  int get totalCustomer => customers.length;


  @computed
  int get activeCustomer {
    return customers.where((customer) => customer.active == '1').length;
  }

  @action
  Future<void> loadMoreCustomers() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    currentPage++;

    int previousLength = customers.length;

    await fetchCustomerData(page: currentPage);

    if (customers.length == previousLength) {
      hasMore = false;
    }

    isLoadingMore = false;
  }
  /// Get all customer list
  @action
  Future<void> fetchCustomerData({int page = 0}) async {
    try {
      var (status, data, message) = await ApiService.getCustomers(page: page);

      if (status) {
        canEdit = data['can_create'] ?? 0;

        List<Customer> _customers = [];

        try {
          _customers = (data['customers'] as List).map((e) {
            return Customer.fromJson(e);
          }).toList();
        } catch (e) {
          errorLog("❌ Customer parsing error: $e");
        }

        customers.addAll(_customers);

        try {
          customersCounts = CustomerCounts.fromJson(data['counts']);
        } catch (e) {
          errorLog("❌ Counts parsing error: $e");
        }
      } else {
        errorLog("Message: $message");
      }
    } catch (error) {
      errorLog(error.toString());
    }
  }

  /// Customer details using customer id

  Future<void> getCustomerDetails(String userId) async {
    try {
      // Start fetching data
      var (status, data, message) =
          await ApiService.getCustomerDetails({'clientId': userId});

      if (status) {
        (data['customers'] as List).map((e) {
          return Customer.fromJson(e);
        });
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
