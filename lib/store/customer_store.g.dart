// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerStore on _CustomerStore, Store {
  late final _$loadingCustomersAtom =
      Atom(name: '_CustomerStore.loadingCustomers', context: context);

  @override
  ValueNotifier<bool> get loadingCustomers {
    _$loadingCustomersAtom.reportRead();
    return super.loadingCustomers;
  }

  @override
  set loadingCustomers(ValueNotifier<bool> value) {
    _$loadingCustomersAtom.reportWrite(value, super.loadingCustomers, () {
      super.loadingCustomers = value;
    });
  }

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

  late final _$getCustomersAsyncAction =
      AsyncAction('_CustomerStore.getCustomers', context: context);

  @override
  Future<void> getCustomers({int page = 0}) {
    return _$getCustomersAsyncAction.run(() => super.getCustomers(page: page));
  }

  @override
  String toString() {
    return '''
loadingCustomers: ${loadingCustomers},
customers: ${customers}
    ''';
  }
}
