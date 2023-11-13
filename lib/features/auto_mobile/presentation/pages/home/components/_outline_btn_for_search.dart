import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:flutter/material.dart';

OutlinedButton outlinedBtnForSearch(
  BuildContext context, {
  bool isSearching = false,
  required void Function()? onPress,
}) {
  return OutlinedButton(
    onPressed: onPress,
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
    child: isSearching
        ? showCircularProgress(
            height: 13, width: 13, strokeWidth: 2, color: Colors.white)
        : const Icon(Icons.search, color: Colors.white, size: 25),
  );
}
