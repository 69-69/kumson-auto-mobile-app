import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/bottom_sheet/make_a_request_modal.dart';

import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_state.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/build_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_card.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/util/get_distinct_by.dart';

import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_state.dart';

import 'package:automasters/features/auto_mobile/data/models/model.dart';
import 'package:automasters/features/auto_mobile/data/models/make.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/make_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/make_state.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_state.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/alphabetical_scroll_view.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';

import 'package:string_capitalize/string_capitalize.dart';

Future<dynamic> showMakeModal(BuildContext context) =>
    buildModal(context, const ModelMakeModal());

class ModelMakeModal extends StatefulWidget {
  const ModelMakeModal({super.key});

  @override
  State<ModelMakeModal> createState() => _ModelMakeModalState();
}

class _ModelMakeModalState extends State<ModelMakeModal> {
  late Future<List<MakeModel>> getVehicleMake;
  String getMakeRef = "", getMakeName = "", getModelName = "";
  bool isMakeSelected = false, isModelSelected = false, isYearSelected = false;

  int isMakeSelectedIndex = 0,
      isModelSelectedIndex = 0,
      isYearSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return _buildBody(context);
  }

  SizedBox _buildBody(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight! * 0.85,
      child: Column(
        children: [
          buildPagerHead(context),
          const Divider(thickness: 1),
          Expanded(
            child: (!isMakeSelected && !isModelSelected && !isYearSelected)
                ? _carMakeBloc()
                : (isMakeSelected && getMakeRef.isNotEmpty)
                    ? _carModelBloc(context)
                    : (isModelSelected &&
                            (getMakeName.isNotEmpty && getModelName.isNotEmpty)
                        ? _carYearsBloc(context)
                        : _engineTypeBloc(context)),
          ),
          showMakeRequestModalButton(context, "Your Request"),
          SizedBox(height: getProportionateScreenHeight(15)),
        ],
      ),
    );
  }

  showMakeRequestModalButton(BuildContext context, String label) {
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          /// Or Section
          orSeparator(lineColor: color, textColor: color),
          showMakeRequestButton(
            context,
            "manualRequest",
            borderColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Padding buildPagerHead(BuildContext context) {
    Icon iconRight =
        const Icon(Icons.chevron_right, color: Colors.black26, size: 13);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildMakeNav(context),

          /// Head Label: "Model"
          iconRight,
          _buildModelNav(context),

          /// Head Label: "Year"
          iconRight,
          _buildYearNav(context),

          /// Head Label: "Engine"
          iconRight,
          _buildEnginTypeNav(context),
        ],
      ),
    );
  }

  GestureDetector _buildMakeNav(BuildContext context) {
    return GestureDetector(
      child: buildPagerTitle(
        "Make",
        context,
        isActive: (!isMakeSelected && !isModelSelected && !isYearSelected)
            ? true
            : false,
      ),
      onTap: () => setState(() {
        isMakeSelected = false;
        isModelSelected = false;
        isYearSelected = false;
      }),
    );
  }

  _buildModelNav(BuildContext context) {
    return GestureDetector(
      child: buildPagerTitle(
        "Model",
        context,
        isActive: (isMakeSelected && getMakeRef.isNotEmpty) ? true : false,
      ),
      onTap: () {
        if (isModelSelected && getMakeRef.isNotEmpty) {
          setState(() {
            isModelSelected = false;
            isMakeSelected = true;
          });
        }
      },
    );
  }

  GestureDetector _buildYearNav(BuildContext context) {
    return GestureDetector(
      child: buildPagerTitle("Year", context,
          isActive: (isModelSelected &&
                  getMakeName.isNotEmpty &&
                  getModelName.isNotEmpty)
              ? true
              : false),
      onTap: () {
        if (isYearSelected &&
            (getMakeName.isNotEmpty && getModelName.isNotEmpty)) {
          setState(() {
            isYearSelected = false;
            isModelSelected = true;
          });
        }
      },
    );
  }

  Widget _buildEnginTypeNav(BuildContext context) {
    return buildPagerTitle("Engine type", context,
        isActive: (isYearSelected &&
                getMakeName.isNotEmpty &&
                getModelName.isNotEmpty)
            ? true
            : false);
  }

  Widget buildPagerTitle(String label, BuildContext context,
          {bool isActive = true}) =>
      customLine(
        label.capitalizeEach(),
        context,
        fontSize: 16,
        allowCopy: false,
        isUnderline: false,
        isActive: isActive,
        color: Theme.of(context).colorScheme.primary,
      );

  /// BlocBuilder
  BlocBuilder _carMakeBloc() {
    return BlocBuilder<MakesBloc, MakesState>(
      builder: (context, state) {
        if (state is MakesLoading) {
          return showCircularProgress();
        }

        if (state is MakesError) {
          return const Center(
            child: Icon(Icons.refresh),
          );
        }

        if (state is MakesDone) {
          return listCarMakeCard(state);
        }
        return const SizedBox();
      },
    );
  }

  BlocBuilder _carModelBloc(BuildContext context) {
    _getCarModels(context);

    return BlocBuilder<ModelsByMakeRefBloc, ModelsState>(
      builder: (context, state) {
        if (state is ModelsLoading) {
          return showCircularProgress();
        }

        if (state is ModelsError) {
          return buildRefreshApp(context);
        }

        if (state is ModelsDone) {
          return listCarModelCard(state);
        }

        return const SizedBox();
      },
    );
  }

  void _getCarModels(BuildContext context) {
    context.read<ModelsByMakeRefBloc>().add(GetModelsBy(getMakeRef));
  }

  BlocBuilder _carYearsBloc(BuildContext context) {
    _getCarYears(context);

    return BlocBuilder<PartsYearsByMakeModelBloc, PartsState>(
      builder: (context, state) {
        if (state is PartsLoading) {
          return showCircularProgress();
        }

        if (state is PartsError) {
          return buildRefreshApp(context);
        }

        if (state is PartsDone) {
          return listCarYearsCard(state);
        }

        return const SizedBox();
      },
    );
  }

  void _getCarYears(BuildContext context) {
    context
        .read<PartsYearsByMakeModelBloc>()
        .add(GetByMakeModel(getMakeName, getModelName));
  }

  BlocBuilder _engineTypeBloc(BuildContext context) {
    context
        .read<PartsByMakeModelBloc>()
        .add(GetByMakeModel(getMakeName, getModelName));

    return BlocBuilder<PartsByMakeModelBloc, PartsState>(
      builder: (context, state) {
        if (state is PartsLoading) {
          return showCircularProgress();
        }

        if (state is PartsError) {
          return buildRefreshApp(context);
        }

        if (state is PartsDone) {
          return listEngineTypeCard(state);
        }

        return _notFound();
      },
    );
  }

  AlphabeticalScrollView buildAlphabeticalScrollView(
      {bool isSelected = false,
      required List<AlphaModel> list,
      required Widget Function(BuildContext, int, String) itemBuilder}) {
    ColorScheme tColor = Theme.of(context).colorScheme;

    Container buildOverlayWidget(String value) => Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
          alignment: Alignment.center,
          child: Text(
            value.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        );

    TextStyle buildSelectedTextStyle(ColorScheme tColor) => TextStyle(
          fontWeight: FontWeight.bold,
          color: tColor.primary,
          overflow: TextOverflow.ellipsis,
        );

    TextStyle buildUnSelectedTextStyle(ColorScheme tColor) => TextStyle(
          fontWeight: FontWeight.normal,
          color: tColor.onSurface,
          overflow: TextOverflow.ellipsis,
        );

    return AlphabeticalScrollView(
      list: list,
      // isAlphabetsFiltered: false,
      itemExtent: 50,
      alignment: LetterAlignment.right,
      unselectedTextStyle: buildUnSelectedTextStyle(tColor),
      selectedTextStyle: buildSelectedTextStyle(tColor),
      overlayWidget: (value) => buildOverlayWidget(value),
      listPadding: const EdgeInsets.fromLTRB(10.0, 2.0, 43.0, 30.0),
      itemBuilder: itemBuilder,
    );
  }

  GestureDetector _buildListCard(String value, bool isClicked,
      {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: customCard(
        color: isClicked
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectionArea(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Icon(Icons.adaptive.arrow_forward, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  /// Grid view display[listCarMakeCard]
  AlphabeticalScrollView listCarMakeCard(MakesDone state) {
    final List<MakeModel> result = state.makes as List<MakeModel>;

    return buildAlphabeticalScrollView(
        list: result.map((MakeModel e) => AlphaModel(e.make)).toList(),
        itemBuilder: (_, index, value) {
          MakeModel make = result[index];

          return _buildListCard(
            value.capitalizeEach(),
            isMakeSelectedIndex == make.id!,
            onTap: () {
              setState(() {
                isMakeSelectedIndex = make.id!;
                isMakeSelected = !isMakeSelected;
                getMakeName = make.make!;
                getMakeRef = make.makeRef!;
              });
            },
          );
        });
  }

  /// Grid view display[listCarModelCard]
  AlphabeticalScrollView listCarModelCard(ModelsDone state) {
    final List<Model> result = state.models as List<Model>;

    return buildAlphabeticalScrollView(
        list: result.map((Model e) => AlphaModel(e.model)).toList(),
        itemBuilder: (_, index, value) {
          Model model = result[index];

          return _buildListCard(
            value.capitalizeEach(),
            isModelSelectedIndex == model.id!,
            onTap: () {
              setState(() {
                isModelSelectedIndex = model.id!;
                isMakeSelected = false;
                isModelSelected = true;
                getModelName = model.model!;
              });
            },
          );
        });
  }

  /// Grid view display[listCarYearsCard]
  AlphabeticalScrollView listCarYearsCard(PartsDone state) {
    final List<dynamic> result = state.parts as List<dynamic>;

    return buildAlphabeticalScrollView(
        list: result.map((e) => AlphaModel(e.toString())).toList(),
        itemBuilder: (_, index, value) {
          return _buildListCard(
            value,
            isYearSelectedIndex == index,
            onTap: () {
              setState(() {
                isYearSelectedIndex = index;
                isMakeSelected = false;
                isModelSelected = false;
                isYearSelected = !isYearSelected;
              });
            },
          );
        });
  }

  removeDuplicate(List<PartModel> result, bool isPart) => result
      .getDistinctBy((PartModel x) => isPart ? x.part! : x.engineType!)
      .toList();

  /// List view display[listEngineTypeCard]
  AlphabeticalScrollView listEngineTypeCard(PartsDone state) {
    List<PartModel> result = state.parts as List<PartModel>;
    List<PartModel> eTypes = removeDuplicate(result, false);

    return buildAlphabeticalScrollView(
        list: eTypes.map((PartModel e) => AlphaModel(e.engineType)).toList(),
        itemBuilder: (_, index, value) {
          PartModel part = eTypes[index];

          return part.engineType != "0"
              ? _getVehicleEnginesBloc(result, value, part)
              : const SizedBox.shrink();
        });
  }

  BlocListener _getVehicleEnginesBloc(
    List<PartModel> result,
    String value,
    PartModel part,
  ) {
    return BlocListener<VehicleByVinBloc, VehiclesState>(
      // If listenWhen returns true, listener will be called with new state
      // listenWhen: (previousState, currentState) => currentState != previousState,
      listener: (_, state) {
        if (state is VehiclesError) {
          Text(state.error!.message!);
        }
        if (state is VehicleByDone) {
          Map<String, dynamic> data = {
            "vehicle": state.vehicle,
            "parts": removeDuplicate(result, true)
          };

          pageNavigator(context,
              routeName: vehicleDetailsRoute, arguments: data);
        }
      },
      child: _buildListCard(
        value,
        false,
        onTap: () {
          _onPressedGetEngines(part);
        },
      ),
    );
  }

  void _onPressedGetEngines(PartModel part) {
    context.read<VehicleByVinBloc>().add(GetVehicleByVin(part.vin!));
  }

  Center _notFound() => Center(
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.error),
          label: const Text("Not Found"),
        ),
      );
}

/*return ColumnBuilder(
      itemCount: distinctEngineList.length,
      itemBuilder: (context, index) {
        PartModel part = distinctEngineList[index];

        return part.engineType != "0"
            ? buildOutlinedButton(
                part.engineType,
                onPress: () {
                  APIService().getVehicleByVin(part.vin).then(
                        (VehicleModel v) => animateTransition(
                          context,
                          VehicleDetails(
                            vehicle: v,
                            parts: removeDuplicate(result, true),
                          ),
                        ),
                      );
                },
              )
            : const SizedBox.shrink();
      },
    );

    return ColumnBuilder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        int carYear = result[index];

        return buildOutlinedButton("$carYear",
            isSelected: isYearSelectedIndex == carYear, onPress: () {
          setState(() {
            isYearSelectedIndex = carYear;
            isMakeSelected = false;
            isModelSelected = false;
            isYearSelected = !isYearSelected;
          });
        });
      },
    );*/
