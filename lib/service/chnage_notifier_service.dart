import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeNotifierService with ChangeNotifier {
  final SharedPreferences? prefs;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ChangeNotifierService({this.prefs});

  String _carPartState = "";

  setProductAge(String i) {
    _carPartState = i;
    prefs?.setString("partStatus", i);
    notifyListeners();
  }

  get getProductAge => prefs?.getString("partStatus") ?? _carPartState;

}
