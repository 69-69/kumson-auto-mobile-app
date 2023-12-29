import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/column_builder.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_card.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_capitalize/string_capitalize.dart';

class ListAllParts extends StatelessWidget {
  final Map<String, dynamic> map;

  const ListAllParts({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<PartModel> carParts = map['parts'] as List<PartModel>;
    VehicleModel vehicle = map['vehicle'] as VehicleModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) {
          CustomAppBarModel appBarInfo = CustomAppBarModel(
            expandedHeight: getProportionateScreenHeight(250),
            title: "Available Parts",
            currentScreen: partRequest,
            imageUrl: kDefaultPartImage,
            videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
          );

          return [CustomSliverAppBar(data: appBarInfo)];
        },
        body: _buildBody(context, carParts, vehicle),
      ),
    );
  }

  /// Parts Details [_buildBody]
  Widget _buildBody(
    BuildContext context,
    List<PartModel> carParts,
    VehicleModel vehicle,
  ) {
    return buildCurveContainer(
      context,
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customLine("Choose Your\nCar Part", context),
          const Divider(indent: 40),
          Expanded(
            child: _columnBuilder(carParts, vehicle),
          ),
        ],
      ),
    );
  }

  /// List view display[_columnBuilder]
  _columnBuilder(List<PartModel> carParts, VehicleModel vehicle) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: ColumnBuilder(
        itemCount: carParts.length,
        itemBuilder: (columnContext, index) {
          PartModel carPart = carParts[index];
          bool isLastIndex = index == carParts.length - 1;

          return carPart.part! != "0"
              ? _hunterPartsBloc(
            columnContext,
                  carPart,
                  vehicle,
                  isLastIndex,
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  /*_hunterPartsBloc(
    BuildContext context,
    PartModel carPart,
    VehicleModel vehicle,
    bool isLastIndex,
  ) {
    _getHunterParts(context, carPart.hunter!);

    final state =
        context.select<HunterPartsByHunterNoBloc, HuntersState>((HunterPartsByHunterNoBloc v) => v.state);

    if (state is HuntersLoading) {
      return _loadSpinner();
    }

    if (state is HuntersDone && state.hunter != null) {
      final hunterParts = state.hunter as List<HunterModel>;
      return _buildListView(carPart, vehicle, hunterParts, isLastIndex);
    }
    return SizedBox.shrink();
  }*/

  void _getHunterParts(BuildContext context, String hunterNo) {
    context
        .watch<HunterPartsByHunterNoBloc>()
        .add(GetHunterPartsByHunterNoEvent(hunterNo));
  }

  BlocBuilder<HunterPartsByHunterNoBloc, HunterState> _hunterPartsBloc(
    BuildContext context2,
    PartModel carPart,
    VehicleModel vehicle,
    bool isLastIndex,
  ) {
    _getHunterParts(context2, carPart.hunter!);

    return BlocBuilder<HunterPartsByHunterNoBloc, HunterState>(
        builder: (context, state) {
      if (state is HunterLoading) {
        return _loadSpinner();
      }

      /*if (state is HuntersError) {
        return const Text("context");
      }*/

      if (state is HunterDone) {
        final hunterParts = state.hunter! as List<HunterModel>;

        return _buildListView(
            carPart, vehicle, hunterParts, isLastIndex);
      }

      return const SizedBox();
    });
  }

  _buildListView(
    PartModel carPart,
    VehicleModel vehicle,
    List<HunterModel> hunterParts,
    bool isLastIndex,
  ) {

    return ColumnBuilder(
        itemCount: hunterParts.length,
        itemBuilder: (hunterContext, index) {
          HunterModel hunterPart = hunterParts[index];


          return InkWell(
            onTap: () {
              Map<String, dynamic> data = {
                'hunter': hunterPart,
                'vehicle': vehicle
              };

              pageNavigator(
                hunterContext,
                routeName: partDetailsCheckout,
                arguments: data,
              );
            },
            child: _buildCard(carPart, isLastIndex),
          );
        },
    );

  }

  /// Card [_buildCard]
  _buildCard(PartModel carPart, bool isLastIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: customCard(
        shape: isLastIndex
            ? const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              )
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                buildContainerImage(child: Image.asset(kDefaultPartImage)),
                buildProductInfo(
                  carPart.part!.capitalizeEach(),
                  carPart.model!.capitalize(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 20, height: 20),
    );
  }
}
