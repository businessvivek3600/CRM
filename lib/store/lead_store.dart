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
  bool loadingLeads = true;

  @observable
  List<Lead> leads = [];

  @observable
  List<LeadStatus> leadStatus = [];

  @observable
  List<LeadStatus> leadStatusDashboard = [];

  @observable
  List<LeadSource> leadSource = [];

  @observable
  ObservableList<Reminder> reminders = ObservableList<Reminder>();

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

    loadingLeads = true; // Update as observable
    var (status, data, message) = await ApiService.getLeads(page: page);
    infoLog("API Response Data according page: ${data}");
    if (status) {
      List<Lead> _leads = [];
      tryCatch(() => _leads = (data['leads'] as List).map((e) {
            return Lead.fromJson(e);
          }).toList());
      leads.addAll(_leads);
      if (data['status_data'] != null) {
        leadStatus = (data['status_data'] as List)
            .map((e) => LeadStatus.fromJson(e))
            .toList();
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
    loadingLeads = false;
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
    loadingLeads = true;
    var (status, responsedata, message) = await ApiService.addLeads(data);
    if (status) {}
  }

  //getDashBoard data
  Future<void> getDashboard() async {
    loadingLeads = true; // Update as observable
    var (status, data, message) = await ApiService.getDashboardData();
    if (status) {
      loadingLeads = false;
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
        loadingLeads = false;
      }

      if (data['country'] != null) {
        country =
            (data['country'] as List).map((e) => Country.fromJson(e)).toList();
      }
      leadStatusDashboard = (data["leadStatus"] as List)
          .map((e) => LeadStatus.fromJson(e))
          .toList();
      infoLog("Updated leadStatusDashboard: $leadStatusDashboard");
      loadingLeads = false;
    }
  }
  // Inside LeadStore class

  @action
  void addReminderToStore(Reminder reminder) {

    reminders.insert(0, reminder);

  }

  @action
  void updateReminderInStore(String id, Reminder updatedReminder) {
    int index = reminders.indexWhere((e) => e.id == id);

    if (index != -1) {
      reminders.removeAt(index);
      reminders.insert(index, updatedReminder);
    }
  }

  @action
  void deleteReminderFromStore(String id) {
    reminders.removeWhere((element) => element.id == id);
  }

  @action
  void setReminders(List<Reminder> initialReminders) {
    reminders.clear();
    reminders.addAll(initialReminders);
  }
}
