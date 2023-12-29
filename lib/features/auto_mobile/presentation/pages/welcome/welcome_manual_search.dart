import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/items_dropdown.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/vehicle/remote/index.dart';

class WelcomeManualSearch extends StatefulWidget {
  const WelcomeManualSearch({super.key});

  @override
  State<WelcomeManualSearch> createState() => WelcomeManualSearchState();
}

class WelcomeManualSearchState extends State<WelcomeManualSearch> {
  String _makeRef = "";
  String _modelName = "";
  String _makeName = "";
  List<PartModel>? _getEngineTypes;
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController engineController = TextEditingController();
  ProductsDropdown productsDropdown = ProductsDropdown();

  @override
  Widget build(BuildContext context) {
    final tColor = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Or Section
          orSeparator(
            lineColor: tColor.secondaryContainer,
            bgColor: Colors.white,
            textColor: tColor.primary,
          ),
          _gaps(),
          _buildMakeDropdown(),
          _gaps(),
          _buildModelDropdown(),
          _gaps(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth! * 0.45,
                child: _buildYearDropdown(),
              ),
              SizedBox(width: getProportionateScreenHeight(10)),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.45,
                child: _buildEngineDropdown(),
              ),
            ],
          ),
          _gaps(),
          _getRouteDataBloc(),
        ],
      ),
    );
  }

  SizedBox _gaps() => SizedBox(height: getProportionateScreenHeight(7));

  _buildMakeDropdown() {
    //debugPrint(suggestionsCallback("").toString());
    return productsDropdown.buildMakesDropdown(
      controller: makeController,
      onChanged: (v) {
        // Check if 'v' is a String or Make Object
        var ref = (v.runtimeType == String) ? v : v.makeRef;
        setState(() {
          _makeRef = ref;
          _makeName = v.make;
        });

        // debugPrint("make-1 $ref");
      },
    );
  }

  _buildModelDropdown() {
    return productsDropdown.buildModelsDropdown(
      _makeRef,
      controller: modelController,
      onChanged: (v) {
        // Check if 'v' is a String or Model Object
        var ref = (v.runtimeType == String) ? v : v.model;
        setState(() => _modelName = ref.toString());
        // debugPrint("model-1 $v $_makeName");
      },
    );
  }

  _buildYearDropdown() {
    //debugPrint(suggestionsCallback("").toString());
    return productsDropdown.buildYearsDropdown(
      _makeName,
      _modelName,
      controller: makeController,
      onChanged: (v) {
        // Check if 'v' is a String or Make Object
        // var ref = (v.runtimeType == String) ? v : v.makeRef;
        // setState(() => _makeRef = ref);

        debugPrint("year-1 $v");
      },
    );
  }

  _buildEngineDropdown() {
    //debugPrint(suggestionsCallback("").toString());
    return productsDropdown.buildEnginesDropdown(
      _makeName,
      _modelName,
      controller: makeController,
      onChanged: (v) {
        List<PartModel> matches = PartModel.fromJsonList(v);
        // Check if 'v' is a String or Make Object
        // var ref = (v.runtimeType == String) ? v : v.makeRef;
        setState(() => _getEngineTypes = matches);
        debugPrint("engine-1 $matches");
      },
    );
  }

  BlocConsumer _getRouteDataBloc() {
    if (_getEngineTypes != null) {
      BlocProvider.of<VehicleByVinBloc>(context)
          .add(GetVehicleByVinEvent(_getEngineTypes![0].vin!));
    }

    return BlocConsumer<VehicleByVinBloc, VehicleState>(
      listenWhen: (preState, curState) => preState != curState,
      buildWhen: (preState, curState) => preState != curState,
      listener: (_, state) {
        if (state is VehicleLoading) {}
      },
      builder: (_, state) {
        return SizedBox(
          width: SizeConfig.screenWidth,
          child: elevatedBtn(state, _),
        );
      },
    );
  }

  elevatedBtn(VehicleState<dynamic> state, BuildContext context) {
    return buildElevatedBtn(
      context,
      elevation: 15.0,
      label: "SHOW CAR PARTS",
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      onPress: state.vehicle != null
          ? () {
              final v = state.vehicle as VehicleModel;
              Map<String, dynamic> data = {"data": v, "parts": _getEngineTypes};

              pageNavigator(context,
                  routeName: vehicleDetailsRoute, arguments: data);
            }
          : () => showRequestModal(context, manualRequest),
    );
  }
}
