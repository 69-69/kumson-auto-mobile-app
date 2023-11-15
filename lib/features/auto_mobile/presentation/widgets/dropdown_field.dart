// ignore_for_file: unnecessary_statements
// Ref:: https://github.com/officialismailshah/dropdownfield/blob/master/example/main.dart
// Ref:: https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///DropDownField has customized autocomplete text field functionality
///
///Parameters::
///
///value - dynamic - Optional value to be set into the Dropdown field by default when this field renders
///
///icon - Widget - Optional icon to be shown to the left of the Dropdown field
///
///hintText - String - Optional Hint text to be shown
///
///hintStyle - TextStyle - Optional styling for Hint text. Default is normal, gray colored font of size 18.0
///
///labelText - String - Optional Label text to be shown
///
///labelStyle - TextStyle - Optional styling for Label text. Default is normal, gray colored font of size 18.0
///
///required - bool - True will validate that this field has a non-null/non-empty value. Default is false
///
///isEnabled - bool - False will disable the field. You can unset this to use the Dropdown field as a read only form field. Default is true
///
///items - List<dynamic> - List of items to be shown as suggestions in the Dropdown. Typically a list of String values.
///You can supply a static list of values or pass in a dynamic list using a FutureBuilder
///
///textStyle - TextStyle - Optional styling for text shown in the Dropdown. Default is bold, black colored font of size 14.0
///
///inputFormatters - List<TextInputFormatter> - Optional list of TextInputFormatter to format the text field
///
///setter - FormFieldSetter<dynamic> - Optional implementation of your setter method. Will be called internally by Form.save() method
///
///onValueChanged - ValueChanged<dynamic> - Optional implementation of code that needs to be executed when the value in the Dropdown
///field is changed
///
///strict - bool - True will validate if the value in this dropdown is among those suggestions listed.
///False will let user type in new values as well. Default is true
///
///itemsVisibleInDropdown - int - Number of suggestions to be shown by default in the Dropdown after which the list scrolls. Defaults to 3

const _buildTextStyle = TextStyle(color: Colors.grey);

