import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/items_dropdown.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
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
  String _year = "";
  List? _getEngineTypes;
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController engineController = TextEditingController();
  ProductsDropdown productsDropdown = ProductsDropdown();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final tColor = Theme.of(context).colorScheme;

    return Column(
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
        FittedBox(
          child: Row(
            children: [
              SizedBox(
                width: SizeConfig.screenWidth! * 0.50,
                child: _buildYearDropdown(),
              ),
              const SizedBox(width: 7),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.50,
                child: _buildEngineDropdown(),
              )
            ],
          ),
        ),
        _gaps(),
        _SearchButton(engineTypes: _getEngineTypes),
        const SizedBox(height: 20),
      ],
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
      enabledTextField: _makeRef.isNotEmpty,
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
      enabledTextField: _modelName.isNotEmpty,
      onChanged: (v) {
        // Check if 'v' is a String or Make Object
        // var ref = (v.runtimeType == String) ? v : v.makeRef;
        setState(() => _year = v.toString());

        // debugPrint("year-1 $v");
      },
    );
  }

  _buildEngineDropdown() {
    return productsDropdown.buildEnginesDropdown(
      // Enable [EngineDropdown] if [YearDropdown] is Not Empty,
      _makeName,
      _modelName,
      controller: makeController,
      enabledTextField: _year.isNotEmpty,
      onChanged: (v) => setState(() => _getEngineTypes = v),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.engineTypes});

  final List? engineTypes;

  @override
  Widget build(BuildContext context) {
    return _getRouteDataBloc(context);
  }

  BlocConsumer _getRouteDataBloc(BuildContext context) {
    if (engineTypes != null && engineTypes!.isNotEmpty) {
      List<PartModel> parts = PartModel.fromJsonList(engineTypes!);
      BlocProvider.of<VehicleByVinBloc>(context)
          .add(GetVehicleByVinEvent(parts[0].vin!));
    }

    return BlocConsumer<VehicleByVinBloc, VehicleState>(
      listenWhen: (preState, curState) => preState != curState,
      buildWhen: (preState, curState) => preState != curState,
      listener: (_, state) {
        if (state is VehicleLoading) {}
      },
      builder: (builderContext, state) {
        return SizedBox(
          width: SizeConfig.screenWidth,
          child: elevatedBtn(builderContext, state),
        );
      },
    );
  }

  elevatedBtn(
    BuildContext context,
    VehicleState<dynamic> state,
  ) {
    return buildElevatedBtn(
      context,
      elevation: 15.0,
      label: "SHOW CAR PARTS",
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      onPress: engineTypes != null && engineTypes!.isNotEmpty
          ? () async {
              VehicleModel vehicle = state.vehicle;
              List<PartModel> parts = PartModel.fromJsonList(engineTypes!);
              Map<String, dynamic> map = {"vehicle": vehicle, "parts": parts};

              // Show progressBar dialog/modal
              await showProgressDialog(
                context,
                request: Future.delayed(const Duration(seconds: 1)),
                child: const Text('Searching Car Parts...'),
              ).whenComplete(
                () async =>
                    await _whenComplete(state.vehicle.vin!, context, map),
              );
            }
          : null, // () => showRequestModal(context, manualRequest),
    );
  }

  Future<void> _whenComplete(
    String vin,
    BuildContext context,
    Map<String, dynamic> map,
  ) async {
    await AppLocalService()
        .saveReadOnly(vin, key: sendRequestVinCacheKey)
        .whenComplete(
          () => pageNavigator(context,
              routeName: vehicleDetailsRoute, arguments: map),
        );
  }
}
