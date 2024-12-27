// SurfaceAlert is a widget that displays a surface alert. with information, warning, error, success, or other types of messages. it takes a title, a message, and an icon dynamically and displays them in a surface alert. it also takes a button to dismiss the alert. or action button to perform an action.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constants/value_constants.dart';
import '../../utils/text.dart';


enum SurfaceAlertType { info, warning, error, success }

extension SurfaceAlertTypeExtension on SurfaceAlertType {
  Color get color {
    switch (this) {
      case SurfaceAlertType.info:
        return Colors.blue;
      case SurfaceAlertType.warning:
        return Colors.orange;
      case SurfaceAlertType.error:
        return Colors.red;
      case SurfaceAlertType.success:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case SurfaceAlertType.info:
        return Icons.info_rounded;
      case SurfaceAlertType.warning:
        return Icons.warning_rounded;
      case SurfaceAlertType.error:
        return Icons.error_rounded;
      case SurfaceAlertType.success:
        return Icons.check_circle_rounded;
      default:
        return Icons.info;
    }
  }

  String get name {
    switch (this) {
      case SurfaceAlertType.info:
        return 'Info';
      case SurfaceAlertType.warning:
        return 'Warning';
      case SurfaceAlertType.error:
        return 'Error';
      case SurfaceAlertType.success:
        return 'Success';
      default:
        return 'Info';
    }
  }

  int get index {
    switch (this) {
      case SurfaceAlertType.info:
        return 2;
      case SurfaceAlertType.warning:
        return 3;
      case SurfaceAlertType.error:
        return 4;
      case SurfaceAlertType.success:
        return 1;
      default:
        return 2;
    }
  }

  static SurfaceAlertType fromInt(i) {
    switch (i) {
      case 1:
        return SurfaceAlertType.info;
      case 2:
        return SurfaceAlertType.warning;
      case 3:
        return SurfaceAlertType.error;
      case 4:
        return SurfaceAlertType.success;
      default:
        return SurfaceAlertType.warning;
    }
  }
}

enum SurfaceAlertActionType { dismiss, action, none }

enum SurfaceAlertStyle { card, banner, floating, fill, outline, flat }

class SurfaceAlert extends StatelessWidget {
  final SurfaceAlertType type;
  final SurfaceAlertStyle style;
  final SurfaceAlertActionType actionType;
  final String? title;
  final String message;
  final IconData? leadingIcon;
  final String? buttonText;
  final Function()? buttonAction;
  final Function()? onDismiss;
  final Widget? action;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const SurfaceAlert({
    Key? key,
    this.title,
    required this.message,
    this.leadingIcon,
    this.buttonText,
    this.buttonAction,
    this.onDismiss,
    this.type = SurfaceAlertType.info,
    this.style = SurfaceAlertStyle.flat,
    this.actionType = SurfaceAlertActionType.action,
    this.action,
    this.titleStyle,
    this.messageStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (style == SurfaceAlertStyle.card)
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: type.color,
            child: Column(
              children: [
                topTile(context),
                _bottomWidget(),
              ],
            ),
          ),
        if (style == SurfaceAlertStyle.banner)
          Container(
            color: type.color,
            child: Column(
              children: [
                topTile(context),
                _bottomWidget(),
              ],
            ),
          ),
        if (style == SurfaceAlertStyle.floating)
          Container(
            decoration: BoxDecoration(
              color: type.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                topTile(context),
                _bottomWidget(),
              ],
            ),
          ),
        if (style == SurfaceAlertStyle.fill)
          Container(
            color: type.color,
            child: Column(
              children: [
                topTile(context),
                _bottomWidget(),
              ],
            ),
          ),
        if (style == SurfaceAlertStyle.outline)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: type.color.withOpacity(0.7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                topTile(context),
                _bottomWidget(),
              ],
            ),
          ),
        if (style == SurfaceAlertStyle.flat)
          Container(
            color: Colors.transparent,
            child: Column(
              children: [
                topTile(context),
                _bottomWidget(),
              ],
            ),
          ),
      ],
    );
  }

  Widget topTile(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: DEFFAULT_PADDING / 2, vertical: DEFFAULT_PADDING / 2),
        child: Row(
          crossAxisAlignment: title.isEmptyOrNull
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            _leading(context),
            DEFFAULT_PADDING.toInt().width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tilte(context).paddingBottom(title.isEmptyOrNull ? 0 : 4),
                  _subTitle(context),
                ],
              ),
            ),
            DEFFAULT_PADDING.toInt().width,
            _trailing() ?? const SizedBox(),
          ],
        ));
    return ListTile(
      contentPadding:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 0),
      leading: _leading(context),
      title: title != null ? _tilte(context) : _subTitle(context),
      subtitle: title != null ? _subTitle(context) : const SizedBox(),
      trailing: _trailing(),
    );
  }

  /// bottom widget
  Widget _bottomWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DEFFAULT_PADDING / 2),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: redColor,
      ),
      child: action ??
          Wrap(
            alignment: WrapAlignment.end,
            children: [
              if (!buttonText.isEmptyOrNull &&
                  actionType == SurfaceAlertActionType.action)
                TextButton(
                  onPressed: buttonAction,
                  child: Text(buttonText!,
                      style: const TextStyle(color: Colors.white)),
                ),
              //dismiss button
              // if (actionType == SurfaceAlertActionType.dismiss)
              //   TextButton(
              //     onPressed: onDismiss,
              //     child: const Text('Dismiss',
              //         style: TextStyle(color: Colors.white)),
              //   ),
            ],
          ),
    );
  }

  Widget _leading(BuildContext context) {
    return Icon(
      leadingIcon ?? type.icon,
      color:
          style == SurfaceAlertStyle.flat || style == SurfaceAlertStyle.outline
              ? type.color
              : Colors.white,
    );
  }

  Widget _tilte(BuildContext context) {
    return title == null
        ? Container()
        : bodyMedText(title!, context,
            style: titleStyle ??
                GoogleFonts.poppins(
                  fontSize: 12,
                  color: style == SurfaceAlertStyle.flat
                      ? type.color
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ));
  }

  Widget _subTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        capText(message, context,
            autoSize: true,
            style: messageStyle ??
                GoogleFonts.aBeeZee(
                    fontSize: title.isEmptyOrNull ? 12 : 10,
                    fontWeight: title.isEmptyOrNull
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: style == SurfaceAlertStyle.flat
                        ? type.color
                        : Colors.white)),
      ],
    );
  }

  Widget? _trailing() {
    return onDismiss != null
        ? Container(
            // decoration: const BoxDecoration(color: Colors.white),
            child: const Icon(Icons.clear_rounded, color: Colors.white),
          ).onTap(onDismiss, borderRadius: radius(50))
        : null;
  }
}
