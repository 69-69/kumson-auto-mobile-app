import 'package:automasters/models/hunter.dart';
import 'package:automasters/utils/keyboard.dart';
import 'package:automasters/view/parts_by_part_no.dart';
import 'package:automasters/widgets/make_a_request_modal.dart';
import 'package:automasters/widgets/widgetery.dart';
import 'package:flutter/material.dart';

import '../models/panel.dart';
import '../models/vehicle.dart';
import '../service/api_service.dart';
import '../service/local_storage_service.dart';
import '../utils/animation_transition.dart';
import 'async_progress_dialog.dart';
import '../view/vehicle_details.dart';
import 'model_make_modal.dart';

Future<dynamic> showHistory(BuildContext context) =>
    buildModal(context, const Text("History"));

class CollapsePanel extends StatefulWidget {
  const CollapsePanel({super.key});

  @override
  State<CollapsePanel> createState() => _CollapsePanelState();
}

class _CollapsePanelState extends State<CollapsePanel> {
  bool isSearching = false;
  final FocusNode vinFocusNode = FocusNode();
  final FocusNode partNoFocusNode = FocusNode();
  String vinSearchTerm = "", partNoSearchTerm = "";
  final List<PanelModel> _data = generateItems(3);

  // TextEditingController txt = TextEditingController();
  List<HunterModel>? partData;
  VehicleModel? vehicleData;
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPanel(context);
  }

  Widget _buildPanel(BuildContext context) {
    return ExpansionPanelList.radio(
      // key: GlobalKey(),
      // initialOpenPanelValue: txt.value.text.isNotEmpty ? 0 : null,
      expandedHeaderPadding: EdgeInsets.zero,
      children: _data.map<ExpansionPanelRadio>((PanelModel item) {
        return ExpansionPanelRadio(
          value: item.id,
          canTapOnHeader: true,
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.9),
          headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
            title: Text(
              item.headerValue,
              style: const TextStyle(
                  fontWeight: FontWeight.normal /*, color: Colors.black45*/),
            ),
          ),
          body: ListTile(
            dense: true,
            title: item.id < 2
                ? formField(item.id, context)
                : buildMakeModelButton(context),
          ),
        );
      }).toList(),
    );
  }

  OutlinedButton buildMakeModelButton(BuildContext context) {
    return buildOutlinedBtn(
      context,
      label: "Make | Model | Year",
      onPress: () => showMakeModal(context),
    );
  }

  TextFormField formField(int index, BuildContext context) {
    return index == 0
        ? vinSearchTextFormField(index, context)
        : partNoSearchTextFormField(index, context);
  }

  TextFormField vinSearchTextFormField(int index, BuildContext context) {
    /*if (widget.vin.isNotEmpty) {
      setState(() => vinSearchTerm = widget.vin);
      txt.text = widget.vin;
    }*/
    return TextFormField(
      key: const ValueKey("vin"),
      focusNode: vinFocusNode,
      onChanged: (value) {
        if (value.isNotEmpty) {
          vinSearchTerm = value;
        }
      },
      decoration: inputDecoration(index, context),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }

  TextFormField partNoSearchTextFormField(int index, BuildContext context) {
    return TextFormField(
      key: const ValueKey("part_no"),
      focusNode: partNoFocusNode,
      onChanged: (value) {
        if (value.isNotEmpty) {
          partNoSearchTerm = value;
        }
      },
      decoration: inputDecoration(index, context),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }

  InputDecoration inputDecoration(int index, BuildContext context) {
    return InputDecoration(
      filled: true,
      isDense: true,
      prefixIcon: isSearching
          ? showCircularProgress(height: 12, width: 12, strokeWidth: 2)
          : null,
      prefixText: isSearching ? "" : "${label[index]}:",
      prefixStyle: const TextStyle(fontWeight: FontWeight.w600),
      hintText: " Enter your ${label[index]}...",
      alignLabelWithHint: true,
      /*border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
      ),*/
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      suffixIcon: OutlinedButton(
        onPressed: () {
          setState(() => isSearching = true);
          KeyboardUtil.hide(context);

          index == 0 ? onVinSearchFun() : onPartNoSearch();
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(width: 1.0, color: Colors.transparent),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: const Icon(Icons.search, color: Colors.white, size: 25),
      ),
      suffixIconConstraints: const BoxConstraints.expand(width: 60, height: 40),
    );
  }

  Future<void> onVinSearchFun() async {
    if (vinSearchTerm.isNotEmpty) {
      final getRemoteData = APIService().getVehicleByVin(vinSearchTerm);

      // Show progressBar dialog/modal
      await showProgressDialog(context, getRemoteData);

      getRemoteData.then((VehicleModel vehicle) async {
        if (vehicle.id != 0) {
          //Save the searchText to SharedPref so that next time you can use them as recent searches.
          await LocalStorageService.saveToRecentSearches(
            vinSearchTerm,
            key: "vinSearchHistory",
          );

          setState(() => isSearching = false);

          if (context.mounted) {
            animateTransition(context, VehicleDetails(vehicle: vehicle));
          }
        } else {
          setState(() {
            isSearching = false;
            vinSearchTerm = "";
            vinFocusNode.unfocus();
          });
          showRequestModal(context, "Your Request");
        }
      });
    }
  }

  Future<void> onPartNoSearch() async {
    if (partNoSearchTerm.isNotEmpty) {
      final getRemoteData =
          APIService().getHunterPartsBy(patNo: partNoSearchTerm);

      // Show progressBar dialog/modal
      await showProgressDialog(context, getRemoteData);

      getRemoteData.then((List<HunterModel> partData) async {
        if (partData.isNotEmpty) {
          //Save the searchText to SharedPref so that next time you can use them as recent searches.
          await LocalStorageService.saveToRecentSearches(
            partNoSearchTerm,
            key: "partNoSearchHistory",
          );

          setState(() => isSearching = false);

          if (context.mounted) {
            animateTransition(context, PartsByPartNo(cPart: partData));
          }
        } else {
          setState(() {
            isSearching = false;
            partNoSearchTerm = "";
            partNoFocusNode.unfocus();
          });
          showRequestModal(context, "Your Request");
        }
        // By default, show a loading spinner.
        return showCircularProgress();
      });
    }
  }
}

List<String> label = ["VIN", "Part No.", "Vehicle - (Make | Model)"];

List<PanelModel> generateItems(int numberOfItems) =>
    List<PanelModel>.generate(numberOfItems, (int index) {
      return PanelModel(
        id: index,
        headerValue: label[index],
        expandedValue: const SizedBox.shrink(),
      );
    });
