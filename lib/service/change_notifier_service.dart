import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/flutter_session.dart';

class ChangeNotifierService with ChangeNotifier {
  static final session = FlutterSession();
  final SharedPreferences? prefs;

  static const partStatusKey = "partStatus";

  ChangeNotifierService({this.prefs});

  static setProductAge(bool i) async {
    String s = i ? "new" : "used";
    session.set(partStatusKey, s);

    // notifyListeners();
  }

  static Future<String> getProductAge() async => await session.get(partStatusKey) ?? "";
}
