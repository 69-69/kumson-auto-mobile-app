import 'package:flutter/material.dart';
import 'package:automasters/utils/size_config.dart';

/// Circular ProgressBar [showCircularProgress]
Center showCircularProgress({
  double height = 40,
  double width = 40,
  double strokeWidth = 5,
}) =>
    Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
        ),
      ),
    );

/// Show Async ProgressDialog
Future<void> showProgressDialog(
    BuildContext context, Future<dynamic> getParts) async =>
    await showDialog(
      context: context,
      builder: (context) => AsyncProgressDialog(
        getParts,
        message: const Text('Loading...'),
      ),
    );

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

  /// If TRUE, show Dialog Modal widget, else only circularProgressBar [isDialog].
  final bool isDialog;

  /// If SIZE set, width & height will inherit from SIZE [size].
  final double? size;

  /// Calculate time left to complete in circularProgressBar [loadProgress].
  final double? loadProgress;

  const AsyncProgressDialog(
    this.future, {
    Key? key,
    this.decoration,
    this.opacity = 1.0,
    this.progress,
    this.message,
    this.onError,
    this.isDialog = true,
    this.size,
    this.loadProgress,
  }) : super(key: key);

  @override
  State<AsyncProgressDialog> createState() => _AsyncProgressDialogState();
}

class _AsyncProgressDialogState extends State<AsyncProgressDialog> {
  @override
  void initState() {
    if (widget.future != null) {
      widget.future!.then((val) {
        Navigator.of(context).pop(val);
      }).catchError((e) {
        Navigator.of(context).pop();
        widget.onError != null ? widget.onError!.call(e) : throw e;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: _buildDialog(context),
        onWillPop: () => Future(() => false),
      );

  /// CircularProgressIndicator
  Widget _indicator() => CircularProgressIndicator(
        value: widget.loadProgress,
        strokeWidth: 3.0,
        backgroundColor: const Color(0xFFFFECDF),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF67952)),
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
