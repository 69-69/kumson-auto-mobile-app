import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:flutter/material.dart';

OutlinedButton outlinedBtnForSearch(
  BuildContext context, {
  Key? key,
  bool isPressed = false,
  required void Function()? onPress,
  MaterialStatesController? buttonController,
}) {
  return OutlinedButton(
    key: key,
    onPressed: onPress,
    statesController: buttonController,
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.zero,
      side: const BorderSide(width: 1.0, color: Colors.transparent),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
    child: isPressed
        ? showCircularProgress(
            height: 13, width: 13, strokeWidth: 2, color: Colors.white)
        : const Icon(Icons.search, color: Colors.white, size: 25),
  );
}
