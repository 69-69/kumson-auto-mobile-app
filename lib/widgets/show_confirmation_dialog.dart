import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
  BuildContext context,
  Widget message, {
  String title = 'Confirm',
  String positiveResponse = "Yes",
  String negativeResponse = "No",
}) async {
  var result = await showDialog(
    context: context,
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
    /*AlertDialog(
      content: message,
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.borderRadius,
      ),
      actions: [
        textButton(positiveResponse, context, true),
        textButton(negativeResponse, context, false),
      ],
    ),*/
  );
  result ??= false;
  return result;
}

/*SimpleButton textButton(
        String response, BuildContext context, bool responseStatus) =>
    SimpleButton(
      label: Text(response, style: const TextStyle(fontSize: 12)),
      onPress: () => Navigator.pop(context, responseStatus),
    );*/
