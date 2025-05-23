import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/app_config.dart';
import '../../common/extensions/logger_extension.dart';
import '../../constants/app/app_constants.dart';
import '../error_ui/error_viewer/dialog/errv_dialog_options.dart';
import '../error_ui/error_viewer/dialog/show_error_dialog.dart';
import '../error_ui/error_viewer/errv_options.dart';
import '../error_ui/error_viewer/snack_bar/errv_snack_bar_options.dart';
import '../error_ui/error_viewer/snack_bar/show_error_snackbar.dart';
import '../error_ui/error_viewer/toast/errv_toast_options.dart';
import '../error_ui/error_viewer/toast/show_error_toast.dart';

class CustomImage {
  CustomImage._();

  static Widget network(
    String imageUrl, {
    String? placeholderAssetImage,
    Widget Function(BuildContext, String)? placeholderBuilder,
    Widget Function(BuildContext, String, DownloadProgress)?
        progressIndicatorBuilder,
    Widget Function(BuildContext, String, dynamic)? errorBuilder,
    bool showError = false,
    bool showProgressIndicator = false,
    ErrorViewerOptions? errorViewerOptions,
    double? height,
    double? width,
    BoxFit? fit,
    Alignment alignment = Alignment.center,
    int? memCacheWidth,
    int? memCacheHeight,
    String? cacheKey,
    int? maxWidthDiskCache,
    int? maxHeightDiskCache,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    Color? placeholderForgroundColor,
    Key? key,
    Map<String, String>? httpHeaders,
    Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
    Duration? fadeOutDuration = const Duration(milliseconds: 1000),
    Curve fadeOutCurve = Curves.easeOut,
    Duration fadeInDuration = const Duration(milliseconds: 500),
    Curve fadeInCurve = Curves.easeIn,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    bool useOldImageOnUrlChange = false,
    Color? color,
    FilterQuality filterQuality = FilterQuality.low,
    BlendMode? colorBlendMode,
    Duration? placeholderFadeInDuration,
  }) {
    assert(placeholderBuilder == null || progressIndicatorBuilder == null);
    return CachedNetworkImage(
      color: color,
      colorBlendMode: colorBlendMode,
      fadeInCurve: fadeInCurve,
      fadeInDuration: fadeInDuration,
      fadeOutCurve: fadeOutCurve,
      fadeOutDuration: fadeOutDuration,
      filterQuality: filterQuality,
      httpHeaders: httpHeaders,
      imageBuilder: imageBuilder,
      key: key,
      matchTextDirection: matchTextDirection,
      placeholderFadeInDuration: placeholderFadeInDuration,
      repeat: repeat,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      cacheKey: cacheKey,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      imageUrl: imageUrl,
      placeholder: placeholderBuilder ??
          (progressIndicatorBuilder == null && !showProgressIndicator
              ? (context, url) {
                  return Shimmer.fromColors(
                    baseColor: shimmerBaseColor ?? Colors.black,
                    highlightColor: shimmerHighlightColor ?? Colors.black12,
                    child: SvgPicture.asset(
                      AppConstants.SVG_IMAGE_PLACEHOLDER,
                      width: width,
                      height: height,
                      fit: fit ?? BoxFit.contain,
                      alignment: alignment,
                      colorFilter: placeholderForgroundColor != null
                          ? ColorFilter.mode(
                              placeholderForgroundColor,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                  );
                }
              : null),
      errorWidget: errorBuilder ??
          (context, url, error) {
            if (showError) {
              if (errorViewerOptions is ErrVSnackBarOptions) {
                showErrorSnackBar(
                  message: error.toString(),
                  errVSnackBarOptions: errorViewerOptions,
                );
              } else if (errorViewerOptions is ErrVToastOptions) {
                showErrorToast(
                  message: error.toString(),
                  errVToastOptions: errorViewerOptions,
                );
              } else if (errorViewerOptions is ErrVDialogOptions) {
                showCustomErrorDialog(
                  context: AppConfig().appContext!,
                  message: error.toString(),
                  errVDialogOptions: errorViewerOptions,
                );
              } else {
                error.toString().logE;
              }
            }
            return placeholderAssetImage == null
                ? SvgPicture.asset(
                    AppConstants.SVG_IMAGE_PLACEHOLDER,
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.contain,
                    alignment: alignment,
                    colorFilter: placeholderForgroundColor != null
                        ? ColorFilter.mode(
                            placeholderForgroundColor,
                            BlendMode.srcIn,
                          )
                        : null,
                  )
                : CustomImage.asset(
                    placeholderAssetImage,
                    width: width,
                    height: height,
                    fit: fit,
                    alignment: alignment,
                    color: placeholderForgroundColor,
                  );
          },
      progressIndicatorBuilder: progressIndicatorBuilder ??
          (placeholderBuilder == null && showProgressIndicator
              ? (context, url, progress) {
                  if (progress.totalSize == null)
                    return SvgPicture.asset(
                      AppConstants.SVG_IMAGE_PLACEHOLDER,
                      width: width,
                      height: height,
                      fit: fit ?? BoxFit.contain,
                      alignment: alignment,
                      colorFilter: placeholderForgroundColor != null
                          ? ColorFilter.mode(
                              placeholderForgroundColor,
                              BlendMode.srcIn,
                            )
                          : null,
                    );
                  return CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    color: Colors.cyan,
                    value: progress.downloaded / progress.totalSize!,
                  );
                }
              : null),
    );
  }

  static Widget asset(
    String imagePath, {
    Key? key,
    double? scale,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final isSvg = imagePath.endsWith('svg');
    return isSvg
        ? SvgPicture.asset(
            imagePath,
            key: key,
            width: width,
            height: height,
            colorFilter: color != null
                ? ColorFilter.mode(
                    color,
                    colorBlendMode ?? BlendMode.srcIn,
                  )
                : null,
            fit: fit ?? BoxFit.contain,
            alignment: alignment,
          )
        : Image.asset(
            imagePath,
            key: key,
            scale: scale,
            width: width,
            height: height,
            color: color,
            fit: fit,
            alignment: alignment,
            colorBlendMode: colorBlendMode,
          );
  }

  static Widget memory(
    String base64Image, {
    Key? key,
    double scale = 1.0,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    try {
      final bytes = base64Decode(base64Image);
      return Image.memory(
        bytes,
        key: key,
        scale: scale,
        width: width,
        height: height,
        color: color,
        fit: fit,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
      );
    } catch (e) {
      e.toString().logE;
      return SvgPicture.asset(
        AppConstants.SVG_IMAGE_PLACEHOLDER,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        alignment: alignment,
      );
    }
  }
}
