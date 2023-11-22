import 'package:flutter/material.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/search_history_service.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/data/models/vendor.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/column_builder.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/make_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/show_confirmation_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/question_button.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/refresh_button.dart';

class PartsByPartNo extends StatefulWidget {
  // static const String routeName = "/parts_by_part_no";
  final List<HunterModel> hunters;

  const PartsByPartNo({
    super.key,
    required this.hunters,
  });

  @override
  State<PartsByPartNo> createState() => _PartsByPartNoState();
}

class _PartsByPartNoState extends State<PartsByPartNo> {
  String productAge = "";
  VehicleModel vehicle = const VehicleModel();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final hunters = widget.hunters;

    productAge = SearchHistoryDB().getProductStatus();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: buildNestedScrollView(hunters, context),
    );
  }

  NestedScrollView buildNestedScrollView(
      List<HunterModel> hunters, BuildContext context) {
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (_, __) {
        CustomAppBarModel appBar = CustomAppBarModel(
          title: hunters[0].product!,
          subTitle: _buildSubTitle(),
          subMiniTitle: "${hunters[0].product}s",
          expandedHeight: getProportionateScreenHeight(250),
          currentScreen: partNoRequest,
          imageUrl: kDefaultCarImage,
          videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
        );

        return [CustomSliverAppBar(data: appBar)];
      },
      body: _buildBody(context, hunters),
    );
  }

  String _buildSubTitle() {
    return vehicle.make == null
        ? ""
        : "${vehicle.year} ${vehicle.make} ${vehicle.model}";
  }

  _buildBody(BuildContext context, List<HunterModel> hunters) {
    return buildCurveContainer(
      context,
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customLine(hunters[0].brand!.toUpperCase(), context),
              buildQuestionButton(
                context,
                onPress: () => displayDialog(context),
              ),
            ],
          ),
          const Divider(indent: 40),
          Expanded(
            child: _buildListView(hunters),
          ),
        ],
      ),
    );
  }

  /// List view display[buildListView]
  _buildListView(result) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: ColumnBuilder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          HunterModel huntPart = result[index];
          // bool isLastIndex = index == result.length - 1;

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
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Card(
                elevation: 2.0,
                child: _vendorPartsBloc(huntPart),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Get Prices From Vendors [_vendorPartsBloc]
  Builder _vendorPartsBloc(HunterModel huntPart) {
    context
        .read<PartByHunterNoBloc>()
        .add(GetPartByHunterNoEvent(huntPart.hunter!));

    context
        .read<VendorPartsByBrandPartNoBloc>()
        .add(GetVendorPartsByBrandPartNo(huntPart.brand!, huntPart.partNo!));

    return Builder(builder: (context) {
      final pState = context.watch<PartByHunterNoBloc>().state;
      final cState = context.watch<VehicleByVinBloc>().state;
      final state = context.watch<VendorPartsByBrandPartNoBloc>().state;

      if (pState is PartsError) {
        return buildRefreshApp(context);
      }

      if (pState is PartsLoading) {
        return _loadSpinner();
      }

      if (pState is PartsDone) {
        context
            .read<VehicleByVinBloc>()
            .add(GetVehicleByVinEvent(pState.part!.vin ?? ""));
      }

      if (cState is VehiclesLoading) {
        return _loadSpinner();
      }

      if ((cState is VehiclesDone) && (state is VendorsDone)) {
        final car = cState.vehicle! as VehicleModel;
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => setState(() => vehicle = car),
        );

        final vendors = state.vendor as List<VendorModel>;
        return _buildShowPrice(vendors, car);
      }
      return showMakeRequestButton(context, "partRequest");
    });
  }

  Column _buildShowPrice(List<VendorModel> vendor, VehicleModel vehicleData) {
    if (context.mounted) {
      // Future.delayed(const Duration(seconds: 1));
      SchedulerBinding.instance
          .addPostFrameCallback((_) => vehicle = vehicleData);
    }

    /// Filtering for Min-Price without OPM
    VendorModel minPriceWithoutOPM =
        vendor.reduce((VendorModel curr, VendorModel next) {
      return (curr.stockStatus == "instock" && next.stockStatus == "instock") &&
              (curr.opm == "no" && curr.opm == "no") &&
              curr.currentPrice! < next.currentPrice!
          ? curr
          : next;
    });

    /// Filtering for Min-Price with OPM
    VendorModel minPriceWithOPM = vendor.first;
    for (var e in vendor) {
      if (e.stockStatus == "instock" &&
          e.opm == "yes" &&
          e.currentPrice! < minPriceWithOPM.currentPrice!) {
        minPriceWithOPM = e;
      }
    }

    return _minPriceCard(minPriceWithoutOPM, minPriceWithOPM);
  }

  Column _minPriceCard(
    VendorModel withoutOPM,
    VendorModel withOPM,
  ) {
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
            withoutOPM.productAge == productAge) ...{
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

  Column buildColumn(
    VendorModel minPriceWithoutOPM,
    BuildContext context,
    VendorModel minPriceWithOPM,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (minPriceWithoutOPM.opm == "no" &&
            minPriceWithoutOPM.productAge == productAge) ...{
          buildTag(context, minPriceWithoutOPM),
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
            minPriceWithoutOPM.productAge == productAge) ...{
          const Divider(height: 1.0),
          buildTag(context, minPriceWithOPM, isRadius: false),
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
          child: tagLabel(
              "${vendor.brand} ${opmCheck(vendor.opm!)}${vendor.brandType}",
              color: Theme.of(context).colorScheme.onInverseSurface),
          isRadius: isRadius,
        ),
        tagCard(
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

  Container tagCard({
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
      await SearchHistoryDB().saveProductStatus(opt);

      // Refresh Screen after Dialog Changes
      Future.delayed(
        const Duration(seconds: 1),
        () => setState(() {}),
      );
    }
  }
}
