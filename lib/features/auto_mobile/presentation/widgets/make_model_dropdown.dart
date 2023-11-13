import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

typedef MakeModelSearchOnFind<T> = Future<List<T>> Function(String text);

void filterResults<T>(List<T> matches, String query) {
  matches.retainWhere(
      (s) => s.toString().toLowerCase().contains(query.toLowerCase()));
}

class MakeModelDropdown<T> extends StatefulWidget {
  final String hintText;
  final dynamic value;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? setter;
  final TextEditingController? controller;
  final MakeModelSearchOnFind<T> asyncItems;

  const MakeModelDropdown({
    super.key,
    required this.hintText,
    this.value,
    this.onChanged,
    required this.asyncItems,
    this.setter,
    this.controller,
  });

  @override
  State<MakeModelDropdown<T>> createState() => _MakeModelDropdownState<T>();
}

class _MakeModelDropdownState<T> extends State<MakeModelDropdown<T>> {
  bool _hideDropdown = false;
  final TextEditingController _typeAheadController = TextEditingController();

  void clearValue() {
    setState(() {
      _hideDropdown = true;
      _typeAheadController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return TypeAheadField<T>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _typeAheadController,
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
          hintText: widget.hintText,
          labelText: widget.hintText,
          suffixIcon: _typeAheadController.text.isNotEmpty ? _closeButton() : null,
          alignLabelWithHint: true,
        ),
      ).copyWith(
        inputFormatters: [
          FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
        ],
      ),
      suggestionsCallback: (pattern) async => await widget.asyncItems(pattern),
      itemBuilder: (context, T suggestion) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Text(suggestion.toString()),
      ),
      itemSeparatorBuilder: (context, index) => const Divider(height: 1),
      onSuggestionSelected: (T suggestion) {
        _typeAheadController.text = suggestion.toString();
        // Navigator.pop(context);
      },
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        elevation: 50.0,
        constraints: BoxConstraints(maxHeight: 3 * 48.0),
      ),
      hideOnEmpty: false,
      hideSuggestionsOnKeyboardHide: _hideDropdown,
      loadingBuilder: (_) => _loadSpinner(),
      noItemsFoundBuilder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text('...search not found!\nEnter your ${widget.hintText}'),
        ),
      ),
    );
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 15, height: 15),
    );
  }

  IconButton _closeButton() => IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => clearValue(),
      );

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
