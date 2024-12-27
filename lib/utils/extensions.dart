import 'package:flutter/gestures.dart';

import 'package:go_router/go_router.dart';

///error packages
// import 'package:responsive_framework/responsive_breakpoints.dart';
///new package
import 'package:responsive_framework/responsive_framework.dart';
import '../constants/app_constants.dart';
import '../constants/enums.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';


import 'package:flutter/material.dart';

extension strEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color:  AppConst.defaultPrimaryColor,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset("MyPng.icNoPhoto",
            height: size ?? 24, width: size ?? 24);
      },
    );
  }

  String capitalizeEachWord() {
    if (validate().isEmpty) {
      return '';
    }

    final capitalizedWords = split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      final firstLetter = word[0].toUpperCase();
      final remainingLetters = word.substring(1).toLowerCase();
      return '$firstLetter$remainingLetters';
    });

    return capitalizedWords.join(' ');
  }

  ///to double with dynamic decimal
  double convertDouble([int decimal = 2]) {
    return (double.tryParse(this) ?? 0.0).toStringAsFixed(decimal).toDouble();
  }

  // URLType get urlType => checkURLType(this);

  String get hideHtmlTags => replaceAll(RegExp(r'<[^>]*>'), '');
}

extension numExt on num? {
  // to double with dynamic decimal
  double convertDouble([int decimal = 2]) {
    String value = (this ?? 0).toStringAsFixed(decimal);
    return value.convertDouble(decimal);
  }
}

extension listExt<E> on Iterable<E> {
  /// firstWhereOrNull
  E? firstWhereOrNull(bool Function(E) test, {E Function()? orElse}) {
    try {
      return firstWhere(test);
    } catch (e) {
      return orElse?.call();
    }
  }
}

extension skeleton on Widget {
  Widget size(double width, double height) =>
      SizedBox(width: width, height: height, child: this);

  Widget width(double width) => SizedBox(width: width, child: this);

  Widget skeletonize({
    required bool enabled,
    double textRadius = 3.0,
    Color? baseColor,
    Color? highlightColor,
    bool ignoreContainers = false,
    bool ignorePointers = true,
    bool justifyMultiLineText = false,
  }) {
    return Builder(builder: (context) {
      return Skeletonizer(
        enabled: enabled,
        containersColor:
            baseColor ?? context.theme.dividerColor.withOpacity(0.2),
        ignoreContainers: ignoreContainers,
        ignorePointers: ignorePointers,
        justifyMultiLineText: justifyMultiLineText,
        effect: ShimmerEffect(
          duration: const Duration(milliseconds: 2000),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          baseColor: baseColor ?? context.theme.dividerColor.withOpacity(0.2),
          highlightColor: highlightColor ?? context.theme.highlightColor,
        ),
        textBoneBorderRadius:
            TextBoneBorderRadius(BorderRadius.circular(textRadius)),
        child: this,
      );
    });
  }

  Widget constraints({
    double? maxHeight,
    double? maxWidth,
    double? minHeight,
    double? minWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0,
        minWidth: minWidth ?? 0,
      ),
      child: this,
    );
  }

  /// add badge to widget
  Widget badge({
    Color? bgColor,
    bool isLabelVisible = true,
    Widget? label,
    Offset offset = const Offset(0, 0),
  }) {
    return Badge(
      isLabelVisible: isLabelVisible,
      label: label,
      offset: offset,
      backgroundColor: bgColor,
      child: this,
    );
  }

  Widget onHover({
    ValueChanged<bool>? onEnter,
    ValueChanged<bool>? onExit,
    ValueChanged<PointerHoverEvent>? onHover,
    MouseCursor? cursor,
  }) {
    return MouseRegion(
      onEnter: (e) => onEnter?.call(true),
      onExit: (e) => onExit?.call(false),
      onHover: (e) => onHover?.call(e),
      cursor: cursor ?? SystemMouseCursors.click,
      child: this,
    );
  }
}

extension Rs on BuildContext {
  mounted() => this.mounted;
  ResponsiveBreakpointsData rsd() => ResponsiveBreakpoints.of(this);
  bool mobile() => ResponsiveBreakpoints.of(this).isMobile;
  bool phone() => ResponsiveBreakpoints.of(this).isPhone;
  bool tablet() => ResponsiveBreakpoints.of(this).isTablet;
  bool desktop() => ResponsiveBreakpoints.of(this).isDesktop;
  bool large() => ResponsiveBreakpoints.of(this).largerThan(DESKTOP);
  bool largeThan(String name) =>
      ResponsiveBreakpoints.of(this).largerThan(name);

  GoRouter router() => GoRouter.of(this);

  /// show snackbar

  void showSnackBar({
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    Color? bgColor,
    Color? textColor,
    double? fontSize,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 16,
          ),
        ),
        backgroundColor: bgColor ?? theme.primaryColor,
        duration: duration,
        action: action,
        behavior: behavior,
      ),
    );
  }
}

/// iterable
extension IterableExt<E> on Iterable<E> {
  /// reverse and return a new list

  List<E> reversedList() {
    return toList().reversed.toList();
  }
}
