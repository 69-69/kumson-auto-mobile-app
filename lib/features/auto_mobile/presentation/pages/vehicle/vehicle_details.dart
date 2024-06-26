import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/util/get_distinct_by.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/vehicle/filter_parts_category.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';

class VehicleDetails extends StatelessWidget {
  final Map<String, dynamic> map;

  VehicleDetails({
    super.key,
    required this.map,
  });

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    VehicleModel vehicle = map['vehicle'];

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
            currentScreen: partRequest,
            imageUrl: kDefaultCarImage,
            videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
          );

          return [CustomSliverAppBar(data: appBarInfo)];
        },
        body: _buildBody(context, vehicle),
      ),
    );
  }

  _removeDuplicate(List<PartModel> result) =>
      result.getDistinctBy((PartModel x) => x.part!).toList();

  Widget _buildBody(BuildContext parentContext, VehicleModel vehicle) {
    return buildCurveContainer(
      parentContext,
      EdgeInsets.fromLTRB(
        24.0,
        32.0,
        24.0,
        MediaQuery.of(parentContext).viewInsets.bottom,
      ),
      child: map.containsKey('parts') && map['parts'] != null
          ? FilterPartsCategory(
              focusNode: focusNode,
              vehicle: vehicle,
              carParts: _removeDuplicate(map['parts']),
            )
          : _PartBc(vehicle: vehicle, focusNode: focusNode),
    );
  }
}

class _PartBc extends StatelessWidget {
  const _PartBc({required this.vehicle, required this.focusNode});

  final VehicleModel vehicle;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return _partsBloc(context);
  }

  BlocBuilder<PartsByVFamBloc, PartState> _partsBloc(
      BuildContext parentContext) {
    _getPartsFunc(parentContext, vehicle);

    return BlocBuilder<PartsByVFamBloc, PartState>(
      // If listenWhen returns true, listener will be called with new state
      // buildWhen: (previousState, state) => state != previousState,
      builder: (partsContext, state) {
        if (state is PartLoading) {
          return showCircularProgress();
        }

        /*if (state is PartsError) {
          return buildRefreshApp(partsContext);
        }*/

        if (state is PartDone) {
          List<PartModel> veh = state.part! as List<PartModel>;

          return FilterPartsCategory(
              focusNode: focusNode, vehicle: vehicle, carParts: veh);
        }
        return const InlineRequestButton(reqType: partRequest);
      },
    );
  }

  void _getPartsFunc(BuildContext partsContext, VehicleModel vehicle) {
    partsContext
        .read<PartsByVFamBloc>()
        .add(GetPartsByVFamEvent(vehicle.vfam!));
  }
}
