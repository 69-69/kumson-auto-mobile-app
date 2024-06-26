import 'package:flutter/material.dart';

class IntToIcon {

  /// Convert int to IconData Constructor
  IntToIcon._privateConstructor();

  // Convert int to IconData for use in Icon Widget
  static toIcon({required icon, String family = 'MaterialIcons'}) => IconData(icon, fontFamily: 'MaterialIcons');
}
