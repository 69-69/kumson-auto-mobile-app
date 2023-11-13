import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/dropdown_field.dart';

typedef MakeModelSearchOnFind<T> = Future<List<T>> Function(String text);

class MakeModelTypeAhead<T> extends StatelessWidget {
  final String hintText;
  final dynamic value;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? setter;
  final TextEditingController? controller;
  final MakeModelSearchOnFind<T> asyncItems;

  const MakeModelTypeAhead({
    super.key,
    required this.hintText,
    this.value,
    this.onChanged,
    required this.asyncItems,
    this.setter,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  StreamBuilder<dynamic> _buildBody(BuildContext context) {
    Future<List<dynamic>> response = _futureRequest();

    return StreamBuilder(
      stream: response.asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          // Show splashScreen while checking if SignedIn
            return _loadSpinner();
          default:
            return snapshot.hasData
                ? _buildDropDownField(snapshot.data)
                : const SizedBox.shrink();
        }
      },
    );
  }

  Future<List<dynamic>> _futureRequest() async {
    final List<T> onlineItems = [];
    onlineItems.addAll(await asyncItems("steve"));

    return onlineItems;
  }

  _buildDropDownField(List<T> items) => DropDownField<T>(
    ValueKey(hintText),
    strict: false,
    value: value,
    isRequired: true,
    hintText: hintText,
    labelText: hintText,
    items: items,
    // items: List<String>.from(items0),
    inputFormatters: [
      FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
    ],
    onValueChanged: onChanged,
    setter: setter,
    controller: controller,
  );

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 15, height: 15),
    );
  }
}

class Result<T> {
  final T? data;

  const Result({this.data});

//and here -->
  factory Result.fromJson(Map<String, dynamic> map) =>
      Result<T>(data: map['data']);

  static List<Result> fromJsonList(List obj) {
    debugPrint(obj.toString());
    return obj
        .map((dynamic i) => Result.fromJson(i as Map<String, dynamic>))
        .toList();
  }
}
