import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';

typedef AsyncSearchItems<T> = Future<List<T>> Function(String text);

class CustomDropdown<T> extends StatefulWidget {
  final String hintText;
  final dynamic value;
  final Function(dynamic) onChanged;
  final TextEditingController? controller;
  final AsyncSearchItems<T> asyncItems;

  const CustomDropdown({
    super.key,
    required this.hintText,
    this.value,
    required this.onChanged,
    required this.asyncItems,
    this.controller,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final FocusNode _focusNode = FocusNode();
  SuggestionsBoxController? _suggestionsBoxController;
  final TextEditingController _typeAheadController = TextEditingController();

  void _clearValue() {
    setState(() {
      _typeAheadController.clear();
      _suggestionsBoxController?.toggle();
    });
  }

  @override
  void initState() {
    _typeAheadController.addListener(() {
      if (_typeAheadController.text == "") {
        _suggestionsBoxController?.toggle();
      }
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _suggestionsBoxController?.toggle();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return TypeAheadFormField<T>(
      key: ValueKey(widget.hintText),
      textFieldConfiguration: _textFieldConfiguration(context),
      loadingBuilder: (_) => _loadSpinner(),
      suggestionsCallback: (pattern) async => await widget.asyncItems(pattern),
      itemBuilder: (context, T suggestion) => _itemBuilder(suggestion),
      itemSeparatorBuilder: (context, index) => const Divider(height: 1),
      onSuggestionSelected: (T suggestion) {
        debugPrint("onSuggestionSelected $suggestion");
        if(suggestion.toString().contains("Others: specify")){
          _suggestionsBoxController?.close();
        }
        // suggestion is OBJECT of type T
        // suggestion.toString() is STRING of type T
        widget.onChanged(suggestion);
        setState(() => _typeAheadController.text = suggestion.toString());
        // Navigator.pop(context);
      },
      onReset: () {},
      hideOnEmpty: false,
      suggestionsBoxController: _suggestionsBoxController,
      suggestionsBoxDecoration: _suggestionsBoxDecoration(),
      noItemsFoundBuilder: (context) => _noItemsFoundBuilder(),
      validator: (value) =>
          value!.isEmpty ? '${widget.hintText} is required' : null,
    );
  }

  SuggestionsBoxDecoration _suggestionsBoxDecoration() {
    return const SuggestionsBoxDecoration(
      elevation: 50.0,
      constraints: BoxConstraints(maxHeight: 3 * 48.0),
    );
  }

  _noItemsFoundBuilder() {
    return InkWell(
      onTap: (){
        widget.onChanged("others");
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text('...search not found!\nEnter Other ${widget.hintText}'),
        ),
      ),
    );
  }

  Row _itemBuilder(suggestion) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Text(suggestion.toString()),
        ),
      ],
    );
  }

  TextFieldConfiguration _textFieldConfiguration(BuildContext context) {
    return TextFieldConfiguration(
      focusNode: _focusNode,
      controller: _typeAheadController,
      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        hintText: widget.hintText,
        labelText: widget.hintText,
        suffixIcon: _typeAheadController.text != "" ? _closeButton() : null,
        alignLabelWithHint: true,
      ),
    ); /*.copyWith(
      inputFormatters: [
        FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),
      ],
    )*/
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 15, height: 15),
    );
  }

  IconButton _closeButton() => IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _clearValue(),
      );
}
