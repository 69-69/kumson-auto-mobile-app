import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';
import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_state.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';
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
  final Map<String, dynamic> data;

  const ListAllParts({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<PartModel> carParts = data['parts'] as List<PartModel>;
    VehicleModel vehicle = data['vehicle'] as VehicleModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) {
          CustomAppBarModel appBarInfo = CustomAppBarModel(
            title: "Available Parts",
            expandedHeight: getProportionateScreenHeight(250),
            currentScreen: partRequest,
            imageUrl: kDefaultPartImage,
            // routeName: vehicleDetailsRoute,
            // arguments: {"vehicle": vehicle},
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
        itemBuilder: (context, index) {
          PartModel carPart = carParts[index];
          bool isLastIndex = index == carParts.length - 1;

          return carPart.part! != "0"
              ? _buildBlocBuilder(
                  context,
                  carPart,
                  vehicle,
                  isLastIndex,
                  index,
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  BlocBuilder<HunterPartsByHunterNoBloc, HuntersState> _buildBlocBuilder(
    BuildContext context,
    PartModel carPart,
    VehicleModel vehicle,
    bool isLastIndex,
    int index,
  ) {
    context
        .read<HunterPartsByHunterNoBloc>()
        .add(GetHunterPartsByHunterNo(carPart.hunter!));

    return BlocBuilder<HunterPartsByHunterNoBloc, HuntersState>(
        builder: (_, state) {
      /*if (state is HuntersLoading) {
        return _loadSpinner();
      }*/

      if (state is HuntersDone) {
        final hunterParts = state.hunters! as List<HunterModel>;

        return _buildListView(
            context, carPart, vehicle, hunterParts, isLastIndex, index);
      }

      if (state is HuntersError) {
        return buildRefreshApp(context);
      }

      return const SizedBox();
    });
  }

  InkWell _buildListView(
    BuildContext context,
    PartModel carPart,
    VehicleModel vehicle,
    List<HunterModel> hunterParts,
    bool isLastIndex,
    int index,
  ) {
    return InkWell(
      onTap: () {
        Map<String, dynamic> data = {
          'hunter': hunterParts[index],
          'vehicle': vehicle
        };

        pageNavigator(context, routeName: partDetailsCheckout, arguments: data);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: _buildCard(carPart, isLastIndex),
      ),
    );
  }

  /*Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 20, height: 20),
    );
  }*/

  /// Card [_buildCard]
  Card _buildCard(PartModel carPart, bool isLastIndex) {
    return customCard(
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
    );
  }
}
