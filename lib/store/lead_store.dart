
import 'package:crm/Models/leads_model.dart';
import 'package:crm/services/api_services.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:crm/utils/extensions.dart';
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
  List<LeadSource> leadSource = [];

  @observable
  List<Reminder> reminders = [];

  @action
  Future<void> getLeads({int page = 0}) async {
    infoLog("Leads Page Count --------$page");
    loadingLeads.value = true; // Update as observable
    var (status, data, message) = await ApiService.getLeads(page:  page);
    infoLog("API Response Data according page: ${data['leads']}");
    if (status) {
      List<Lead> _leads = [];
      tryCatch(() => _leads = (data['leads'] as List).map((e) {
        return Lead.fromJson(e);
      }).toList());
      leads = _leads;
      pl('res _products length: ${_leads.length}');
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
      for (var lead in leads) {
        warningLog("Lead: ${lead.toJson()}");
      }
    }
    loadingLeads.value = false; // Ensure loading state is updated
  }

  @action
  LeadStatus? getStatusById(String statusId) {
    return leadStatus.firstWhereOrNull((status) => status.id == statusId);
  }
  @action
  LeadSource? getSourceById(String sourceId) {
    return leadSource.firstWhereOrNull((source) => source.id ==  sourceId);
  }
}