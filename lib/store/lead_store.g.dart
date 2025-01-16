// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LeadStore on _LeadStore, Store {
  late final _$loadingLeadsAtom =
      Atom(name: '_LeadStore.loadingLeads', context: context);

  @override
  ValueNotifier<bool> get loadingLeads {
    _$loadingLeadsAtom.reportRead();
    return super.loadingLeads;
  }

  @override
  set loadingLeads(ValueNotifier<bool> value) {
    _$loadingLeadsAtom.reportWrite(value, super.loadingLeads, () {
      super.loadingLeads = value;
    });
  }

  late final _$leadsAtom = Atom(name: '_LeadStore.leads', context: context);

  @override
  List<Lead> get leads {
    _$leadsAtom.reportRead();
    return super.leads;
  }

  @override
  set leads(List<Lead> value) {
    _$leadsAtom.reportWrite(value, super.leads, () {
      super.leads = value;
    });
  }

  late final _$leadStatusAtom =
      Atom(name: '_LeadStore.leadStatus', context: context);

  @override
  List<LeadStatus> get leadStatus {
    _$leadStatusAtom.reportRead();
    return super.leadStatus;
  }

  @override
  set leadStatus(List<LeadStatus> value) {
    _$leadStatusAtom.reportWrite(value, super.leadStatus, () {
      super.leadStatus = value;
    });
  }

  late final _$leadSourceAtom =
      Atom(name: '_LeadStore.leadSource', context: context);

  @override
  List<LeadSource> get leadSource {
    _$leadSourceAtom.reportRead();
    return super.leadSource;
  }

  @override
  set leadSource(List<LeadSource> value) {
    _$leadSourceAtom.reportWrite(value, super.leadSource, () {
      super.leadSource = value;
    });
  }

  late final _$remindersAtom =
      Atom(name: '_LeadStore.reminders', context: context);

  @override
  List<Reminder> get reminders {
    _$remindersAtom.reportRead();
    return super.reminders;
  }

  @override
  set reminders(List<Reminder> value) {
    _$remindersAtom.reportWrite(value, super.reminders, () {
      super.reminders = value;
    });
  }

  late final _$staffAtom = Atom(name: '_LeadStore.staff', context: context);

  @override
  List<Staff> get staff {
    _$staffAtom.reportRead();
    return super.staff;
  }

  @override
  set staff(List<Staff> value) {
    _$staffAtom.reportWrite(value, super.staff, () {
      super.staff = value;
    });
  }

  late final _$tagsAtom = Atom(name: '_LeadStore.tags', context: context);

  @override
  List<Tag> get tags {
    _$tagsAtom.reportRead();
    return super.tags;
  }

  @override
  set tags(List<Tag> value) {
    _$tagsAtom.reportWrite(value, super.tags, () {
      super.tags = value;
    });
  }

  late final _$leadTagsAtom =
      Atom(name: '_LeadStore.leadTags', context: context);

  @override
  List<Tag> get leadTags {
    _$leadTagsAtom.reportRead();
    return super.leadTags;
  }

  @override
  set leadTags(List<Tag> value) {
    _$leadTagsAtom.reportWrite(value, super.leadTags, () {
      super.leadTags = value;
    });
  }

  late final _$getLeadsAsyncAction =
      AsyncAction('_LeadStore.getLeads', context: context);

  @override
  Future<void> getLeads({int page = 0}) {
    return _$getLeadsAsyncAction.run(() => super.getLeads(page: page));
  }

  late final _$addLeadAsyncAction =
      AsyncAction('_LeadStore.addLead', context: context);

  @override
  Future<void> addLead(FormData data) {
    return _$addLeadAsyncAction.run(() => super.addLead(data));
  }

  late final _$_LeadStoreActionController =
      ActionController(name: '_LeadStore', context: context);

  @override
  LeadStatus? getStatusById(String statusId) {
    final _$actionInfo = _$_LeadStoreActionController.startAction(
        name: '_LeadStore.getStatusById');
    try {
      return super.getStatusById(statusId);
    } finally {
      _$_LeadStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  LeadSource? getSourceById(String sourceId) {
    final _$actionInfo = _$_LeadStoreActionController.startAction(
        name: '_LeadStore.getSourceById');
    try {
      return super.getSourceById(sourceId);
    } finally {
      _$_LeadStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Staff? getAssignedById(String sourceId) {
    final _$actionInfo = _$_LeadStoreActionController.startAction(
        name: '_LeadStore.getAssignedById');
    try {
      return super.getAssignedById(sourceId);
    } finally {
      _$_LeadStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loadingLeads: ${loadingLeads},
leads: ${leads},
leadStatus: ${leadStatus},
leadSource: ${leadSource},
reminders: ${reminders},
staff: ${staff},
tags: ${tags},
leadTags: ${leadTags}
    ''';
  }
}
