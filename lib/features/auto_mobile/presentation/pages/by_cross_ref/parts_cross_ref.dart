import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_state.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/column_builder.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_card.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/bottom_sheet/make_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PartsCrossRef extends StatelessWidget {
  final Map<String, dynamic> data;

  const PartsCrossRef({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    PartModel cPart = data['part'] as PartModel;
    VehicleModel vehicle = data['vehicle'] as VehicleModel;

    context
        .read<HunterPartsByHunterNoBloc>()
        .add(GetHunterPartsByHunterNo(cPart.hunter!));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) {
          CustomAppBarModel appBarInfo = CustomAppBarModel(
            imageUrl: kDefaultPartImage,
            title: "${vehicle.year} ${vehicle.make} ${vehicle.model}",
            subTitle: "${cPart.part!} for",
            subMiniTitle: "Available ${cPart.part}".capitalizeEach(),
            expandedHeight: getProportionateScreenHeight(250),
            currentScreen: crossRefRequest,
          );

          return [CustomSliverAppBar(data: appBarInfo)];
        },
        body: _buildBlocBuilder(cPart, vehicle),
        //
      ),
    );
  }

  BlocBuilder<HunterPartsByHunterNoBloc, HuntersState> _buildBlocBuilder(
    PartModel cPart,
    VehicleModel vehicle,
  ) {
    return BlocBuilder<HunterPartsByHunterNoBloc, HuntersState>(
        builder: (context, state) {
      if (state is HuntersLoading) {
        return _loadSpinner();
      }

      if (state is HuntersError) {
        return buildRefreshApp(context);
      }

      if (state is HuntersDone) {
        return _buildBody(
          context,
          cPart.part!,
          state.hunters! as List<HunterModel>,
          vehicle,
        );
      }

      return showMakeRequestButton(context, readOnlyPartNoKey);
    });
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 20, height: 20),
    );
  }

  /// Parts Details [buildPartsDetails]
  Widget _buildBody(
    BuildContext context,
    String part,
    List<HunterModel> hunter,
    VehicleModel vehicle,
  ) {
    return buildCurveContainer(
      context,
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customLine(part.toUpperCase(), context),
            ],
          ),
          const Divider(indent: 40),
          Expanded(
            child: buildListView(hunter, vehicle),
          ),
        ],
      ),
    );
  }

  /// List view display[buildListView]
  buildListView(result, VehicleModel vehicle) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: ColumnBuilder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          HunterModel huntPart = result[index];
          bool isLastIndex = index == result.length - 1;

          return InkWell(
            onTap: () {
              Map<String, dynamic> data = {
                'hunter': huntPart,
                'vehicle': vehicle
              };

              pageNavigator(
                context,
                routeName: partDetailsCheckout,
                arguments: data,
              );
              /*animateTransition(
                context,
                PartDetailsCheckout(
                    huntPart: huntPart, vehicle: widget.vehicle));*/
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: buildListCard(context, huntPart, isLastIndex),
            ),
          );
        },
      ),
    );
  }

  /// Card [buildListCard]
  Card buildListCard(
      BuildContext context, HunterModel huntPart, bool isLastIndex) {
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildContainerImage(child: Image.asset(kDefaultPartImage)),
          buildProductInfo(
              huntPart.brand!.capitalizeEach(), huntPart.partNo!.capitalize()),
        ],
      ),
    );
  }
}
