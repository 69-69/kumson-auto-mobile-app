import 'package:automasters/models/hunter.dart';
import 'package:automasters/utils/keyboard.dart';
import 'package:automasters/view/parts_by_part_no.dart';
import 'package:automasters/widgets/make_a_request_modal.dart';
import 'package:flutter/material.dart';

import '../models/panel.dart';
import '../models/vehicle.dart';
import '../service/apiService.dart';
import '../utils/animation_transition.dart';
import 'async_progress_dialog.dart';
import 'widgetery.dart';
import '../view/vehicle_details.dart';
import 'model_make_modal.dart';

class CollapsePanel extends StatefulWidget {
  final String vin;

  const CollapsePanel({super.key, this.vin = ""});

  @override
  State<CollapsePanel> createState() => _CollapsePanelState();
}

class _CollapsePanelState extends State<CollapsePanel> {
  bool isSearching = false;
  final FocusNode partNoFocusNode = FocusNode();
  final FocusNode vinFocusNode = FocusNode();
  String vinSearchTerm = "", partNoSearchTerm = "";
  final List<PanelModel> _data = generateItems(3);
  TextEditingController txt = TextEditingController();
  List<HunterModel>? partData;
  VehicleModel? vehicleData;

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
      initialOpenPanelValue: txt.value.text.isNotEmpty ? 0 : null,
      expandedHeaderPadding: EdgeInsets.zero,
      children: _data.map<ExpansionPanelRadio>((PanelModel item) {
        return ExpansionPanelRadio(
          canTapOnHeader: true,
          backgroundColor: const Color(0xFFF0EEF6).withOpacity(0.9),
          value: item.id,
          headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
            title: Text(
              item.headerValue,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black45),
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
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 1.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () => showMakeModal(context),
      child: const Text("Make | Model | Year"),
    );
  }

  TextFormField formField(int index, BuildContext context) {
    return index == 0
        ? vinSearchTextFormField(index, context)
        : partNoSearchTextFormField(index, context);
  }

  TextFormField vinSearchTextFormField(int index, BuildContext context) {
    if (widget.vin.isNotEmpty) {
      setState(() => vinSearchTerm = widget.vin);
      txt.text = widget.vin;
    }
    return TextFormField(
      key: const ValueKey("vin"),
      focusNode: vinFocusNode,
      controller: txt,
      onFieldSubmitted: (_) {},
      onChanged: (value) {
        if (value.isNotEmpty || widget.vin.isNotEmpty) {
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
      onFieldSubmitted: (_) {},
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
      prefixStyle:
          const TextStyle(fontWeight: FontWeight.w600, color: Colors.black26),
      hintText: "Enter your ${label[index]}...",
      alignLabelWithHint: true,
      /*border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
      ),*/
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      suffixIcon: OutlinedButton(
        onPressed: () =>
            index == 0 ? onVinSearchFun(context) : onPartNoSearch(context),
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

  Future<void> onVinSearchFun(BuildContext context) async {
    if (vinSearchTerm.isNotEmpty) {
      setState(() => isSearching = true);
      KeyboardUtil.hide(context);

      final getRemoteData = APIService().getVehicleByVin(vinSearchTerm);

      // Show progressBar dialog/modal
      await showProgressDialog(context, getRemoteData);

      getRemoteData.then((VehicleModel vehicle) {
        if (vehicle.id != 0) {
          animateTransition(context, VehicleDetails(vehicle: vehicle));
          setState(() => isSearching = false);
        } else {
          setState(() {
            isSearching = false;
            vinSearchTerm = "";
            vinFocusNode.unfocus();
          });
          showRequestModal(context, "Your Request");
        }
        // By default, show a loading spinner.
        return showCircularProgress();
      });
    }
  }

  Future<void> onPartNoSearch(BuildContext context) async {
    if (partNoSearchTerm.isNotEmpty) {
      setState(() => isSearching = true);
      KeyboardUtil.hide(context);

      final getRemoteData = APIService().getHunterPartsBy(patNo: partNoSearchTerm);

      // Show progressBar dialog/modal
      await showProgressDialog(context, getRemoteData);

      getRemoteData.then((List<HunterModel> partData) {
        if (partData.isNotEmpty) {
          animateTransition(context, PartsByPartNo(cPart: partData));
          setState(() => isSearching = false);
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
        expandedValue: const Placeholder(),
      );
    });
