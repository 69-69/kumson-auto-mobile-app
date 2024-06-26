import 'package:flutter/material.dart';
import 'package:automasters/core/util/keyboard.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/_outline_btn_for_search.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/repositories/search_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';

class VinTextField extends StatefulWidget {
  const VinTextField({super.key});

  @override
  State<VinTextField> createState() => _VinTextFieldState();
}

class _VinTextFieldState extends State<VinTextField> {
  String searchText = "";
  bool isSearching = false;
  Map<String, dynamic>? oldState;
  final FocusNode focusNode = FocusNode();
  MaterialStatesController? buttonController;
  TextEditingController txtControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return searchTextField(context);
  }

  TextFormField searchTextField(BuildContext context/*, SearchState state*/) {
    /*if (widget.vin.isNotEmpty) {
      setState(() => vinSearchTerm = widget.vin);
      txt.text = widget.vin;
    }*/
    return TextFormField(
      key: const ValueKey("vin"),
      controller: txtControl,
      focusNode: focusNode,
      /*onTap: () {
        if (txtControl.text.isNotEmpty) {
          context.read<SearchBloc>().add(SearchChanged(txtControl.text));
          debugPrint("tControl ${txtControl.text}---${state.results}");
        }
      },
      onFieldSubmitted: (input) {
        if (txtControl.text.isNotEmpty) {
          context.read<SearchBloc>().add(SearchChanged(txtControl.text));
          debugPrint("Submitted ${txtControl.text}");
        }
      },*/
      // onChanged: (input) => context.read<SearchBloc>().add(SearchChanged(input)),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            searchText = value;
            isSearching = false;
          });
          // debugPrint("searchText:: $value");
        }
      },
      onEditingComplete: () {
        // FocusScope.of(context).requestFocus(FocusNode());
        buttonController?.update(MaterialState.pressed, false);
      },
      decoration: inputDecoration(context, /*state*/),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }

  InputDecoration inputDecoration(BuildContext context, /*SearchState state*/) {
    return InputDecoration(
      filled: true,
      isDense: true,
      /*prefixIcon: isSearching
          ? showCircularProgress(height: 12, width: 12, strokeWidth: 2)
          : null,*/
      prefixText: "VIN: ",
      prefixStyle: const TextStyle(fontWeight: FontWeight.w600),
      hintText: " Enter your VIN...",
      alignLabelWithHint: true,
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      // suffixIcon: _SearchButton(),
      suffixIcon: outlinedButton(context),
      suffixIconConstraints: const BoxConstraints.expand(width: 60, height: 40),
      // errorText: state.searchTerm.displayError != null ? 'Enter your VIN' : null,
    );
  }

  OutlinedButton outlinedButton(BuildContext btnContext) {
    return outlinedBtnForSearch(
      btnContext,
      isPressed: isSearching,
      buttonController: buttonController,
      onPress: () async {
        if (searchText.length > 7) {
          setState(() => isSearching = true);
          _onVinSearchFun();
        }
      },
    );
  }

  Future<void> _onVinSearchFun() async {
    final getData = SearchRepositoryImpl().getVehicleByVin(searchText);

    // Show progressBar dialog/modal
    await showProgressDialog(context, request: getData,
        onSuccess: (VehicleModel? vehicle) async {
      if (vehicle != null && vehicle.isNotEmpty) {
        //Save VIN as recent searches.
        await AppLocalService()
            .saveHistory(searchText, key: vinSearchHistoryCacheKey)
            .whenComplete(() {
          Map<String, dynamic> v = {"data": vehicle};
          _navigating(context, v);
        });
      } else {
        await _saveReadOnlyVIN();
      }
    }, onError: (e) async {
      await _saveReadOnlyVIN();
    });
  }

  // Save this VIN for reference in Make-Request-Form
  Future<void> _saveReadOnlyVIN() async {
    await AppLocalService()
        .saveReadOnly(searchText, key: sendRequestVinCacheKey)
        .then((_) {
      _resetState();
      showRequestModal(context, vinRequest);
    });
  }

  void _navigating(
    BuildContext parentContext,
    Map<String, dynamic> vehicle,
  ) {
    pageNavigator(
      parentContext,
      routeName: vehicleDetailsRoute,
      arguments: vehicle,
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

/*Dirty Work Bloc
* OutlinedButton outlinedButton(BuildContext context2) {
    return outlinedBtnForSearch(
      context2,
      isSearching: isSearching,
      onPress: () async {
        setState(() => isSearching = true);
        KeyboardUtil.hide(context);
        context.read<VehicleByVinBloc>().add(GetVehicleByVin(searchText));
      },
    );
  }

  BlocListener<VehicleByVinBloc, VehiclesState> _onVinSearchBloc(
      BuildContext parentContext) {
    return BlocListener<VehicleByVinBloc, VehiclesState>(
      // If listenWhen returns true, listener will be called with new state
      listenWhen: (previousState, state) => state != previousState,

      listener: (_, state) async {
        if (isSearching && state is VehicleByDone) {
          Map<String, dynamic> vehicle = {"vehicle": state.vehicle!};

          _navigating(parentContext, vehicle);
        }
        if (state is VehiclesError) {
          // debugPrint(state.error!.message!);
          _resetState();
          showRequestModal(parentContext, "vinRequest");
        }
      },
      // listenWhen: true,
      child: Builder(builder: (btnContext) => outlinedButton(btnContext)),
    );
  }

 */
