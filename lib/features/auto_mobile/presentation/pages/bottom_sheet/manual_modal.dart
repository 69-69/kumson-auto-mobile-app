import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/util/get_distinct_by.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/make_a_request_modal.dart';

import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/build_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_card.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';

import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/index.dart';

import 'package:automasters/features/auto_mobile/data/models/model.dart';
import 'package:automasters/features/auto_mobile/data/models/make.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/alphabetical_scroll_view.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';

import 'package:string_capitalize/string_capitalize.dart';

Future<dynamic> showManualModal(BuildContext context) =>
    buildModal(context, const ManualModal());

class ManualModal extends StatefulWidget {
  const ManualModal({super.key});

  @override
  State<ManualModal> createState() => _ManualModalState();
}

class _ManualModalState extends State<ManualModal> {
  late Future<List<MakeModel>> getVehicleMake;
  String getMakeRef = "",
      getMakeName = "",
      getModelName = "",
      getCarYear = "";
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

  Icon iconRight =
      const Icon(Icons.chevron_right, color: Colors.black26, size: 13);

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

  SizedBox _buildBody(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight! * 0.85,
      child: Column(
        children: [
          buildPagerHead(context),
          const Divider(thickness: 1, height: 0.0),
          _chipCard(),
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

  Container _chipCard() {
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          "$getMakeName -> $getModelName -> $getCarYear".capitalizeEach(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  buildPagerHead(BuildContext context) {
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
        getMakeName,
        context,
        isActive: (!isMakeSelected && !isModelSelected && !isYearSelected)
            ? true
            : false,
      ),
      onTap: () => setState(() {
        isMakeSelected = false;
        isModelSelected = false;
        isYearSelected = false;
        getMakeName = "";
      }),
    );
  }

  GestureDetector _buildModelNav(BuildContext context) {
    return GestureDetector(
      child: buildPagerTitle(
        "Model",
        getModelName,
        context,
        isActive: (isMakeSelected && getMakeRef.isNotEmpty) ? true : false,
      ),
      onTap: () {
        if (isModelSelected && getMakeRef.isNotEmpty) {
          setState(() {
            isModelSelected = false;
            isMakeSelected = true;
            getModelName = "";
          });
        }
      },
    );
  }

  GestureDetector _buildYearNav(BuildContext context) {
    return GestureDetector(
      child: buildPagerTitle("Year", getCarYear, context,
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
            getCarYear ="";
          });
        }
      },
    );
  }

  Widget _buildEnginTypeNav(BuildContext context) {
    return buildPagerTitle("Engine type", "", context,
        isActive: (isYearSelected &&
                getMakeName.isNotEmpty &&
                getModelName.isNotEmpty)
            ? true
            : false);
  }

