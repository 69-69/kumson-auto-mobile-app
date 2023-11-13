import 'package:automasters/features/auto_mobile/data/data_sources/local/search_history_service.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/_outline_btn_for_search.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';
import 'package:automasters/features/auto_mobile/data/repositories/home_repository_impl.dart';
import 'package:automasters/core/util/keyboard.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/bottom_sheet/make_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';

class VinTextField extends StatefulWidget {
  const VinTextField({super.key});

  @override
  State<VinTextField> createState() => _VinTextFieldState();
}

class _VinTextFieldState extends State<VinTextField> {
  bool isSearching = false;
  String searchText = "";
  Map<String, dynamic>? oldState;
  final FocusNode focusNode = FocusNode();
  TextEditingController txtControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return searchTextField(context);
  }

  TextFormField searchTextField(BuildContext context) {
    /*if (widget.vin.isNotEmpty) {
      setState(() => vinSearchTerm = widget.vin);
      txt.text = widget.vin;
    }*/
    return TextFormField(
      key: const ValueKey("vin"),
      controller: txtControl,
      focusNode: focusNode,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            searchText = value;
            isSearching = false;
          });
          // debugPrint("searchText:: $value");
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
      prefixText: "VIN",
      prefixStyle: const TextStyle(fontWeight: FontWeight.w600),
      hintText: " Enter your VIN...",
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

  OutlinedButton outlinedButton(BuildContext btnContext) {
    return outlinedBtnForSearch(
      btnContext,
      isSearching: isSearching,
      onPress: () async {
        if (searchText.isNotEmpty && searchText.length > 7) {
          setState(() => isSearching = true);
          _onVinSearchFun();
        }
      },
    );
  }

  Future<void> _onVinSearchFun() async {
      final getData = HomeRepositoryImpl().getVehicleByVin(searchText);

      // Show progressBar dialog/modal
      await showProgressDialog(context, getData);

      getData.then((VehicleModel? vehicle) async {
        if (vehicle != null) {
          //Save VIN as recent searches.
          await SearchHistoryDB()
              .saveTo(searchText, key: vinSearchHistoryKey)
              .whenComplete(() {
            Map<String, dynamic> v = {"vehicle": vehicle};
            _navigating(context, v);
          });
        } else {
          _resetState();
          showRequestModal(context, "vinRequest");
        }
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
*
  OutlinedButton outlinedButton(BuildContext context2) {
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
