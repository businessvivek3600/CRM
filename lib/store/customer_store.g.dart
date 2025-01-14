// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerStore on _CustomerStore, Store {
  late final _$customerFutureAtom =
      Atom(name: '_CustomerStore.customerFuture', context: context);

  @override
  ObservableFuture<(bool, Map<String, dynamic>, String?)>? get customerFuture {
    _$customerFutureAtom.reportRead();
    return super.customerFuture;
  }

  @override
  set customerFuture(
      ObservableFuture<(bool, Map<String, dynamic>, String?)>? value) {
    _$customerFutureAtom.reportWrite(value, super.customerFuture, () {
      super.customerFuture = value;
    });
  }

  late final _$customersAtom =
      Atom(name: '_CustomerStore.customers', context: context);

  @override
  ObservableList<Customer> get customers {
    _$customersAtom.reportRead();
    return super.customers;
  }

  @override
  set customers(ObservableList<Customer> value) {
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

  late final _$fetchCustomerDataAsyncAction =
      AsyncAction('_CustomerStore.fetchCustomerData', context: context);

  @override
  Future<void> fetchCustomerData() {
    return _$fetchCustomerDataAsyncAction.run(() => super.fetchCustomerData());
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
customerFuture: ${customerFuture},
customers: ${customers},
isShow: ${isShow}
    ''';
  }
}
