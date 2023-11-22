import 'package:flutter/material.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/vehicle/filter_parts_category.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/make_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  VehicleDetails({
    super.key,
    required this.data,
  });

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    VehicleModel vehicle = data['vehicle'] as VehicleModel;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) {
          CustomAppBarModel appBarInfo = CustomAppBarModel(
            title: vehicle.category!,
            subTitle: "${vehicle.year} ${vehicle.make} ${vehicle.model}",
            subMiniTitle: "${vehicle.make!} - ${vehicle.model!}",
            expandedHeight: getProportionateScreenHeight(
              focusNode.hasPrimaryFocus ? 100 : 250,
            ),
            currentScreen: vinRequest,
            imageUrl: kDefaultCarImage,
            videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
          );

          return [CustomSliverAppBar(data: appBarInfo)];
        },
        body: _buildBody(context, vehicle),
      ),
    );
  }

  Widget _buildBody(BuildContext parentContext, VehicleModel vehicle) {
    return buildCurveContainer(
      parentContext,
      EdgeInsets.fromLTRB(
        24.0,
        32.0,
        24.0,
        MediaQuery.of(parentContext).viewInsets.bottom,
      ),
      child: data.containsKey('parts') && data['parts'] != null
          ? FilterPartsCategory(
              focusNode: focusNode, vehicle: vehicle, carParts: data['parts'])
          : _partsBloc(parentContext, vehicle),
    );
  }

  BlocBuilder<PartsByVFamBloc, PartsState> _partsBloc(
      BuildContext parentContext, VehicleModel vehicle) {
    _getPartsFunc(parentContext, vehicle);

    return BlocBuilder<PartsByVFamBloc, PartsState>(
      // If listenWhen returns true, listener will be called with new state
      // buildWhen: (previousState, state) => state != previousState,
      builder: (partsContext, state) {
        if (state is PartsLoading) {
          return showCircularProgress();
        }

        if (state is PartsError) {
          return buildRefreshApp(partsContext);
        }

        if (state is PartsDone) {
          List<PartModel> veh = state.part! as List<PartModel>;

          return FilterPartsCategory(
              focusNode: focusNode, vehicle: vehicle, carParts: veh);
        }
        return showMakeRequestButton(partsContext, "partRequest");
      },
    );
  }

  void _getPartsFunc(BuildContext partsContext, VehicleModel vehicle) {
    partsContext
        .read<PartsByVFamBloc>()
        .add(GetPartsByVFamEvent(vehicle.vfam!));
  }
}
