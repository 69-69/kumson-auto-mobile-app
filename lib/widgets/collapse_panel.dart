import 'package:flutter/material.dart';

import '../models/panel.dart';
import '../models/vehicle.dart';
import '../service/apiService.dart';
import '../utils/animation_transition.dart';
import '../view/vehicle_details.dart';
import 'car_modal.dart';

List<String> label = ["VIN", "Part No.", "Vehicle - (Make | Model)"];

List<PanelModel> generateItems(int numberOfItems) =>
    List<PanelModel>.generate(numberOfItems, (int index) {
      return PanelModel(
        id: index,
        headerValue: label[index],
        expandedValue: const Placeholder(),
      );
    });

Future<dynamic> buildShowModalBottomSheet(BuildContext context) =>
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      barrierColor: Colors.black.withOpacity(.8),
      context: context,
      builder: (_) => const CarModal(term: ""),
    );

class CollapsePanel extends StatefulWidget {
  final String vin;

  const CollapsePanel({super.key, this.vin = ""});

  @override
  State<CollapsePanel> createState() => _CollapsePanelState();
}

class _CollapsePanelState extends State<CollapsePanel> {
  String searchTerm = "";
  final List<PanelModel> _data = generateItems(3);
  TextEditingController txt = TextEditingController();
  VehicleModel? vehicleData;

  @override
  void initState() {
    setState(() {
      if (searchTerm.isNotEmpty) {
        debugPrint("begin: $searchTerm");
        APIService()
            .getVehicleByVin(searchTerm)
            .then((data) => setState(() => vehicleData = data));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPanel(); /*SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: _buildPanel(),
    )*/
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      // key: GlobalKey(),
      // initialOpenPanelValue: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: _data.map<ExpansionPanelRadio>((PanelModel item) {
        return ExpansionPanelRadio(
          canTapOnHeader: true,
          backgroundColor: const Color(0xFFF0EEF6).withOpacity(0.9),
          value: item.id,
          headerBuilder: (BuildContext context, bool isExpanded) => ListTile(
            title: Text(
              item.headerValue,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ListTile(
            dense: true,
            title: item.id < 2 ? textFormField(item.id, context) : textButton(),
          ),
        );
      }).toList(),
    );
  }

  OutlinedButton textButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 1.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () => buildShowModalBottomSheet(context),
      child: const Text("Year | Make | Model"),
    );
  }

  TextFormField textFormField(int index, BuildContext context) {
    if (widget.vin.isNotEmpty) {
      setState(() => searchTerm = widget.vin);
      txt.text = widget.vin;
    }
    return TextFormField(
      key: Key(index.toString()),
      controller: txt,
      onFieldSubmitted: (_) {
        APIService()
            .getVehicleByVin(searchTerm)
            .then((data) => setState(() => vehicleData = data));
      },
      onChanged: (value) {
        if (value.isNotEmpty || widget.vin.isNotEmpty) {
          searchTerm = value;
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
      prefixText: "${label[index]} -> ",
      hintText: "Enter your ${label[index]}...",
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      suffixIcon: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: IconButton(
          alignment: Alignment.center,
          onPressed: () {
            if (searchTerm.isNotEmpty) {
              APIService()
                  .getVehicleByVin(searchTerm)
                  .then((VehicleModel vehicle) {
                if (vehicle.id != 0) {
                  // We then need to change page route
                  // Lets create an animated router and the page
                  // We want to navigate to
                  animateTransition(context, VehicleDetails(vehicle: vehicle));
                } else {
                  buildShowModalBottomSheet(context);
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              });
            }
          },
          icon: const Icon(Icons.search, color: Colors.white, size: 25),
          style: const ButtonStyle(elevation: MaterialStatePropertyAll(5.0)),
        ),
      ),
      suffixIconConstraints: const BoxConstraints.expand(width: 60, height: 40),
    );
  }
}
