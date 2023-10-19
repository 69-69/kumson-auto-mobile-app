import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context,
  Widget message, {
  String title = 'Confirm',
  String positiveResponse = "Yes",
  String negativeResponse = "No",
  bool isDismissible = true,
}) async {
  var result = await showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: message,
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () async => Navigator.pop(context, true),
          child: Text(positiveResponse),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () async => Navigator.pop(context, false),
          child: Text(negativeResponse),
        ),
      ],
    ),
  );
  result ??= "cancel";
  return result;
}

/*AlertDialog(
      content: message,
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.borderRadius,
      ),
      actions: [
        textButton(positiveResponse, context, true),
        textButton(negativeResponse, context, false),
      ],
    ),
    SimpleButton textButton(
        String response, BuildContext context, bool responseStatus) =>
    SimpleButton(
      label: Text(response, style: const TextStyle(fontSize: 12)),
      onPress: () => Navigator.pop(context, responseStatus),
    );*/
