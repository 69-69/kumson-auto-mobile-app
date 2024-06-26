import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/util/get_distinct_by.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';

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
  String getMakeRef = "", getMakeName = "", getModelName = "", getCarYear = "";
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

  SizedBox _buildBody(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height * 2;
    final height = SizeConfig.screenHeight! - appBarHeight;

    return SizedBox(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          sendARequest(),
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
            getCarYear = "";
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
  BlocBuilder<MakesBloc, MakeState> _carMakeBloc() {
    return BlocBuilder<MakesBloc, MakeState>(
      builder: (context, state) {
        if (state is MakeLoading) {
          return _loadSpinner();
        }

        if (state is MakeError) {
          return buildRefreshApp(context);
        }

        if (state is MakeDone) {
          return listCarMakeCard(state);
        }
        return const SizedBox();
      },
    );
  }

  /// Grid view display[listCarMakeCard]
  AlphabeticalScrollView listCarMakeCard(MakeDone state) {
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

  BlocBuilder<ModelsByMakeRefBloc, ModelState> _carModelBloc(
      BuildContext context2) {
    _getCarModels();

    return BlocBuilder<ModelsByMakeRefBloc, ModelState>(
      builder: (context, state) {
        if (state is ModelLoading) {
          // return Text("content");
          return _loadSpinner();
        }

        if (state is ModelError) {
          return buildRefreshApp(context);
        }

        if (state is ModelDone) {
          return listCarModelCard(state);
        }

        return const SizedBox();
      },
    );
  }

  /// Grid view display[listCarModelCard]
  AlphabeticalScrollView listCarModelCard(ModelDone state) {
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

  BlocBuilder<PartsYearsByMakeModelBloc, PartState> _carYearsBloc(
      BuildContext context) {
    _getCarYears(context);

    return BlocBuilder<PartsYearsByMakeModelBloc, PartState>(
      builder: (context, state) {
        if (state is PartLoading) {
          return _loadSpinner();
        }

        /*if (state is PartsError) {
          return buildRefreshApp(context);
        }*/

        if (state is PartDone) {
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
  AlphabeticalScrollView listCarYearsCard(PartDone state) {
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

  BlocBuilder<PartsByMakeModelBloc, PartState> _engineTypeBloc(
      BuildContext context) {
    context
        .read<PartsByMakeModelBloc>()
        .add(GetByMakeModelEvent(getMakeName, getModelName));

    return BlocBuilder<PartsByMakeModelBloc, PartState>(
      builder: (context, state) {
        if (state is PartLoading) {
          return _loadSpinner();
        }

        if (state is PartError) {
          return buildRefreshApp(context);
        }

        if (state is PartDone) {
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
  AlphabeticalScrollView listEngineTypeCard(PartDone state) {
    List<PartModel> result = state.part as List<PartModel>;
    List<PartModel> eTypes = _removeDuplicate(result, false);

    return buildAlphabeticalScrollView(
        list: eTypes.map((PartModel e) => AlphaModel(e.engineType)).toList(),
        itemBuilder: (_, index, value) {
          PartModel part = eTypes[index];

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

    return BlocConsumer<VehicleByVinBloc, VehicleState>(
      // If listenWhen returns true, listener will be called with new state
      // listenWhen: (curState, curState) => curState != curState,
      // buildWhen: (preState, curState) => curState != curState,
      listener: (_, state) {
        if (state is VehicleLoading) {
          _loadSpinner();
        }
      },
      builder: (_, state) {
        return _buildListCard(
          value,
          false,
          onTap: () {
            if (state.vehicle != null) {
              final v = state.vehicle as VehicleModel;
              Map<String, dynamic> data = {
                "data": v,
                "parts": _removeDuplicate(result, true)
              };

              pageNavigator(_, routeName: vehicleDetailsRoute, arguments: data);
            } else {
              showRequestModal(context, manualRequest);
            }
          },
        );
      },
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
    final themeColor = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: customCard(
        color: isClicked ? themeColor.primaryContainer : themeColor.background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectionArea(
                child: Text(
                  value.capitalizeEach(),
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

  sendARequest() {
    String msg = isMakeSelected
        ? "Model"
        : isModelSelected
            ? "Year"
            : isYearSelected
                ? "Engine"
                : "Make";

    return InlineRequestButton(
      reqType: manualRequest,
      notFoundMsg: "Car $msg not found!",
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
