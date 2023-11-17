import 'dart:async';

import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/product_status_service.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/search_history_service.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/util/keyboard.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/repositories/home_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/_outline_btn_for_search.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/bottom_sheet/make_a_request_modal.dart';

class PartNoTextField extends StatefulWidget {
  const PartNoTextField({super.key});

  @override
  State<PartNoTextField> createState() => _PartNoTextFieldState();
}

class _PartNoTextFieldState extends State<PartNoTextField> {
  bool isSearching = false;
  String searchText = "";
  final FocusNode focusNode = FocusNode();
  TextEditingController txtControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return searchTextField(context);
  }

  TextFormField searchTextField(BuildContext context) {
    return TextFormField(
      key: const ValueKey("part_no"),
      controller: txtControl,
      focusNode: focusNode,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            isSearching = false;
            searchText = value;
          });
        }
      },
      decoration: inputDecoration(context),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }

  InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      isDense: true,
      /*prefixIcon: isSearching
          ? showCircularProgress(height: 12, width: 12, strokeWidth: 2)
          : null,*/
      prefixText: "Part No.",
      prefixStyle: const TextStyle(fontWeight: FontWeight.w600),
      hintText: " Enter your Part No...",
      alignLabelWithHint: true,
      /*border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
      ),*/
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      suffixIcon: outlinedButton(context),
      suffixIconConstraints: const BoxConstraints.expand(width: 60, height: 40),
    );
  }

  OutlinedButton outlinedButton(BuildContext context) {
    return outlinedBtnForSearch(
      context,
      isSearching: isSearching,
      onPress: () {
        setState(() => isSearching = true);
        _onPartNoSearchFun();
      },
    );
  }

  Future<void> _onPartNoSearchFun() async {
    if (searchText.isNotEmpty) {
      final getData = HomeRepositoryImpl().getHunterPartsByPartNo(searchText);

      // Show progressBar dialog/modal
      await showProgressDialog(context, getData);

      getData.then((List<HunterModel>? hunters) async {
        if (hunters != null && hunters.isNotEmpty) {
          //Save VIN as recent searches.
          await SearchHistoryDB()
              .saveTo(searchText, key: partNoSearchHistoryKey)
              .whenComplete(() {
            _navigating(context, hunters);
          });
        } else {

          await ProductStatusService()
              .saveReadOnly(searchText, key: readOnlyPartNoKey)
              .then((_) {
            _resetState();
            showRequestModal(context, partNoRequest);
          });
        }
      });
    }
  }

  _navigating(BuildContext context, List<HunterModel> hunters) {
    pageNavigator(
      context,
      routeName: partsByPartNoRoute,
      arguments: hunters,
    );

    _resetState();
  }

  void _resetState() {
    KeyboardUtil.hide(context);
    setState(() {
      isSearching = false;
      // searchText = "";
      // txtControl.text = "";
      focusNode.unfocus();
    });
  }
}

/*Dirty work Bloc
*

  OutlinedButton outlinedButton(BuildContext context) {
    return outlinedBtnForSearch(
      context,
      isSearching: isSearching,
      onPress: () {
        setState(() => isSearching = true);
        KeyboardUtil.hide(context);
        context
            .read<HunterPartsByPartNoBloc>()
            .add(GetHunterPartsByPartNo(searchText));
      },
    );
  }

  BlocListener<HunterPartsByPartNoBloc, HuntersState> _onPartNoSearchBloc(
      BuildContext context) {
    return BlocListener<HunterPartsByPartNoBloc, HuntersState>(
      // If listenWhen returns true, listener will be called with new state
      // listenWhen: (previousState, state) => state != previousState,

      listener: (bloContext, state) {
        if (isSearching && state is HuntersDone) {
          //Save PART-NO. as recent searches.
          /*await AppLocalDatabase().saveToRecentSearches(
            searchText,
            key: partNoSearchHistoryKey,
          );*/

          // if(bloContext.mounted){
          _navigating(context, state);

          _resetState();
          // }
        }
        if (state is HuntersError) {
          //debugPrint("Steven "+state.error!.type.name);
          _resetState();
          // if(bloContext.mounted) {
          showRequestModal(bloContext, "vinRequest");
          // }
        }
      },
      child: outlinedButton(context),
    );
  }
* */
