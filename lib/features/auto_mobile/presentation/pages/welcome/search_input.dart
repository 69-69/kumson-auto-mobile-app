import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/constants/search_type.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/index.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:string_capitalize/string_capitalize.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  String selectedSearchType = SearchType.vin.name;
  TextEditingController txtControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) =>
          previous.searchTerm != current.searchTerm,
      builder: (context, state) => _buildSearchFormField(context, state),
    );
  }

  // Search Input
  TextFormField _buildSearchFormField(BuildContext context, SearchState state) {
    final tColor = Theme.of(context).colorScheme;

    return TextFormField(
      controller: txtControl,
      keyboardType: TextInputType.text,
      key: const Key('searchForm_Input_textField'),
      onChanged: (input) =>
          context.read<SearchBloc>().add(SearchChanged(input)),
      onFieldSubmitted: (input) =>
          context.read<SearchBloc>().add(SearchChanged(input)),
      onSaved: (input) =>
          context.read<SearchBloc>().add(SearchChanged(input ?? '')),
      onEditingComplete: () =>
          context.read<SearchBloc>().add(SearchChanged(txtControl.text)),
      onTap: () =>
          context.read<SearchBloc>().add(SearchChanged(txtControl.text)),
      decoration: inputDecoration(tColor, context, state),
    );
  }

  InputDecoration inputDecoration(
      ColorScheme tColor, BuildContext context, SearchState state) {
    return InputDecoration(
      filled: true,
      labelText: "VIN or Part number",
      hintText: "VIN or Part number",
      fillColor: tColor.onPrimary.withOpacity(0.04),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      alignLabelWithHint: true,
      prefixIcon: searchTypeDropdown(context),
      prefixIconConstraints: const BoxConstraints(maxWidth: 50),
      suffixIcon: _SearchButton(
          searchType: selectedSearchType,
          isDone: (bool value) {
            if (value) {
              setState(() => txtControl.text = '');
            }
          }),
      suffixIconConstraints: const BoxConstraints(maxWidth: 70),
      errorText: state.searchTerm.displayError != null || state.getData == null
          ? 'Invalid VIN or Part number'
          : null,

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
          return SearchType.values.map<Widget>((SearchType boat) {
            return Row(
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
          }).toList();
        },
        items: SearchType.values
            .map<DropdownMenuItem<SearchType>>((SearchType type) {
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
        }).toList(),
      ),
    );
  }
}

// Button
class _SearchButton extends StatelessWidget {
  final String searchType;
  final Function(bool) isDone;

  const _SearchButton({
    required this.searchType,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    bool isVin = searchType.toLowerCase() == 'vin';

    return BlocConsumer<SearchBloc, SearchState>(
      // If listenWhen returns true, listener will be called with new state
      listenWhen: (preState, curtState) => preState != curtState,
      buildWhen: (preState, curtState) => preState != curtState,
      listener: (_, state) async {
        String loaderText = 'Searching by ${isVin ? 'VIN' : 'Part No'}...';

        if (state.status.isInProgress && state.isValid) {

          // Show progressBar dialog/modal
          await showProgressDialog(context,
            request: state.future,
            child: Text(loaderText),);
        } else {}
        if (context.mounted) {
          if (state.status.isSuccess && state.getData != null) {
            Map<String, dynamic> m = {'data': state.getData};
            String route = isVin ? vehicleDetailsRoute : partsByPartNoRoute;

            pageNavigator(context, routeName: route, arguments: m);
          } else if (state.status.isFailure) {
            _saveReadOnly(context,
                isVin: isVin, searchText: state.searchTerm.value);
          }
        }
      },
      builder: (context, state) {
        return state.status.isInProgress
            ? showCircularProgress(width: 15, height: 15)
            : elevatedBtn(context, state: state, isVin: isVin);
      },
    );
  }

  ElevatedButton elevatedBtn(
    BuildContext context, {
    required bool isVin,
    required SearchState state,
  }) =>
      buildElevatedBtn(
        context,
        label: "Search",
        elevation: 15.0,
        key: const Key('search_form_outlinedButton'),
        // onPress: state.status.isInProgress,
        onPress: state.isValid
            ? () async {
                context.read<SearchBloc>().add(SearchFormSubmitted(isVin));
                isDone(true);
              }
            : null,

        padding: const EdgeInsets.symmetric(horizontal: 10),
      );

  // Save this VIN for reference in Make-Request-Form
  Future<void> _saveReadOnly(
    BuildContext context, {
    required bool isVin,
    required String searchText,
  }) async {
    final key = isVin ? readOnlyVinCacheKey : readOnlyPartNoCacheKey;
    final req = isVin ? vinRequest : partNoRequest;

    await AppLocalService().saveReadOnly(searchText, key: key).then((_) {
      showRequestModal(context, req);
    });
  }
}
