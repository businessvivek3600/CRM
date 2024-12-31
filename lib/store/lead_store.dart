
import 'package:crm/Models/leads_model.dart';
import 'package:crm/services/api_services.dart';
import 'package:crm/utils/default_logger.dart';
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

  @action
  Future<void> getLeads() async {
    loadingLeads.value = true; // Update as observable
    var (status, data, message) = await ApiService.getLeads();
    if (status) {
      List<Lead> _leads = [];
      tryCatch(() => _leads = (data['leads'] as List).map((e) {
        return Lead.fromJson(e);
      }).toList());
      leads = _leads;
      pl('res _products length: ${_leads.length}');
      for (var lead in leads) {
        warningLog("Lead: ${lead.toJson()}");
      }
    }
    loadingLeads.value = false; // Ensure loading state is updated
  }
}