import 'package:flutter/cupertino.dart';

class KeyboardUtil {
  static bool isKeyboardShowing() {
    if (WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom > 0) {
      return WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom > 0;
    } else {
      return false;
    }
  }

  static void hide(BuildContext context) {
    if(isKeyboardShowing()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }
}
