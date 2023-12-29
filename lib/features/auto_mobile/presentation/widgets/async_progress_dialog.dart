import 'dart:async';

import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';

/// Circular ProgressBar [showCircularProgress]
Align showCircularProgress({
  double height = 40,
  double width = 40,
  double strokeWidth = 5,
  Color? color,
}) =>
    Align(
      /*heightFactor: 1,
      widthFactor: 1,*/
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );

/// Show Async ProgressDialog loading Data
Future<void> showProgressDialog(
  BuildContext context, {
  Function? onSuccess,
  Function? onError,
  Widget? child,
  Future<dynamic>? request,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => AsyncProgressDialog(
      request,
      message: child ?? const Text('Searching...'),
      onError: onError,
      onSuccess: onSuccess,
    ),
  );
}

/// This code is an extension to the package flutter_progress_dialog (https://pub.dev/packages/future_progress_dialog)
/// Async ProgressDialog [AsyncProgressDialog]
class AsyncProgressDialog extends StatefulWidget {
  /// Dialog will be closed when [future] task is finished.
  @required
  final Future? future;

  /// [BoxDecoration] of [AsyncProgressDialog].
  final BoxDecoration? decoration;

  /// opacity of [AsyncProgressDialog]
  final double opacity;

  /// If you want to use custom progress widget set [progress].
  final Widget? progress;

  /// If you want to use message widget set [message].
  final Widget? message;

  /// On error handler
  final Function? onError;

  /// On success handler
  final Function? onSuccess;

  /// If TRUE, show Dialog Modal widget, else only circularProgressBar [isDialog].
  final bool isDialog;

  /// If SIZE set, width & height will inherit from SIZE [size].
  final double? size;

  /// Calculate time left to complete in circularProgressBar [loadProgress].
  final double? loadProgress;

  /// The relative position of the stroke on a [CircularProgressIndicator]
  final double strokeAlign;

  /// The width of the line used to draw the circle on a [CircularProgressIndicator]
  final double strokeWidth;

  /// Styles to use for line endings on a [CircularProgressIndicator]
  final StrokeCap? strokeCap;

  /// background color on a [CircularProgressIndicator]
  final Color? bgColor;

  const AsyncProgressDialog(
    this.future, {
    super.key,
    this.decoration,
    this.opacity = 1.0,
    this.progress,
    this.message,
    this.onError,
    this.onSuccess,
    this.isDialog = true,
    this.size,
    this.loadProgress,
    this.strokeAlign = 0.0,
    this.strokeCap,
    this.strokeWidth = 3.0,
    this.bgColor = Colors.white,
  });

  @override
  State<AsyncProgressDialog> createState() => _AsyncProgressDialogState();
}

class _AsyncProgressDialogState extends State<AsyncProgressDialog> {
  @override
  void initState() {
    _whenComplete();
    super.initState();
  }

  void _whenComplete() {
    if (widget.future != null) {
      widget.future!.then(
        (val) {
          if (widget.onSuccess != null) {
            widget.onSuccess!.call(val);
          }
          Navigator.of(context).pop(val);
        },
        onError: (e) {
          if (widget.onError != null) {
            widget.onError!.call(e);
          }
          Navigator.of(context).pop();
        },
      ).catchError((e) {
        widget.onError != null ? widget.onError!.call(e) : throw e;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
        child: _buildDialog(context),
        onPopInvoked: (_) => Future(() => false),
      );

  /// CircularProgressIndicator
  Widget _indicator() => CircularProgressIndicator(
        value: widget.loadProgress,
        strokeWidth: widget.strokeWidth,
        strokeAlign: widget.strokeAlign,
        strokeCap: widget.strokeCap,
        backgroundColor: widget.bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary),
      );

  Widget _buildDialog(BuildContext context) {
    final progressBarSize = widget.size;
    progressBarSize != null
        ? getProportionateScreenWidth(progressBarSize)
        : null;

    return widget.isDialog
        ? Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Opacity(
              opacity: widget.opacity,
              child: Center(child: _buildProgressBar(context)),
            ),
          )
        : Center(
            child: SizedBox(
              height: progressBarSize,
              width: progressBarSize,
              child: _indicator(),
            ),
          );
  }

  // Build progress bar
  Widget _buildProgressBar(BuildContext context) {
    bool hasMsg = widget.message == null;
    double width = hasMsg ? 100 : SizeConfig.screenWidth!;

    final defaultDecoration = BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );

    return Container(
      height: getProportionateScreenHeight(100),
      width: getProportionateScreenWidth(width),
      padding: EdgeInsets.all(hasMsg ? 0 : 20),
      alignment: hasMsg ? Alignment.center : Alignment.centerLeft,
      decoration: widget.decoration ?? defaultDecoration,
      child: hasMsg
          ? FittedBox(child: _indicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.progress ?? _indicator(),
                const SizedBox(width: 20),
                _buildText(context)
              ],
            ),
    );
  }

  Widget _buildText(BuildContext context) {
    if (widget.message == null) {
      return const SizedBox.shrink();
    }
    return Expanded(
      flex: 1,
      child: widget.message!,
    );
  }
}
