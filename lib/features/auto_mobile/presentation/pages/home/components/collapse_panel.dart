import 'package:automasters/features/auto_mobile/data/models/panel.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/part_no_textfield.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/vin_textfield.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/build_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/manual_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';

import 'package:flutter/material.dart';

Future<dynamic> showHistory(BuildContext context) =>
    buildModal(context, const Text("History"));

class CollapsePanel extends StatelessWidget {
  CollapsePanel({super.key});

  final List<PanelModel> _data = generateItems(3);

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
        return expansionPanelRadio(item, context);
      }).toList(),
    );
  }

  ExpansionPanelRadio expansionPanelRadio(
      PanelModel item, BuildContext context) {
    return ExpansionPanelRadio(
      value: item.id,
      canTapOnHeader: true,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
        dense: true,
        title: Text(
          item.headerValue,
          style: const TextStyle(
              fontWeight: FontWeight.normal /*, color: Colors.black45*/),
        ),
      ),
      body: ListTile(
        dense: true,
        title: item.id < 2 ? formField(item.id) : buildMakeModelButton(context),
      ),
    );
  }

  OutlinedButton buildMakeModelButton(BuildContext context) {
    return buildOutlinedBtn(
      context,
      label: "Make | Model | Year",
      onPress: () => showManualModal(context),
    );
  }

  Widget formField(int index) =>
      index == 0 ? const VinTextField() : const PartNoTextField();
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
