import 'package:flutter/material.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';
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
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/send_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/show_confirmation_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/question_button.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/refresh_button.dart';

class PartsByPartNo extends StatefulWidget {
  final List list;

  const PartsByPartNo({
    super.key,
    required this.list,
  });

  @override
  State<PartsByPartNo> createState() => _PartsByPartNoState();
}

class _PartsByPartNoState extends State<PartsByPartNo> {
  String productAge = "";
  List<HunterModel> hunters = [const HunterModel()];
  VehicleModel vehicle = const VehicleModel();

  @override
  void initState() {
    hunters = widget.list as List<HunterModel>;
    debugPrint(hunters.toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: buildNestedScrollView(context),
    );
  }

  NestedScrollView buildNestedScrollView(BuildContext context) {
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (_, __) {
        CustomAppBarModel appBar = CustomAppBarModel(
          title: hunters[0].product!,
          subTitle: _buildSubTitle(),
          subMiniTitle: "${hunters[0].product}s",
          expandedHeight: getProportionateScreenHeight(250),
          currentScreen: partRequest,
          imageUrl: kDefaultCarImage,
          videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
        );

        return [CustomSliverAppBar(data: appBar)];
      },
      body: _buildBody(context),
    );
  }

  String _buildSubTitle() {
    return vehicle.make == null
        ? ""
        : "${vehicle.year} ${vehicle.make} ${vehicle.model}";
  }

  _buildBody(BuildContext context) {
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
            child: _PartCard(
              hunters: hunters,
              vehicle: vehicle,
              onVehicle: (car) => setState(() => vehicle = car),
            ),
          ),
        ],
      ),
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
      Future.delayed(
        const Duration(seconds: 1),
        () => setState(() {}),
      );
    }
  }
}

class _PartCard extends StatelessWidget {
  const _PartCard({
    required this.hunters,
    required this.vehicle,
    required this.onVehicle,
  });

  final List<HunterModel> hunters;
  final VehicleModel vehicle;
  final Function(VehicleModel) onVehicle;

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  /// List view display[_buildListView]
  _buildListView() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: ColumnBuilder(
        itemCount: hunters.length,
        itemBuilder: (context, index) {
          HunterModel huntPart = hunters[index];
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
                child: _VendorPartsBc(
                  huntPart: huntPart,
                  onVehicle: (car) => onVehicle(car),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Get Prices From Vendors [_VendorPartsBc], [_vendorPartsBloc]
class _VendorPartsBc extends StatelessWidget {
  const _VendorPartsBc({
    required this.huntPart,
    required this.onVehicle,
  });

  final HunterModel huntPart;
  final Function(VehicleModel) onVehicle;

  @override
  Widget build(BuildContext context) {
    return _vendorPartsBloc(context);
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showCircularProgress(strokeWidth: 3, width: 20, height: 20),
    );
  }

  /// Get Prices From Vendors [_vendorPartsBloc]
  Builder _vendorPartsBloc(BuildContext context) {
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

      if (pState is PartError) {
        return buildRefreshApp(context);
      }

      if (pState is PartLoading) {
        return _loadSpinner();
      }

      if (pState is PartDone) {
        context
            .read<VehicleByVinBloc>()
            .add(GetVehicleByVinEvent(pState.part!.vin ?? ""));
      }

      if (cState is VehicleLoading) {
        return _loadSpinner();
      }

      if ((cState is VehicleDone) && (state is VendorDone)) {
        final car = cState.vehicle! as VehicleModel;
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => onVehicle(car),
        );

        final vendors = state.vendor as List<VendorModel>;
        return _ShowPrice(
          vendor: vendors,
          vehicleData: car,
        );
      }
      return const InlineRequestButton(reqType: partRequest);
    });
  }
}

/// [_ShowPrice] [_buildShowPrice]
class _ShowPrice extends StatelessWidget {
  const _ShowPrice({
    required this.vendor,
    required this.vehicleData,
  });

  final List<VendorModel> vendor;
  final VehicleModel vehicleData;

  @override
  Widget build(BuildContext context) {
    return _buildShowPrice();
  }

  _buildShowPrice() {
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

    return _PriceCard(
      minPriceWithoutOPM: minPriceWithoutOPM,
      minPriceWithOPM: minPriceWithOPM,
    );
  }
}

/// [_minPriceCard]
class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.minPriceWithoutOPM,
    required this.minPriceWithOPM,
  });

  final VendorModel minPriceWithoutOPM;
  final VendorModel minPriceWithOPM;

  @override
  Widget build(BuildContext context) {
    return _minPriceCard(context);
  }

  Column _minPriceCard(BuildContext context) {
    final productAge = AppLocalService().getProductStatus();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (minPriceWithoutOPM.stockStatus == "instock" &&
            minPriceWithoutOPM.opm == "no" &&
            minPriceWithoutOPM.productAge == productAge) ...{
          _StatusTag(vendor: minPriceWithoutOPM),
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
            minPriceWithOPM.productAge == productAge) ...{
          const Divider(height: 1.0),
          _StatusTag(vendor: minPriceWithOPM, isRadius: false),
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

/*
  // not in use
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
  }*/
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({
    this.isRadius = true,
    required this.vendor,
  });

  final VendorModel vendor;
  final bool isRadius;

  @override
  Widget build(BuildContext context) {
    return buildTag(context);
  }

  Row buildTag(BuildContext context) {
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
