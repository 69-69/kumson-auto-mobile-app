import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/question_button.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_card.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/models/vendor.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/column_builder.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/show_confirmation_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PartsByPrice extends StatelessWidget {
  final Map<String, dynamic> map;

  const PartsByPrice({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    PartModel cPart = map['part'] as PartModel;
    VehicleModel cVehicle = map['vehicle'] as VehicleModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [
          CustomSliverAppBar(
            data: _customAppBarModel(cVehicle, cPart),
          ),
        ],
        body: _HunterPartsBc(carPart: cPart, vehicle: cVehicle),
        // _buildBody(context, cPart),
      ),
    );
  }

  CustomAppBarModel _customAppBarModel(VehicleModel cVehicle, PartModel cPart) {
    return CustomAppBarModel(
      imageUrl: kDefaultPartImage,
      videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
      title: "${cVehicle.year} ${cVehicle.make} ${cVehicle.model}",
      subTitle: cPart.part!,
      subMiniTitle: "${cPart.part}s".capitalizeEach(),
      expandedHeight: getProportionateScreenHeight(250),
      currentScreen: partRequest,
    );
  }
}

class _HunterPartsBc extends StatelessWidget {
  const _HunterPartsBc({
    required this.carPart,
    required this.vehicle,
  });

  final PartModel carPart;
  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    return _hunterPartsBlocBody(context);
  }

  void _getHunterParts(BuildContext context) {
    context
        .read<HunterPartsByHunterNoBloc>()
        .add(GetHunterPartsByHunterNoEvent(carPart.hunter!));
  }

  BlocBuilder<HunterPartsByHunterNoBloc, HunterState> _hunterPartsBlocBody(
      BuildContext context) {
    _getHunterParts(context);

    return BlocBuilder<HunterPartsByHunterNoBloc, HunterState>(
        // If listenWhen returns true, listener will be called with new state
        // buildWhen: (previousState, state) => state != previousState,
        builder: (hunterContext, state) {
      if (state is HunterLoading) {
        // return Text("HuntersState");
        return _loadSpinner();
      }

      if (state is HunterDone) {
        return _PartsCard(
          vehicle: vehicle,
          part: carPart.part!,
          hunter: state.hunter as List<HunterModel>,
        );
      }

      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: InlineRequestButton(reqType: crossRefRequest),
      );
    });
  }
}

class _PartsCard extends StatefulWidget {
  const _PartsCard({
    required this.part,
    required this.hunter,
    required this.vehicle,
  });

  final String part;
  final VehicleModel vehicle;
  final List<HunterModel> hunter;

  @override
  State<_PartsCard> createState() => _PartsCardState();
}

class _PartsCardState extends State<_PartsCard> {
  bool notFound = false;

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  /// Parts Details [buildPartsDetails]
  Widget _buildCard(BuildContext hunterContext) {
    return buildCurveContainer(
      hunterContext,
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customLine(widget.part.toUpperCase(), hunterContext),
              buildQuestionButton(
                hunterContext,
                onPress: () => displayDialog(hunterContext),
              ),
            ],
          ),
          const Divider(indent: 40),
          Expanded(
            child: notFound
                ? const InlineRequestButton(reqType: priceRequest)
                : _ListCard(
                    hunter: widget.hunter,
                    vehicle: widget.vehicle,
                    onNotFound: (bool val) => setState(() => notFound = val),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.vehicle,
    required this.hunter,
    required this.onNotFound,
  });

  final Function(bool) onNotFound;
  final VehicleModel vehicle;
  final List<HunterModel> hunter;

  @override
  Widget build(BuildContext context) {
    return buildListView();
  }

  /// done-1 List view display[buildListView]
  buildListView() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: ColumnBuilder(
        itemCount: hunter.length,
        itemBuilder: (context, index) {
          HunterModel hunterPart = hunter[index];
          bool isLastIndex = index == hunter.length - 1;

          return InkWell(
            onTap: () {
              Map<String, dynamic> data = {
                'hunter': hunterPart,
                'vehicle': vehicle
              };

              pageNavigator(
                context,
                routeName: partDetailsCheckout,
                arguments: data,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: buildListCard(hunterPart, isLastIndex),
            ),
          );
        },
      ),
    );
  }

  /// Card [buildListCard]
  Card buildListCard(HunterModel huntPart, bool isLastIndex) {
    return customCard(
      shape: isLastIndex
          ? const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            )
          : null,
      child: _VendorPartsBc(
        huntPart: huntPart,
        isLastIndex: isLastIndex,
        onNotFound: (bool val) => onNotFound(val),
      ),
    );
  }
}

class _VendorPartsBc extends StatelessWidget {
  const _VendorPartsBc({
    required this.huntPart,
    required this.onNotFound,
    required this.isLastIndex,
  });

  final Function(bool) onNotFound;
  final HunterModel huntPart;
  final bool isLastIndex;

  @override
  Widget build(BuildContext context) {
    return _vendorPartsBloc(context);
  }

