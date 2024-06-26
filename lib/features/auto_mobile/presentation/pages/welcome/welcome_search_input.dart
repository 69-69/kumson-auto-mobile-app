import 'package:flutter/material.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/constants/search_type.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/repositories/search_repository_impl.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:string_capitalize/string_capitalize.dart';

class WelcomeSearchInput extends StatefulWidget {
  const WelcomeSearchInput({super.key});

  @override
  State<WelcomeSearchInput> createState() => WelcomeSearchInputState();
}

class WelcomeSearchInputState extends State<WelcomeSearchInput> {
  bool isSearching = false;
  String selectedSearchType = SearchType.vin.name;
  TextEditingController txtControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildSearchFormField(context);
  }

  // Search Input
  TextFormField _buildSearchFormField(BuildContext context) {
    final tColor = Theme.of(context).colorScheme;

    return TextFormField(
      controller: txtControl,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      key: const Key('searchForm_Input_textField'),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            txtControl.text = value;
            isSearching = false;
          });
          // debugPrint("searchText:: $value");
        }
      },
      decoration: inputDecoration(tColor, context),
    );
  }

  InputDecoration inputDecoration(ColorScheme tColor, BuildContext context) {
    return InputDecoration(
      filled: true,
      alignLabelWithHint: true,
      labelText: "VIN or Part number",
      hintText: "VIN or Part number",
      labelStyle: const TextStyle(fontSize: 13),
      hintStyle: const TextStyle(fontSize: 13),
      fillColor: tColor.onPrimary.withOpacity(0.04),
      contentPadding:EdgeInsets.only(
        top: 2.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
        right: 2.0,
        left: 2.0,
      ),
      prefixIcon: searchTypeDropdown(context),
      prefixIconConstraints: const BoxConstraints(maxWidth: 50),
      suffixIcon: _SearchButton(
        searchType: selectedSearchType,
        searchText: txtControl.text,
        isSearching: isSearching,
        isPressed: (bool value) {
          if (value) {
            setState(() => isSearching = true);
          } else {
            setState(() {
              txtControl.clear();
              isSearching = false;
            });
          }
        },
      ),
      suffixIconConstraints: const BoxConstraints(maxWidth: 70),

      /*border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),*/
    );
  }

  searchTypeDropdown(BuildContext context) {
    // List<String> list = SearchType.values.map((e) => e.name).toList();
    final tColor = Theme.of(context).colorScheme.primary;

    return DropdownButtonHideUnderline(
      child: DropdownButton<SearchType>(
        key: const Key('Search_type_dropdown'),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: tColor,
          size: 13,
          semanticLabel: "Search Dropdown Option",
        ),
        value: SearchType.vin,
        isDense: true,
        isExpanded: true,
        /*requestFocusOnTap: true,
        label: Text(
          selectedSearchType.toUpperCase(),
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        selectedTrailingIcon: const SizedBox.shrink(),
        inputDecorationTheme:  InputDecorationTheme(
          constraints: const BoxConstraints(maxWidth: 60),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          isDense: true,
          alignLabelWithHint: true,
          suffixIconColor:Theme.of(context).colorScheme.primary
          // filled: true,
          // fillColor: Theme.of(context).colorScheme.primary,
        ),*/
        onChanged: (SearchType? type) {
          setState(() => selectedSearchType = type!.name);
        },
        selectedItemBuilder: (BuildContext context) {
          return SearchType.values
              .map<Widget>((SearchType boat) => _selectedItemBuilder(tColor))
              .toList();
        },
        items: SearchType.values
            .map<DropdownMenuItem<SearchType>>(
                (SearchType type) => _items(type))
            .toList(),
      ),
    );
  }

  DropdownMenuItem<SearchType> _items(SearchType type) {
    return DropdownMenuItem<SearchType>(
      value: type,
      child: Text(
        type.name == 'part' ? 'Part No.' : type.name.capitalize(),
        style: const TextStyle(
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Row _selectedItemBuilder(Color tColor) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "${selectedSearchType.capitalizeEach()}:",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: tColor,
                ),
              ),
            ),
          ),
        ],
      );
}

// Button
class _SearchButton extends StatelessWidget {
  final String searchType;
  final String searchText;
  final bool isSearching;
  final Function(bool) isPressed;

  const _SearchButton({
    required this.searchType,
    required this.searchText,
    required this.isPressed,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    return isSearching
        ? showCircularProgress(width: 15, height: 15)
        : elevatedBtn(context);
  }

  ElevatedButton elevatedBtn(BuildContext context) => buildElevatedBtn(
        context,
        label: "Search",
        elevation: 15.0,
        key: const Key('search_form_outlinedButton'),
        onPress:
            searchText.isNotEmpty ? () async => _onSearchFun(context) : null,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      );

  Future<void> _onSearchFun(BuildContext context) async {
    isPressed(true);
    bool isVin = searchType.toLowerCase() == 'vin';

    if (isVin) {
      final request = SearchRepositoryImpl().getVehicleByVin(searchText);
      await _onSearchStart<VehicleModel?>(
        context,
        request: request,
        isVin: isVin,
      );
    } else {
      final request = SearchRepositoryImpl().getHunterPartsByPartNo(searchText);
      await _onSearchStart<List<HunterModel>?>(context, request: request);
    }
  }

  Future<void> _onSearchStart<T>(
    BuildContext context, {
    bool isVin = false,
    required Future<dynamic> request,
  }) {
    String loaderText = 'Searching by ${isVin ? 'VIN' : 'Part No'}...';

    return showProgressDialog(context,
        request: request,
        child: Text(loaderText), onSuccess: (dynamic data) async {
      if (data != null && data.isNotEmpty) {
        //Save VIN as recent searches
        // String key = isVin ? vinSearchHistoryCacheKey : partNoSearchHistoryCacheKey;
        await AppLocalService()
            .saveHistory(isVin ? searchText : data[1],
                key: vinSearchHistoryCacheKey)
            .whenComplete(() => _whenComplete(
                  context,
                  isVin: isVin,
                  data: isVin ? data : data[0],
                ));
      } else {
        isPressed(false);
        await _saveReadOnly(context, isVin: isVin);
      }
    }, onError: (e) async {
      isPressed(false);
      await _saveReadOnly(context, isVin: isVin);
    });
  }

  // navigate to vehicle page
  void _whenComplete(
    BuildContext context, {
    bool isVin = false,
    dynamic data,
  }) {
    String route = isVin ? vehicleDetailsRoute : partsByPartNoRoute;

    // if isVin is TRUE, then create a key-value MAP, else return Parts data
    Object? args = isVin ? {'vehicle': data} : data;

    isPressed(false);
    pageNavigator(context, routeName: route, arguments: args);
  }

// Save this VIN for reference in Make-Request-Form
  Future<void> _saveReadOnly(
    BuildContext context, {
    required bool isVin,
  }) async {
    String key = isVin ? sendRequestVinCacheKey : sendRequestPartNoCacheKey;
    final req = isVin ? vinRequest : partNoRequest;

    await AppLocalService().saveReadOnly(searchText, key: key).whenComplete(
          () => showRequestModal(context, req),
        );
  }
}
