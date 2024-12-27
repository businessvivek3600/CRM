
import 'package:crm/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/value_constants.dart';
import '../utils/picture_utils.dart';



/// Empty List Widget
class EmptyListWidget extends StatelessWidget {
  EmptyListWidget({
    Key? key,
    this.message,
    this.refresh,
    this.height = 100,
    this.width = 100,
    this.lottie,
    this.loading,
    this.content,
    this.loadingWidget,
    this.messageTextStyle,
  }) : super(key: key);
  final String? lottie;
  final String? message;
  final Function? refresh;
  double? height;
  double? width;
  final bool? loading;
  final Widget? loadingWidget;
  final Widget? content;
  TextStyle? messageTextStyle;

  @override
  Widget build(BuildContext context) {
    height = height ;
    width = width ;
    Widget refreshButton = TextButton.icon(
      onPressed: () => refresh?.call(),
      icon: const Icon(Icons.refresh),
      label: const Text('Retry'),
    );

    List<Widget> children = [
      content ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // if (lottie != null)
              //   assetLottie(
              //     lottie!,
              //     height: height,
              //     width: width,
              //   ),
              if (message != null)
                Text(
                  message!,
                  style: messageTextStyle ?? boldTextStyle(),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
              // .paddingBottom(DEFFAULT_PADDING),
      if (refresh != null) refreshButton,
    ];
    return Container(
      alignment: Alignment.center,
      child: loading != null && !loading!
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            )
          : loadingWidget ?? const CircularProgressIndicator(),
    );
  }
}
