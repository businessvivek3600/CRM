import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

final Toastification toastfication = Toastification();

class TF {
  static ToastificationType get error => ToastificationType.error;
  static ToastificationType get success => ToastificationType.success;
  static ToastificationType get info => ToastificationType.info;
  static ToastificationType get warning => ToastificationType.warning;

  static ToastificationStyle get flat => ToastificationStyle.flat;
  static ToastificationStyle get flatColored => ToastificationStyle.flatColored;
  static ToastificationStyle get simple => ToastificationStyle.simple;
  static ToastificationStyle get fillColored => ToastificationStyle.fillColored;
  static ToastificationStyle get minimal => ToastificationStyle.minimal;

  static void show({
    required BuildContext context,
    ToastificationType type = ToastificationType.info,
    ToastificationStyle style = ToastificationStyle.flat,
    Duration autoCloseDuration = const Duration(seconds: 2),
    Widget? title,
    String? message,
    Widget? description,
    bool showProgressBar = false,
    bool dismissAll = true,
    bool closeOnClick = true,
    bool applyBlurEffect = false,
    bool showIcon = true,
    Function(ToastificationItem)? onTap,
    Function(ToastificationItem)? onCloseButtonTap,
    Function(ToastificationItem)? onAutoCompleteCompleted,
    Function(ToastificationItem)? onDismissed,
  }) {
    if (context.mounted == false) return;

    if (dismissAll) {
      toastfication.dismissAll();
    }

    toastfication.show(
      context: context,
      type: type,
      style: style,
      autoCloseDuration: autoCloseDuration,
      title: title,
      description: message != null ? Text(message) : description,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      icon: !showIcon
          ? const SizedBox.shrink()
          : Icon(
              type.icon,
              color: style == ToastificationStyle.flatColored ||
                      style == ToastificationStyle.fillColored
                  ? Colors.white
                  : type.color,
            ),
      primaryColor: type.color,
      backgroundColor: style == ToastificationStyle.flat
          ? Colors.white
          : type == ToastificationType.error
              ? Colors.red
              : type == ToastificationType.success
                  ? Colors.green
                  : type == ToastificationType.info
                      ? Colors.blue
                      : type == ToastificationType.warning
                          ? Colors.orange
                          : Colors.blue,
      foregroundColor: style == ToastificationStyle.flatColored ||
              style == ToastificationStyle.fillColored
          ? Colors.white
          : Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: showProgressBar,
      closeButtonShowType: CloseButtonShowType.always,
      closeOnClick: closeOnClick,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: applyBlurEffect,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) {
          print('Toast ${toastItem.id} tapped');
          onTap?.call(toastItem);
        },
        onCloseButtonTap: (toastItem) {
          print('Toast ${toastItem.id} close button tapped');
          toastfication.dismiss(toastItem);
          onCloseButtonTap?.call(toastItem);
        },
        onAutoCompleteCompleted: (toastItem) {
          print('Toast ${toastItem.id} auto complete completed');
          onAutoCompleteCompleted?.call(toastItem);
        },
        onDismissed: (toastItem) {
          print('Toast ${toastItem.id} dismissed');
          onDismissed?.call(toastItem);
        },
      ),
    );
  }
}

extension on ToastificationType {
  Color get color {
    switch (this) {
      case ToastificationType.error:
        return Colors.red;
      case ToastificationType.success:
        return Colors.green;
      case ToastificationType.info:
        return Colors.blue;
      case ToastificationType.warning:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case ToastificationType.error:
        return Icons.error;
      case ToastificationType.success:
        return Icons.check_circle;
      case ToastificationType.info:
        return Icons.info;
      case ToastificationType.warning:
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  String get name {
    switch (this) {
      case ToastificationType.error:
        return 'Error';
      case ToastificationType.success:
        return 'Success';
      case ToastificationType.info:
        return 'Info';
      case ToastificationType.warning:
        return 'Warning';
      default:
        return 'Info';
    }
  }

  int get index {
    switch (this) {
      case ToastificationType.error:
        return 3;
      case ToastificationType.success:
        return 1;
      case ToastificationType.info:
        return 2;
      case ToastificationType.warning:
        return 0;
      default:
        return 2;
    }
  }
}
