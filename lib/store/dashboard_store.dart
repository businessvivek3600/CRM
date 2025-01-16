import 'package:mobx/mobx.dart';
import '../Models/dashboard_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

part 'dashboard_store.g.dart';

class DashboardStore = _DashboardStore with _$DashboardStore;

abstract class _DashboardStore with Store {
  @observable
  Dashboard? dashboard;

  @observable
  String token = '';

  @observable
  String userEmail = '';

  @observable
  String profileImage = '';

  @observable
  String fullName = '';

  @action
  Future<void> loadUserData() async {
    try {
      final response = await fetchDashboardData();
      dashboard = Dashboard.fromJson(response);

      // Update additional properties
      userEmail = dashboard?.userData.email ?? '';
      profileImage = dashboard?.userData.profileImage ?? '';
      fullName = '${dashboard?.userData.firstname} ${dashboard?.userData.lastname}';
    } catch (e) {
      print("Error loading user data: $e");
    }
  }
}

Future<Map<String, dynamic>> fetchDashboardData() async {
  const url = 'https://example.com/api/dashboard'; // Replace with your actual API endpoint
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load dashboard data');
  }
}
