import 'package:crm/Models/dashboard_model.dart';
import 'package:crm/Models/leads_model.dart';
import 'package:crm/services/api_services.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/extensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'lead_store.g.dart';

final leadStore = LeadStore();

class LeadStore = _LeadStore with _$LeadStore;

abstract class _LeadStore with Store {
  @observable
  ValueNotifier<bool> loadingLeads = ValueNotifier(true);

  @observable
  List<Lead> leads = [];

  @observable
  List<LeadStatus> leadStatus = [];

  @observable
  List<LeadStatus> leadStatusDashboard = [];

  @observable
  List<LeadSource> leadSource = [];

  @observable
  List<Reminder> reminders = [];

  @observable
  List<Staff> staff = [];

  @observable
  List<Tag> tags = [];

  @observable
  List<LeadSummary> leadSummary = [];

  @observable
  List<Tag> leadTags = [];

  @observable
  List<Country> country = [];

  @observable
  ObservableList<Map<String, dynamic>> metricData = ObservableList();

  @observable
  FirstBox firstBox = FirstBox(totalLeads: 0);

  @observable
  SecondBox secondBox = SecondBox(totalCLeads: 0, totalConverted: 0);

  @observable
  ThirdBox thirdBox = ThirdBox(totalNewLeads: 0);

  @observable
  FourthBox fourthBox = FourthBox(totalContactLeads: 0);

  @observable
  CompanyInfo? companyInfo;

  @action
  Future<void> getLeads({int page = 0}) async {
    infoLog("Leads Page Count --------$page");
    loadingLeads.value = true; // Update as observable
    var (status, data, message) = await ApiService.getLeads(page: page);
    infoLog("API Response Data according page: ${data['leads']}");
    if (status) {
      List<Lead> _leads = [];
      tryCatch(() => _leads = (data['leads'] as List).map((e) {
            return Lead.fromJson(e);
          }).toList());
      leads.addAll(_leads);
      pl('res _products length: ${_leads.length}');
      if (data['status_data'] != null) {
        leadStatus = (data['status_data'] as List)
            .map((e) => LeadStatus.fromJson(e))
            .toList();
        infoLog("${data['status_data']}");
      }
      if (data['sources'] != null) {
        leadSource = (data['sources'] as List)
            .map((e) => LeadSource.fromJson(e))
            .toList();
      }
      if (data['staff'] != null) {
        staff = (data['staff'] as List).map((e) => Staff.fromJson(e)).toList();
      }
      if (data['tags'] != null) {
        tags = (data['tags'] as List).map((e) => Tag.fromJson(e)).toList();
      }
      if (data["status_data"] != null) {
        leadSummary = (data["status_data"] as List)
            .map((e) => LeadSummary.fromJson(e))
            .toList();
      }
      List<Tag> allTags = [];
      for (var lead in leads) {
        if (lead.tags != null) {
          allTags.addAll(lead.tags!);
        }
      }
      leadTags = allTags.toSet().toList();
    }
    loadingLeads.value = false;
  }

  @action
  LeadStatus? getStatusById(String statusId) {
    return leadStatus.firstWhereOrNull((status) => status.id == statusId);
  }

  @action
  LeadSource? getSourceById(String sourceId) {
    return leadSource.firstWhereOrNull((source) => source.id == sourceId);
  }

  @action
  Staff? getAssignedById(String sourceId) {
    return staff.firstWhereOrNull((source) => source.staffId == sourceId);
  }

  ///Add a new Lead
  @action
  Future<void> addLead(FormData data) async {
    loadingLeads.value = true;
    var (status, responsedata, message) = await ApiService.addLeads(data);
    infoLog("API Response Data according page: ${responsedata['leads']}");
    if (status) {}
  }

  //getDashBoard data
  Future<void> getDashboard() async {
    loadingLeads.value = true; // Update as observable
    var (status, data, message) = await ApiService.getDashboardData();
    infoLog(
        "API Dashboard Data according page: ${data['first_box']?['total_leads']}");
    infoLog(
        "API Dashboard Data according page: ${data['second_box']?['total_c_leads']}");
    infoLog(
        "API Dashboard Data according page: ${data['third_box']?['total_new_leads']}");
    infoLog(
        "API Dashboard Data according page: ${data['fourth_box']?['total_contact_leads']}");
    if (status) {
      loadingLeads.value = false;
      //  companyInfo = CompanyInfo.fromJson(data['companyInfo']);
      // Map data to FirstBox
      firstBox = FirstBox.fromJson(data['first_box'] ?? {});

      // Map data to SecondBox
      secondBox = SecondBox.fromJson(data['second_box'] ?? {});

      // Map data to ThirdBox
      thirdBox = ThirdBox.fromJson(data['third_box'] ?? {});

      // Map data to FourthBox
      fourthBox = FourthBox.fromJson(data['fourth_box'] ?? {});
      //Company Info
      if (status) {
        companyInfo = data['company_info'] != null
            ? CompanyInfo.fromJson(data['company_info'])
            : null;
        loadingLeads.value = false;
      }

      if (data['country'] != null) {
        country =
            (data['country'] as List).map((e) => Country.fromJson(e)).toList();
      }
      leadStatusDashboard = (data["leadStatus"] as List)
          .map((e) => LeadStatus.fromJson(e))
          .toList();
      infoLog("Updated leadStatusDashboard: $leadStatusDashboard");
      loadingLeads.value = false;
    }
  }
}
