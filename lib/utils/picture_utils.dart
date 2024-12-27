import 'package:crm/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rive/rive.dart' as rive ;

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../constants/value_constants.dart';

Widget assetSvg(String path,
        {BoxFit? fit,
        bool fullPath = false,
        Color? color,
        double? width,
        double? height}) =>
    SvgPicture.asset(
      fullPath ? path : 'assets/svgs/$path',
      fit: fit ?? BoxFit.contain,
      color: color,
      width: width,
      height: height,
    );
Widget assetRive(String path, {BoxFit? fit, bool fullPath = false}) =>
    rive.RiveAnimation.asset(
      fullPath ? path : 'assets/rive/$path',
      fit: fit ?? BoxFit.contain,
    );
LottieBuilder assetLottie(String path,
        {BoxFit? fit,
        bool fullPath = false,
        double? width,
        double? height,
        LottieDelegates? delegates}) =>
    Lottie.asset(
      fullPath ? path : 'assets/lotties/$path',
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,
      delegates: delegates,
    );

Image assetImages(String path,
        {BoxFit? fit,
        bool fullPath = false,
        Color? color,
        double? width,
        double? height}) =>
    Image.asset(
      fullPath ? path : 'assets/images/$path',
      fit: fit ?? BoxFit.contain,
      color: color,
      width: width,
      height: height,
    );
Image netImages(
  String path, {
  Key? key,
  BoxFit? fit,
  BoxFit? fitP,
  bool fullPath = false,
  Color? color,
  double? width,
  double? height,
  double? widthP,
  double? heightP,
  String? placeholder,
  double? borderRadius,
  double? paddingP,
  bool useCache = false,
}) =>
    Image.network(
      path,
      key: key,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (!wasSynchronouslyLoaded) return child;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? DEFFAULT_RADIUS),
          child: AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
            child: !useCache
                ? child
                : buildCachedNetworkImage(
                    path,
                    h: heightP ?? height,
                    w: widthP ?? width,
                    borderRadius: borderRadius,
                    fit: fitP ?? fit,
                    fullPath: fullPath,
                    placeholder: placeholder,
                  ),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            height: heightP ?? height ?? 50,
            width: widthP ?? width ?? 100,
            child: Center(
                child: CircularProgressIndicator.adaptive(
                    backgroundColor:
                        getTheme(context).textTheme.bodyLarge?.color)),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => assetImages(
        placeholder ?? "",
        fit: fitP ?? fit,
        color: color,
        width: widthP ?? width,
        height: heightP ?? height,
      ).paddingAll(paddingP ?? 0),
    );

ImageProvider assetImageProvider(String path,
        {BoxFit? fit, bool fullPath = false}) =>
    AssetImage(fullPath ? path : 'assets/images/$path');

ImageProvider netImageProvider(String path,
        {BoxFit? fit, Color? color, double? width, double? height}) =>
    NetworkImage(path);

Widget buildCachedNetworkImage(String image,
    {double? h,
    double? w,
    double? borderRadius,
    BoxFit? fit,
    bool fullPath = false,
    String? placeholder}) {
  // return FastCachedImage(
  //   url: image,
  //   fit: fit ?? BoxFit.cover,
  //   width: w,
  //   height: h,
  //   fadeInDuration: const Duration(milliseconds: 300),
  //   errorBuilder: (context, exception, stacktrace) {
  //     return Text(stacktrace.toString());
  //   },
  //   filterQuality: FilterQuality.high,
  //   loadingBuilder: (context, progress) {
  //     return Container(
  //       color: Colors.yellow,
  //       child: Stack(
  //         alignment: Alignment.center,
  //         children: [
  //           if (progress.isDownloading && progress.totalBytes != null)
  //             Text(
  //                 '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
  //                 style: const TextStyle(color: Colors.red)),
  //           SizedBox(
  //               width: 120,
  //               height: 120,
  //               child: CircularProgressIndicator(
  //                   color: Colors.red,
  //                   value: progress.progressPercentage.value)),
  //         ],
  //       ),
  //     );
  //   },
  // );
  return LayoutBuilder(builder: (context, bound) {
    w ??= bound.maxWidth;
    return CachedNetworkImage(
      imageUrl: image,
      fit: fit ?? BoxFit.cover,
      imageBuilder: (context, image) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: image, fit: fit ?? BoxFit.cover))),
      ),
      placeholder: (context, url) => Center(
          child: SizedBox(
              height: h ?? 50,
              width: w ?? 100,
              child: Center(
                  child: CircularProgressIndicator(
                      color: getTheme(context).textTheme.bodyLarge?.color)))),
      errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          child: SizedBox(
              height: h ?? 50,
              width: w ?? 100,
              child: Center(child: assetImages(placeholder ?? "")))),
      cacheManager: null,
    );
  });
}

int inKB(int bytes) => (bytes / 1024).round();
int inMB(int bytes) => (bytes / (1024 * 1024)).round();
