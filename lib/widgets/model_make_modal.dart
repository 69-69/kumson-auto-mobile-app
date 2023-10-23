import 'package:automasters/models/model.dart';
import 'package:automasters/utils/get_distinct_by.dart';
import 'package:flutter/material.dart';
import 'package:automasters/models/make.dart';
import 'package:string_capitalize/string_capitalize.dart';
import '../models/parts.dart';
import '../models/vehicle.dart';
import '../service/api_service.dart';
import '../utils/animation_transition.dart';
import '../view/vehicle_details.dart';
import 'alphabetical_scroll_view.dart';
import 'async_progress_dialog.dart';
import 'widgetery.dart';
import '../utils/size_config.dart';

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
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    getVehicleMake = APIService().getMake();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.screenHeight! * 0.85,
      padding: const EdgeInsets.only(top: 7.0, bottom: 20.0),
      child: Column(
        children: [
          buildPagerHead(context),
          const Divider(thickness: 1),
          Expanded(
            child: /*SingleChildScrollView(*/
                (!isMakeSelected && !isModelSelected && !isYearSelected)
                    ? futureBuilderCarMake()
                    : (isMakeSelected && getMakeRef.isNotEmpty)
                        ? futureBuilderCarModel()
                        : (isModelSelected &&
                                (getMakeName.isNotEmpty &&
                                    getModelName.isNotEmpty)
                            ? futureBuilderCarYears()
                            : futureBuilderEngineType()),
          ),
        ],
      ),
    );
  }

  Padding buildPagerHead(BuildContext context) {
    Icon iconRight =
        const Icon(Icons.chevron_right, color: Colors.black26, size: 13);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const Text("CAR:: ", style: TextStyle(color: Color(0xFFC7C0C0)),),
          /// Head Label: "Make"
          GestureDetector(
            child: buildPagerTitle("Make", context,
                isActive:
                    (!isMakeSelected && !isModelSelected && !isYearSelected)
                        ? true
                        : false),
            onTap: () => setState(() {
              isMakeSelected = false;
              isModelSelected = false;
              isYearSelected = false;
            }),
          ),

          /// Head Label: "Model"
          iconRight,
          GestureDetector(
            child: buildPagerTitle("Model", context,
                isActive:
                    (isMakeSelected && getMakeRef.isNotEmpty) ? true : false),
            onTap: () {
              if (isModelSelected && getMakeRef.isNotEmpty) {
                setState(() {
                  isModelSelected = false;
                  isMakeSelected = true;
                });
              }
            },
          ),

          /// Head Label: "Year"
          iconRight,
          GestureDetector(
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
          ),

          /// Head Label: "Engine"
          iconRight,
          buildPagerTitle("Engine type", context,
              isActive: (isYearSelected &&
                      getMakeName.isNotEmpty &&
                      getModelName.isNotEmpty)
                  ? true
                  : false),
        ],
      ),
    );
  }

  Widget buildPagerTitle(String label, BuildContext context,
          {bool isActive = true}) =>
      customLine(
        label.capitalizeEach(),
        context,
        fontSize: 16,
        isUnderline: false,
        isActive: isActive,
        color: Theme.of(context).colorScheme.primary,
      );

  /// FutureBuilder
  FutureBuilder<List<MakeModel>> futureBuilderCarMake() {
    return FutureBuilder<List<MakeModel>>(
      future: getVehicleMake,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return showCircularProgress();
          default:
            if (snapshot.hasData) {
              List<MakeModel> result = snapshot.data!;
              return snapshot.data!.isNotEmpty
                  ? listCarMakeCard(result)
                  // FilterCarMake(carMakes: result, focusNode: focusNode)
                  : buildRefreshApp(context);
            } else {
              return const Text('Refresh App');
            }
        }
      },
    );
  }

  FutureBuilder<List<Model>> futureBuilderCarModel() {
    return FutureBuilder<List<Model>>(
      future: APIService().getModel(getMakeRef),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return showCircularProgress();
          default:
            if (snapshot.hasData) {
              List<Model> result = snapshot.data!;
              return snapshot.data!.isNotEmpty
                  ? listCarModelCard(result)
                  : buildRefreshApp(context);
            } else {
              return const Text('Refresh App');
            }
        }
      },
    );
  }

  FutureBuilder<List<dynamic>> futureBuilderCarYears() {
    return FutureBuilder<List<dynamic>>(
      future: APIService().getCarYears(getMakeName, getModelName),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return showCircularProgress();
          default:
            if (snapshot.hasData) {
              List<dynamic> result = snapshot.data!;
              return snapshot.data!.isNotEmpty
                  ? listCarYearsCard(result)
                  : buildRefreshApp(context);
            } else {
              return const Text('Refresh App');
            }
        }
      },
    );
  }

  FutureBuilder<List<PartModel>> futureBuilderEngineType() {
    return FutureBuilder<List<PartModel>>(
      future: APIService().getPartsByVMakeModel(getMakeName, getModelName),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return showCircularProgress();
          default:
            if (snapshot.hasData) {
              List<PartModel> result = snapshot.data!;
              return snapshot.data!.isNotEmpty
                  ? listEngineTypeCard(result)
                  : buildRefreshApp(context);
            } else {
              return const Text('Refresh App');
            }
        }
      },
    );
  }

  /// Refresh Button
  Center buildRefreshApp(BuildContext context) => Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              width: 1.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: () {},
          child: const Text("Refresh App"),
        ),
      );

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
        );

    TextStyle buildUnSelectedTextStyle(ColorScheme tColor) => TextStyle(
          fontWeight: FontWeight.normal,
          color: tColor.shadow,
        );

    return AlphabeticalScrollView(
      list: list,
      // isAlphabetsFiltered: false,
      itemExtent: 50,
      alignment: LetterAlignment.right,
      unselectedTextStyle: buildUnSelectedTextStyle(tColor),
      selectedTextStyle: buildSelectedTextStyle(tColor),
      overlayWidget: (value) => buildOverlayWidget(value),
      listPadding: const EdgeInsets.only(left: 10, right: 40),
      itemBuilder: itemBuilder,
    );
  }

  /// Grid view display[listCarMakeCard]
  AlphabeticalScrollView listCarMakeCard(List<MakeModel> result) {
    return buildAlphabeticalScrollView(
        list: result.map((MakeModel e) => AlphaModel(e.make)).toList(),
        itemBuilder: (_, index, value) {
          MakeModel carMake = result[index];

          return ListTile(
            title: Text(
              value.capitalizeEach(),
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            trailing: const Icon(Icons.arrow_forward, size: 12),
            tileColor: isMakeSelectedIndex == carMake.id
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            onTap: () {
              setState(() {
                isMakeSelectedIndex = carMake.id;
                isMakeSelected = !isMakeSelected;
                getMakeName = carMake.make;
                getMakeRef = carMake.makeRef;
              });
            },
          );
        });

    /*return ColumnBuilder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        MakeModel carMake = result[index];

        return buildOutlinedButton(carMake.make.capitalizeEach(),
            isSelected: isMakeSelectedIndex == carMake.id, onPress: () {
          setState(() {
            isMakeSelectedIndex = carMake.id;
            isMakeSelected = !isMakeSelected;
            getMakeName = carMake.make;
            getMakeRef = carMake.makeRef;
          });
        });
      },
    );*/
  }

  /// Grid view display[listCarModelCard]
  AlphabeticalScrollView listCarModelCard(List<Model> result) {
    return buildAlphabeticalScrollView(
        list: result.map((Model e) => AlphaModel(e.model)).toList(),
        itemBuilder: (_, index, value) {
          Model carModel = result[index];

          return ListTile(
            title: Text(
              value.capitalizeEach(),
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            trailing: const Icon(Icons.arrow_forward, size: 12),
            tileColor: isModelSelectedIndex == carModel.id
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            onTap: () {
              setState(() {
                isModelSelectedIndex = carModel.id;
                isMakeSelected = false;
                isModelSelected = true;
                getModelName = carModel.model;
              });
            },
          );
        });

    /*return ColumnBuilder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        Model carModel = result[index];

        return buildOutlinedButton(carModel.model.capitalize(),
            isSelected: isModelSelectedIndex == carModel.id, onPress: () {
          setState(() {
            isModelSelectedIndex = carModel.id;
            isMakeSelected = false;
            isModelSelected = true;
            getModelName = carModel.model;
          });
        });
      },
    );*/
  }

  /// Grid view display[listCarYearsCard]
  AlphabeticalScrollView listCarYearsCard(List<dynamic> result) {
    return buildAlphabeticalScrollView(
        list: result.map((e) => AlphaModel(e.toString())).toList(),
        itemBuilder: (_, index, value) {
          return ListTile(
            title: Text(
              value,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            trailing: const Icon(Icons.arrow_forward, size: 12),
            tileColor: isYearSelectedIndex == index
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
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

    /*return ColumnBuilder(
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
  }

  removeDuplicate(List<PartModel> result, bool isPart) => result
      .getDistinctBy((PartModel x) => isPart ? x.part : x.engineType)
      .toList();

  /// List view display[listEngineTypeCard]
  AlphabeticalScrollView listEngineTypeCard(List<PartModel> result) {
    List<PartModel> distinctEngineTypes = removeDuplicate(result, false);
    return buildAlphabeticalScrollView(
        list: distinctEngineTypes
            .map((PartModel e) => AlphaModel(e.engineType))
            .toList(),
        itemBuilder: (_, index, value) {
          PartModel part = distinctEngineTypes[index];

          return part.engineType != "0"
              ? ListTile(
                  title: Text(
                    value.capitalizeEach(),
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  trailing: const Icon(Icons.arrow_forward, size: 12),
                  onTap: () {
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
        });

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
    );*/
  }

/*
  buildOutlinedButton(String label,
      {required Function() onPress, bool isSelected = false}) {
    Color cl = Theme.of(context).colorScheme.primaryContainer;

    return SizedBox(
      width: SizeConfig.screenWidth! * 0.85,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: 2.0,
          backgroundColor:
              isSelected ? cl : Theme.of(context).colorScheme.background,
          side: BorderSide(width: 1.0, color: cl),
        ),
        onPressed: onPress,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  EdgeInsets buildEdgeInsets() =>
      const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 30.0);

  SliverGridDelegateWithFixedCrossAxisCount
      buildSliverGridDelegateWithFixedCrossAxisCount() =>
    const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 6,
      crossAxisCount: 2,
  );*/
}