  void _getVendorParts(BuildContext context) {
    context
        .read<VendorPartsByBrandPartNoBloc>()
        .add(GetVendorPartsByBrandPartNo(huntPart.brand!, huntPart.partNo!));
  }

  /// Get Prices From Vendors [_vendorPartsBloc]
  BlocBuilder<VendorPartsByBrandPartNoBloc, VendorState> _vendorPartsBloc(
    BuildContext context,
  ) {
    _getVendorParts(context);
    // VendorModel s= context.select((VendorPartsByBrandPartNoBloc v) => v.state.vendor);

    return BlocBuilder<VendorPartsByBrandPartNoBloc, VendorState>(
      // If listenWhen returns true, listener will be called with new state
      buildWhen: (preState, curState) => preState != curState,
      builder: (vendorContext, state) {
        if (state is VendorLoading) {
          // return Text("VendorsState");
          return _loadSpinner();
        }

        if (state is VendorDone) {
          return _buildShowPrice(
              vendorContext, state.vendor! as List<VendorModel>);
        }
        if (isLastIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onNotFound(true);
          });
        }

        return const SizedBox.shrink();
      },
    );
  }

  _buildShowPrice(BuildContext context, List<VendorModel> result) {
    /// Filtering for Min-Price without OPM
    VendorModel minPriceWithoutOPM =
        result.reduce((VendorModel curr, VendorModel next) {
      return (curr.stockStatus == "instock" && next.stockStatus == "instock") &&
              (curr.opm == "no" && curr.opm == "no") &&
              curr.currentPrice! < next.currentPrice!
          ? curr
          : next;
    });

    /// Filtering for Min-Price with OPM
    VendorModel minPriceWithOPM = result.first;
    for (var e in result) {
      if (e.stockStatus == "instock" &&
          e.opm == "yes" &&
          e.currentPrice! < minPriceWithOPM.currentPrice!) {
        minPriceWithOPM = e;
      }
    }

    return _minPriceCard(context, minPriceWithOPM, minPriceWithoutOPM);
  }

  Column _minPriceCard(
    BuildContext context,
    VendorModel withOPM,
    VendorModel withoutOPM,
  ) {
    String productAge = AppLocalService().getProductStatus();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (withoutOPM.stockStatus == "instock" &&
            withoutOPM.opm == "no" &&
            withoutOPM.productAge == productAge) ...{
          buildTag(context, withoutOPM),
          Row(
            children: [
              buildContainerImage(child: Image.asset(kDefaultPartImage)),
              buildProductInfo(withoutOPM.partNo!.toUpperCase(),
                  "$ghCediSign ${withoutOPM.currentPrice}"),
            ],
          ),
        },
        if (withOPM.stockStatus == "instock" &&
            withOPM.opm == "yes" &&
            withOPM.productAge == productAge) ...{
          const Divider(height: 1.0),
          buildTag(context, withOPM, isRadius: false),
          Row(
            children: [
              buildContainerImage(child: Image.asset(kDefaultPartImage)),
              buildProductInfo(withOPM.partNo!.toUpperCase(),
                  "$ghCediSign ${withOPM.currentPrice}"),
            ],
          ),
        }
      ],
    );
  }

  Row buildTag(
    BuildContext context,
    VendorModel vendor, {
    bool isRadius = true,
  }) {
    String opmCheck(String opm) => opm == "yes" ? "OPEN MARKET " : "";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        tagCard(
          context,
          child: tagLabel(
              "${vendor.brand} ${opmCheck(vendor.opm!)}${vendor.brandType}",
              color: Theme.of(context).colorScheme.onInverseSurface),
          isRadius: isRadius,
        ),
        tagCard(
          context,
          child: tagLabel(vendor.productAge!),
          isRadius: false,
          radiusRight: true,
        ),
      ],
    );
  }

  Text tagLabel(String label, {Color? color}) {
    return Text(
      label.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(10),
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
      ),
    );
  }

  Container tagCard(
    BuildContext context, {
    required Text child,
    bool isRadius = true,
    bool radiusRight = false,
  }) {
    Radius r = const Radius.circular(8.0);
    ColorScheme theme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: radiusRight ? theme.primary : theme.onSurfaceVariant,
        borderRadius: isRadius
            ? BorderRadius.only(topLeft: r)
            : BorderRadius.only(topRight: radiusRight ? r : Radius.zero),
      ),
      child: child,
    );
  }
}

Padding _loadSpinner() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: showCircularProgress(strokeWidth: 3, width: 20, height: 20),
  );
}

displayDialog(BuildContext context) async {
  final opt = await showConfirmationDialog(
    context,
    title: "Searching",
    isDismissible: false,
    positiveResponse: "New",
    negativeResponse: "Used",
    const Text("...for New or Used Car Parts?"),
  );
  if (context.mounted && opt != "cancel") {
    await AppLocalService().saveProductStatus(opt);

    // Refresh Screen after Dialog Changes
    // Future.delayed(const Duration(seconds: 1), () => setState(() {}));
  }
}