  Widget buildPagerTitle(
    String title,
    String subTitle,
    BuildContext context, {
    bool isActive = true,
  }) {

    return customLine(
      title.capitalizeEach(),
      context,
      fontSize: 16,
      allowCopy: false,
      isUnderline: false,
      isActive: isActive,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// BlocBuilder
  BlocBuilder<MakesBloc, MakesState> _carMakeBloc() {
    return BlocBuilder<MakesBloc, MakesState>(
      builder: (context, state) {
        if (state is MakesLoading) {
          return _loadSpinner();
        }

        if (state is MakesError) {
          return buildRefreshApp(context);
        }

        if (state is MakesDone) {
          return listCarMakeCard(state);
        }
        return const SizedBox();
      },
    );
  }

  /// Grid view display[listCarMakeCard]
  AlphabeticalScrollView listCarMakeCard(MakesDone state) {
    final List<MakeModel> result = state.make as List<MakeModel>;

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

  void _getCarModels() {
    // debugPrint("now $getMakeRef");
    context.read<ModelsByMakeRefBloc>().add(GetModelsByEvent(getMakeRef));
  }

  BlocBuilder<ModelsByMakeRefBloc, ModelsState> _carModelBloc(
      BuildContext context2) {
    _getCarModels();

    return BlocBuilder<ModelsByMakeRefBloc, ModelsState>(
      builder: (context, state) {
        if (state is ModelsLoading) {
          // return Text("content");
          return _loadSpinner();
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

  /// Grid view display[listCarModelCard]
  AlphabeticalScrollView listCarModelCard(ModelsDone state) {
    final List<Model> result = state.model as List<Model>;

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

  BlocBuilder<PartsYearsByMakeModelBloc, PartsState> _carYearsBloc(
      BuildContext context) {
    _getCarYears(context);

    return BlocBuilder<PartsYearsByMakeModelBloc, PartsState>(
      builder: (context, state) {
        if (state is PartsLoading) {
          return _loadSpinner();
        }

        /*if (state is PartsError) {
          return buildRefreshApp(context);
        }*/

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
        .add(GetByMakeModelEvent(getMakeName, getModelName));
  }

  /// Grid view display[listCarYearsCard]
  AlphabeticalScrollView listCarYearsCard(PartsDone state) {
    final List<dynamic> result = state.part as List<dynamic>;

    return buildAlphabeticalScrollView(
        list: result.map((e) => AlphaModel(e.toString())).toList(),
        itemBuilder: (_, index, value) {
          return _buildListCard(
            value,
            isYearSelectedIndex == index,
            onTap: () {
              setState(() {
                getCarYear = value;
                isYearSelectedIndex = index;
                isMakeSelected = false;
                isModelSelected = false;
                isYearSelected = !isYearSelected;
              });
            },
          );
        });
  }

  BlocBuilder<PartsByMakeModelBloc, PartsState> _engineTypeBloc(
      BuildContext context) {
    context
        .read<PartsByMakeModelBloc>()
        .add(GetByMakeModelEvent(getMakeName, getModelName));

    return BlocBuilder<PartsByMakeModelBloc, PartsState>(
      builder: (context, state) {
        if (state is PartsLoading) {
          return _loadSpinner();
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

  _removeDuplicate(List<PartModel> result, bool isPart) => result
      .getDistinctBy((PartModel x) => isPart ? x.part! : x.engineType!)
      .toList();

  /// List view display[listEngineTypeCard]
  AlphabeticalScrollView listEngineTypeCard(PartsDone state) {
    List<PartModel> result = state.part as List<PartModel>;
    List<PartModel> eTypes = _removeDuplicate(result, false);

    return buildAlphabeticalScrollView(
        list: eTypes.map((PartModel e) => AlphaModel(e.engineType)).toList(),
        itemBuilder: (_, index, value) {
          PartModel part = eTypes[index];
          // _onPressedGetRouteData(part);

          return part.engineType != "0"
              ? _getRouteDataBloc(result, value, part)
              : const SizedBox.shrink();
        });
  }

  BlocConsumer _getRouteDataBloc(
    List<PartModel> result,
    String value,
    PartModel part,
  ) {
    _onPressedGetRouteData(part);

    return BlocConsumer<VehicleByVinBloc, VehiclesState>(
      // If listenWhen returns true, listener will be called with new state
      // listenWhen: (previousState, currentState) => currentState != previousState,
      // buildWhen: (context, state) => state is VehicleByDone || state is VehiclesLoading,
      listener: (_, state) {
        if(state is VehiclesLoading){
         _loadSpinner();
        }
      },
      builder: (_, state) =>_buildListCard(
        value,
        false,
        onTap: () {
          VehicleModel dat = state.vehicle as VehicleModel;
          Map<String, dynamic> data = {
            "vehicle": dat,
            "parts": _removeDuplicate(result, true)
          };

          pageNavigator(_,
            routeName: vehicleDetailsRoute, arguments: data);
        },
      ),
    );
  }

  void _onPressedGetRouteData(PartModel part) {
    BlocProvider.of<VehicleByVinBloc>(context)
        // .watch<VehicleByVinBloc>()
        .add(GetVehicleByVinEvent(part.vin!));
    // context.read<VehicleByVinBloc>().add(GetVehicleByVinEvent(part.vin!));
  }

  Center _notFound() => Center(
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.error),
          label: const Text("Not Found"),
        ),
      );

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 20, height: 20),
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
    final themeColor=Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: customCard(
        color: isClicked
            ? themeColor.primaryContainer
            : themeColor.background,
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
