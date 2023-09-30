import 'package:flutter/material.dart';

// stores ExpansionPanel state information
class PanelModel {
  PanelModel({
    required this.id,
    required this.expandedValue,
    required this.headerValue,
  });

  int id;
  String headerValue;
  Widget expandedValue;
}