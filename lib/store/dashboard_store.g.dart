// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardStore on _DashboardStore, Store {
  late final _$dashboardAtom =
      Atom(name: '_DashboardStore.dashboard', context: context);

  @override
  Dashboard? get dashboard {
    _$dashboardAtom.reportRead();
    return super.dashboard;
  }

  @override
  set dashboard(Dashboard? value) {
    _$dashboardAtom.reportWrite(value, super.dashboard, () {
      super.dashboard = value;
    });
  }

  late final _$tokenAtom =
      Atom(name: '_DashboardStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: '_DashboardStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$profileImageAtom =
      Atom(name: '_DashboardStore.profileImage', context: context);

  @override
  String get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(String value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  late final _$fullNameAtom =
      Atom(name: '_DashboardStore.fullName', context: context);

  @override
  String get fullName {
    _$fullNameAtom.reportRead();
    return super.fullName;
  }

  @override
  set fullName(String value) {
    _$fullNameAtom.reportWrite(value, super.fullName, () {
      super.fullName = value;
    });
  }

  late final _$loadUserDataAsyncAction =
      AsyncAction('_DashboardStore.loadUserData', context: context);

  @override
  Future<void> loadUserData() {
    return _$loadUserDataAsyncAction.run(() => super.loadUserData());
  }

  @override
  String toString() {
    return '''
dashboard: ${dashboard},
token: ${token},
userEmail: ${userEmail},
profileImage: ${profileImage},
fullName: ${fullName}
    ''';
  }
}
