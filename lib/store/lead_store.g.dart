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

  late final _$getLeadsAsyncAction =
      AsyncAction('_LeadStore.getLeads', context: context);

  @override
  Future<void> getLeads() {
    return _$getLeadsAsyncAction.run(() => super.getLeads());
  }

  @override
  String toString() {
    return '''
loadingLeads: ${loadingLeads},
leads: ${leads}
    ''';
  }
}
