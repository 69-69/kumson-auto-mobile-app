import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/bottom_sheet/make_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/question_button.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_e.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_card.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/product_status_service.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/models/vendor.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/column_builder.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/bottom_sheet/show_confirmation_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PartsByPrice extends StatefulWidget {
  final Map<String, dynamic> data;

  const PartsByPrice({super.key, required this.data});

  @override
  State<PartsByPrice> createState() => _PartsByPriceState();
}

class _PartsByPriceState extends State<PartsByPrice> {
  String _productAge = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    PartModel carPart = widget.data['part'] as PartModel;
    VehicleModel vehicle = widget.data['vehicle'] as VehicleModel;

    _productAge = ProductStatusService().getStatus();

    _getHunterParts(context, carPart);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) {
          CustomAppBarModel appBarInfo = CustomAppBarModel(
            imageUrl: kDefaultPartImage,
            videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
            title: "${vehicle.year} ${vehicle.make} ${vehicle.model}",
            subTitle: carPart.part!,
            subMiniTitle: "${carPart.part}s".capitalizeEach(),
            expandedHeight: getProportionateScreenHeight(250),
            currentScreen: partRequest,
          );

          return [CustomSliverAppBar(data: appBarInfo)];
        },
        body: _hunterPartsBloc(carPart, vehicle),
        // _buildBody(context, cPart),
      ),
    );
  }

  void _getHunterParts(BuildContext context, PartModel carPart) {
    context
        .read<HunterPartsByHunterNoBloc>()
        .add(GetHunterPartsByHunterNo(carPart.hunter!));
  }

  BlocBuilder<HunterPartsByHunterNoBloc, HuntersState> _hunterPartsBloc(
    PartModel carPart,
    VehicleModel vehicle,
  ) {
    return BlocBuilder<HunterPartsByHunterNoBloc, HuntersState>(
        // If listenWhen returns true, listener will be called with new state
        buildWhen: (previousState, state) => state != previousState,
        builder: (context2, state) {
          if (state is HuntersLoading) {
            return _loadSpinner();
          }

          if (state is HuntersDone) {
            return _buildBody(
              context2,
              carPart.part!,
              state.hunters! as List<HunterModel>,
              vehicle,
            );
          }

          if (state is HuntersError) {
            return buildRefreshApp(context);
          }

          return showRequestModal(context, "crossRefRequest");
        });
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
              buildQuestionButton(
                context,
                onPress: () => displayDialog(context),
              ),
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

  /// done-1 List view display[buildListView]
  buildListView(result, VehicleModel vehicle) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: ColumnBuilder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          HunterModel huntPart = result[index];
          bool isLastIndex = index == result.length - 1;

          return InkWell(
            onTap: () {
              Map<String, dynamic> data = {
                'part': huntPart,
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
              child: buildListCard(huntPart, isLastIndex),
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
      child: _vendorPartsBloc(huntPart),
    );
  }

  /// Get Prices From Vendors [blocBuilder]
  BlocBuilder<VendorPartsByBrandPartNoBloc, VendorsState> _vendorPartsBloc(
      HunterModel huntPart) {
    _getVendorParts(huntPart);

    return BlocBuilder<VendorPartsByBrandPartNoBloc, VendorsState>(
      // If listenWhen returns true, listener will be called with new state
      buildWhen: (previousState, state) => state != previousState,
      builder: (context, state) {
        if (state is VendorsLoading) {
          return _loadSpinner();
        }

        /*if (state is VendorsError) {
          return buildRefreshApp(context);
        }*/

        if (state is VendorsDone) {
          return _buildShowPrice(
              context, state.vendors! as List<VendorModel>);
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _getVendorParts(HunterModel huntPart) {
    context
        .read<VendorPartsByBrandPartNoBloc>()
        .add(GetVendorPartsByBrandPartNo(huntPart.brand!, huntPart.partNo!));
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

    return _showPriceCard(minPriceWithoutOPM, context, minPriceWithOPM);
  }

   Column _showPriceCard(VendorModel minPriceWithoutOPM, BuildContext context, VendorModel minPriceWithOPM) {
     return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (minPriceWithoutOPM.opm == "no" &&
          minPriceWithoutOPM.productAge == _productAge) ...{
        buildBadge(context, minPriceWithoutOPM),
        Row(
          children: [
            buildContainerImage(child: Image.asset(kDefaultPartImage)),
            buildProductInfo(minPriceWithoutOPM.partNo!.toUpperCase(),
                "$ghCediSign ${minPriceWithoutOPM.currentPrice}"),
          ],
        ),
      },
      if (minPriceWithOPM.stockStatus == "instock" &&
          minPriceWithOPM.opm == "yes" &&
          minPriceWithOPM.productAge == _productAge) ...{
        const Divider(height: 1.0),
        buildBadge(context, minPriceWithOPM, isRadius: false),
        Row(
          children: [
            buildContainerImage(child: Image.asset(kDefaultPartImage)),
            buildProductInfo(minPriceWithOPM.partNo!.toUpperCase(),
                "$ghCediSign ${minPriceWithOPM.currentPrice}"),
          ],
        ),
      }
    ],
  );
   }

  Row buildBadge(BuildContext context, VendorModel vendor,
      {bool isRadius = true}) {
    String opmCheck(String opm) => opm == "yes" ? "OPEN MARKET " : "";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildBadgeBg(
          context,
          child: buildBadgeLabel(
              "${vendor.brand} ${opmCheck(vendor.opm!)}${vendor.brandType}",
              color: Theme.of(context).colorScheme.onInverseSurface),
          isRadius: isRadius,
        ),
        buildBadgeBg(
          context,
          child: buildBadgeLabel(vendor.productAge!),
          isRadius: false,
          radiusRight: true,
        ),
      ],
    );
  }

  Text buildBadgeLabel(String label, {Color? color}) {
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

  Container buildBadgeBg(
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
      await ProductStatusService().saveStatus(opt);

      // Refresh Screen after Dialog Changes
      Future.delayed(const Duration(seconds: 1), () => setState(() {}));
    }
  }
}
