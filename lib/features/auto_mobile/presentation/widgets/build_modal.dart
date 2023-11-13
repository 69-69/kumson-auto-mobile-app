import 'package:flutter/material.dart';

Future<dynamic> buildModal(
  BuildContext context,
  Widget child, {
  Color? bgColor,
  Color? barColor,
}) =>
    showModalBottomSheet(
        enableDrag: true,
        showDragHandle: true,
        isDismissible: true,
        isScrollControlled: true,
        // shape: roundedRectangleBorder(),
        backgroundColor: bgColor ?? Theme.of(context).colorScheme.background,
        barrierColor: barColor ?? const Color.fromRGBO(0, 0, 0, 0.5),
        context: context,
        builder: (_) => child);

/*Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
              return const ModelMakeModal();
        },
      )*/
