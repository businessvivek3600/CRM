// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$isSessionExpiredAtom =
      Atom(name: '_AppStore.isSessionExpired', context: context);

  @override
  bool get isSessionExpired {
    _$isSessionExpiredAtom.reportRead();
    return super.isSessionExpired;
  }

  @override
  set isSessionExpired(bool value) {
    _$isSessionExpiredAtom.reportWrite(value, super.isSessionExpired, () {
      super.isSessionExpired = value;
    });
  }

  late final _$canAskForExitAppAtom =
      Atom(name: '_AppStore.canAskForExitApp', context: context);

  @override
  bool get canAskForExitApp {
    _$canAskForExitAppAtom.reportRead();
    return super.canAskForExitApp;
  }

  @override
  set canAskForExitApp(bool value) {
    _$canAskForExitAppAtom.reportWrite(value, super.canAskForExitApp, () {
      super.canAskForExitApp = value;
    });
  }

  late final _$setAskForExitAppAsyncAction =
      AsyncAction('_AppStore.setAskForExitApp', context: context);

  @override
  Future<void> setAskForExitApp(bool val) {
    return _$setAskForExitAppAsyncAction.run(() => super.setAskForExitApp(val));
  }

  late final _$setSessionExpiredAsyncAction =
      AsyncAction('_AppStore.setSessionExpired', context: context);

  @override
  Future<void> setSessionExpired(bool val) {
    return _$setSessionExpiredAsyncAction
        .run(() => super.setSessionExpired(val));
  }

  @override
  String toString() {
    return '''
isSessionExpired: ${isSessionExpired},
canAskForExitApp: ${canAskForExitApp}
    ''';
  }
}
