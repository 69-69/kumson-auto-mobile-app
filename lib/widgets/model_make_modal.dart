import 'package:automasters/models/model.dart';
import 'package:automasters/utils/get_distinct_by.dart';
import 'package:flutter/material.dart';
import 'package:automasters/models/make.dart';
import 'package:string_capitalize/string_capitalize.dart';
import '../models/parts.dart';
import '../models/vehicle.dart';
import '../service/apiService.dart';
import '../utils/animation_transition.dart';
import '../view/vehicle_details.dart';
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

    return SingleChildScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      child: Container(
        height: SizeConfig.screenHeight! * 0.85,
        padding: const EdgeInsets.only(top: 7.0, bottom: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildPagerHead(context),
                /*IconButton(
                  tooltip: isMakeSelected ? "Go Back" : "Close",
                  onPressed: () {
                    isMakeSelected
                        ? setState(() => isMakeSelected = false)
                        : Navigator.pop(context);
                  },
                  icon: Icon(
                    isMakeSelected && isModelSelected ? Icons.arrow_back : Icons.clear,
                    //color: Colors.black26,
                  ),
                ),*/
              ],
            ),
            const Divider(thickness: 1),
            Expanded(
              child: (!isMakeSelected && !isModelSelected && !isYearSelected)
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
                  ? gridCarMakeCard(result)
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
                  ? gridCarModelCard(result)
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
                  ? gridCarYearsCard(result)
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

  /// Grid view display[gridCarMakeCard]
  GridView gridCarMakeCard(List<MakeModel> result) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: result.length,
      padding: buildEdgeInsets(),
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: buildSliverGridDelegateWithFixedCrossAxisCount(),
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
    );
  }

  /// Grid view display[gridCarModelCard]
  GridView gridCarModelCard(List<Model> result) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: result.length,
      padding: buildEdgeInsets(),
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: buildSliverGridDelegateWithFixedCrossAxisCount(),
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
    );
  }

  /// Grid view display[gridCarYearsCard]
  GridView gridCarYearsCard(List<dynamic> result) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: result.length,
      padding: buildEdgeInsets(),
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: buildSliverGridDelegateWithFixedCrossAxisCount(),
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
    );
  }

  removeDuplicate(List<PartModel> result, bool isPart) {
    return result
        .getDistinctBy((PartModel x) => isPart ? x.part : x.engineType)
        .toList();
  }

  /// List view display[listEngineTypeCard]
  ListView listEngineTypeCard(List<PartModel> result) {
    List<PartModel> distinctEngineList = removeDuplicate(result, false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: distinctEngineList.length,
      padding: buildEdgeInsets(),
      // physics: NeverScrollableScrollPhysics(),
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
          );

  OutlinedButton buildOutlinedButton(String label,
      {required Function() onPress, bool isSelected = false}) {
    Color cl = Theme.of(context).colorScheme.primaryContainer;

    return OutlinedButton(
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
    );
  }
}
