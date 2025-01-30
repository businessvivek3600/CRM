// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerStore on _CustomerStore, Store {
  Computed<int>? _$totalCustomerComputed;

  @override
  int get totalCustomer =>
      (_$totalCustomerComputed ??= Computed<int>(() => super.totalCustomer,
              name: '_CustomerStore.totalCustomer'))
          .value;
  Computed<int>? _$activeCustomerComputed;

  @override
  int get activeCustomer =>
      (_$activeCustomerComputed ??= Computed<int>(() => super.activeCustomer,
              name: '_CustomerStore.activeCustomer'))
          .value;

  late final _$customersAtom =
      Atom(name: '_CustomerStore.customers', context: context);

  @override
  List<Customer> get customers {
    _$customersAtom.reportRead();
    return super.customers;
  }

  @override
  set customers(List<Customer> value) {
    _$customersAtom.reportWrite(value, super.customers, () {
      super.customers = value;
    });
  }

  late final _$isShowAtom =
      Atom(name: '_CustomerStore.isShow', context: context);

  @override
  bool get isShow {
    _$isShowAtom.reportRead();
    return super.isShow;
  }

  @override
  set isShow(bool value) {
    _$isShowAtom.reportWrite(value, super.isShow, () {
      super.isShow = value;
    });
  }

  late final _$canEditAtom =
      Atom(name: '_CustomerStore.canEdit', context: context);

  @override
  int get canEdit {
    _$canEditAtom.reportRead();
    return super.canEdit;
  }

  @override
  set canEdit(int value) {
    _$canEditAtom.reportWrite(value, super.canEdit, () {
      super.canEdit = value;
    });
  }

  late final _$fetchCustomerDataAsyncAction =
      AsyncAction('_CustomerStore.fetchCustomerData', context: context);

  @override
  Future<void> fetchCustomerData({int page = 0}) {
    return _$fetchCustomerDataAsyncAction
        .run(() => super.fetchCustomerData(page: page));
  }

  late final _$_CustomerStoreActionController =
      ActionController(name: '_CustomerStore', context: context);

  @override
  void toggleShow() {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
        name: '_CustomerStore.toggleShow');
    try {
      return super.toggleShow();
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
customers: ${customers},
isShow: ${isShow},
canEdit: ${canEdit},
totalCustomer: ${totalCustomer},
activeCustomer: ${activeCustomer}
    ''';
  }
}