class DropDownField<T> extends FormField<String> {
  final dynamic value;
  final Widget? icon;
  final String? hintText;
  final TextStyle hintStyle;
  final String? labelText;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final bool isRequired;
  final bool isEnabled;
  final List<T>? items;
  final Key textFieldKey;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<dynamic>? setter;
  final ValueChanged<dynamic>? onValueChanged;
  final bool strict;
  final int itemsVisibleInDropdown;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  DropDownField(
    this.textFieldKey, {
    Key? key,
    this.controller,
    this.value,
    this.isRequired = false,
    this.icon,
    this.hintText,
    this.hintStyle = _buildTextStyle,
    this.labelText,
    this.labelStyle = _buildTextStyle,
    this.inputFormatters,
    this.items,
    this.textStyle = const TextStyle(),
    this.setter,
    this.onValueChanged,
    this.itemsVisibleInDropdown = 3,
    this.isEnabled = true,
    this.strict = true,
  }) : super(
          key: key,
          autovalidateMode: AutovalidateMode.disabled,
          initialValue: controller != null ? controller.text : (value ?? ''),
          onSaved: setter,
          builder: (FormFieldState<String> field) {
            final DropDownFieldState state = field as DropDownFieldState;
            final ScrollController scrollController = ScrollController();

            final InputDecoration effectiveDecoration = _buildInputDecoration(
              icon,
              state,
              hintStyle,
              labelStyle,
              hintText,
              labelText,
              isEnabled,
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        textFieldKey,
                        state,
                        effectiveDecoration,
                        field,
                        textStyle,
                        isRequired,
                        items,
                        strict,
                        setter,
                        isEnabled,
                        inputFormatters,
                      ),
                    ),
                  ],
                ),
                !state._showDropdown
                    ? const SizedBox.shrink()
                    : _buildCard(
                        items,
                        itemsVisibleInDropdown,
                        field,
                        scrollController,
                        state,
                      ),
              ],
            );
          },
        );

  static TextFormField _buildTextFormField(
    Key textFieldKey,
    DropDownFieldState<dynamic> state,
    InputDecoration effectiveDecoration,
    DropDownFieldState<dynamic> field,
    TextStyle textStyle,
    bool isRequired,
    List<dynamic>? items,
    bool strict,
    FormFieldSetter<dynamic>? setter,
    bool isEnabled,
    List<TextInputFormatter>? inputFormatters,
  ) {
    return TextFormField(
      key: textFieldKey,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autovalidateMode: AutovalidateMode.always,
      controller: state._effectiveController,
      decoration: effectiveDecoration.copyWith(
        errorText: field.errorText,
        fillColor:
            Theme.of(field.context).colorScheme.primary.withOpacity(0.04),
      ),
      style: textStyle,
      textAlign: TextAlign.start,
      autofocus: false,
      obscureText: false,
      maxLines: 1,
      validator: (String? newValue) {
        if (isRequired) {
          if (newValue == null || newValue.isEmpty) {
            return 'This field is required!';
          }
        }

        //Items null check added since there could be an initial brief period of time
        //when the dropdown items will not have been loaded
        if (items != null) {
          if (strict && newValue!.isNotEmpty && !items.contains(newValue)) {
            return 'Invalid value in this field!';
          }
        }

        return null;
      },
      onSaved: setter,
      enabled: isEnabled,
      inputFormatters: inputFormatters,
    );
  }

  static Widget _buildCard(
    List<dynamic>? items,
    int itemsVisibleInDropdown,
    DropDownFieldState<dynamic> field,
    ScrollController scrollController,
    DropDownFieldState<dynamic> state,
  ) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: itemsVisibleInDropdown * 48.0,
          //limit to default 3 items in dropDownList view and then remaining scrolls
          width: MediaQuery.of(field.context).size.width,
          child: ListView(
            cacheExtent: 0.0,
            scrollDirection: Axis.vertical,
            controller: scrollController,
            padding: const EdgeInsets.only(left: 40.0),
            children: ListTile.divideTiles(
              context: field.context,
              tiles: state._getChildren(state._items!),
            ).toList(),
          ),
        )
      ],
    );
  }

  static InputDecoration _buildInputDecoration(
    Widget? icon,
    DropDownFieldState state,
    TextStyle hintStyle,
    TextStyle labelStyle,
    String? hintText,
    String? labelText,
    bool enabled,
  ) {
    return InputDecoration(
      filled: true,
      isDense: true,
      icon: icon,
      alignLabelWithHint: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      prefixIcon: state._showDropdown ? _closeButton(enabled, state) : null,
      suffixIcon: IconButton(
        icon: const Icon(Icons.arrow_drop_down),
        onPressed: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          // ignore: invalid_use_of_protected_member
          state.setState(() => state._showDropdown = !state._showDropdown);
        },
      ),
      hintStyle: hintStyle,
      labelStyle: labelStyle,
      hintText: hintText,
      labelText: labelText,
    );
  }

  static IconButton _closeButton(bool enabled, DropDownFieldState state) =>
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          if (!enabled) return;
          state.clearValue();
        },
      );

  @override
  DropDownFieldState createState() => DropDownFieldState();
}

class DropDownFieldState<T> extends FormFieldState<String> {
  TextEditingController? _controller;
  bool _showDropdown = false;
  bool _isSearching = true;
  String _searchText = "";

  @override
  DropDownField get widget => super.widget as DropDownField;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  List<T>? get _items => widget.items as List<T>?;

  void toggleDropDownVisibility() {}

  void clearValue() {
    setState(() {
      _effectiveController!.text = '';
      _showDropdown = false;
    });
  }

  @override
  void didUpdateWidget(DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      }
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }

    _effectiveController!.addListener(_handleControllerChanged);

    _searchText = _effectiveController!.text;
  }

  @override
  void reset() {
    super.reset();
    setState(() => _effectiveController!.text = widget.initialValue!);
  }

  List<ListTile> _getChildren(List<T> items) {
    List<ListTile> childItems = [];
    for (T item in items) {
      if (_searchText.isNotEmpty) {
        if (item.toString().toUpperCase().contains(_searchText.toUpperCase())) {
          childItems.add(_getListTile(item.toString()));
        } else {
          // ended here steven
          setState(() => _showDropdown = false);
        }
      } else {
        // ended here steven
        setState(() => _showDropdown = false);
        childItems.add(_getListTile(item.toString()));
      }
    }
    if (_searchText.isNotEmpty && _showDropdown == false) {
      childItems.add(_getListTile(_searchText));
    }
    _isSearching ? childItems : [];
    return childItems;
  }

  ListTile _getListTile(String text) {
    return ListTile(
      key: ValueKey(text),
      dense: true,
      title: Text(
        text,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () {
        setState(() {
          _effectiveController!.text = text;
          _handleControllerChanged();
          _showDropdown = false;
          _isSearching = false;
          if (widget.onValueChanged != null) widget.onValueChanged!(text);
        });
      },
    );
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }

    if (_effectiveController!.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchText = "";
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchText = _effectiveController!.text;
        _showDropdown = true;
      });
    }
  }
}
