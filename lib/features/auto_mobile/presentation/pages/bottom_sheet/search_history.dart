import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_capitalize/string_capitalize.dart';

import 'custom_bottom_sheet.dart';

// typedef OnSearchChanged = String Function(String);

/*const tabsTitle = [
  "Searches by VIN",
  "Searches by Part No." */ /*, "Manual"*/ /*
];*/

class SearchHistory extends StatelessWidget {
  final List<String> oldFilters;

  const SearchHistory({
    super.key,
    this.oldFilters = const [],
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return CustomBottomSheet(
      initialChildSize: 0.4,
      // bgColor: const Color.fromRGBO(250, 249, 249, 0.3),
      padding: const EdgeInsets.symmetric(vertical: 20),
      headerWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildBackButton(context),
            const Text(
              "Search History",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
      child: SizedBox(
        height: SizeConfig.screenHeight,
        child: _buildListView(key: vinSearchHistoryCacheKey, id: "vin"),
      ),
    );
  }

  _buildListView({required String key, String id = ""}) {
    List<String> historyData = AppLocalService().getHistory(key: key).toList();

    return historyData.isNotEmpty
        ? ListView.separated(
            itemCount: historyData.length,
            itemBuilder: (context, int i) => _VehicleBc(vin: historyData[i]),
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: getProportionateScreenWidth(20.0),
              endIndent: getProportionateScreenWidth(40.0),
            ),
          )
        : const SizedBox.shrink();
  }

/*itemBuilder(String searchKey, String id, BuildContext context) {
    return id == "vin"
        ? _VehicleBc(vin: searchKey)
        : id == "part"
            ? _PartsBc(partNo: searchKey)
            : const SizedBox.shrink();
  }

  DefaultTabController _buildBody() {
    return DefaultTabController(
      length: tabsTitle.length,
      initialIndex: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            isScrollable: true,
            tabs: tabsTitle.map((String e) => Tab(text: e)).toList(),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TabBarView(
                children: [
                  _buildListView(key: vinSearchHistoryCacheKey, id: "vin"),
                  _buildListView(key: partNoSearchHistoryCacheKey, id: "part"),
                  // _buildListView(key: manualSearchHistoryCacheKey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}

class _VehicleBc extends StatelessWidget {
  const _VehicleBc({required this.vin});

  final String vin;

  @override
  Widget build(BuildContext context) {
    return vehicleBloc(context);
  }

  BlocBuilder vehicleBloc(BuildContext context) {
    context.read<VehicleByVinBloc>().add(GetVehicleByVinEvent(vin));

    return BlocBuilder<VehicleByVinBloc, VehicleState>(
      builder: (context2, state) {
        if (state is VehicleLoading) {
          return _loadSpinner();
        }

        if (state is VehicleError) {
          return buildRefreshApp(context);
        }

        if (state is VehicleDone) {
          return _vehicleCard(state, vin, context2);
        }

        return const SizedBox();
      },
    );
  }

  _vehicleCard(VehicleDone state, String vin, BuildContext context) {
    VehicleModel v = state.vehicle as VehicleModel;
    Map<String, dynamic> vic = {"vehicle": v};

    return buildListTile(
      "${v.year} ${v.make} ${v.model}",
      subTitle: vin,
      onTap: () {
        pageNavigator(
          context,
          routeName: vehicleDetailsRoute,
          arguments: vic,
        );
      },
    );
  }

  ListTile buildListTile(
    String title, {
    String subTitle = '',
    void Function()? onTap,
  }) {
    return ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.capitalizeEach(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.adaptive.arrow_forward, size: 14, color: Colors.grey),
        ],
      ),
      subtitle: SelectionArea(child: Text(subTitle.toUpperCase())),
      onTap: onTap,
    );
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: showCircularProgress(strokeWidth: 2, width: 15, height: 15),
    );
  }
}

/*class _PartsBc extends StatelessWidget {
  const _PartsBc({required this.partNo});

  final String partNo;

  @override
  Widget build(BuildContext context) {
    return _partsBloc(context);
  }

  BlocBuilder _partsBloc(BuildContext context) {
    context
        .read<HunterPartsByPartNoBloc>()
        .add(GetHunterPartsByPartNoEvent(partNo));

    return BlocBuilder<HunterPartsByPartNoBloc, HunterState>(
      builder: (_, state) {
        if (state is HunterLoading) {
          return _loadSpinner();
        }

        if (state is HunterError) {
          return buildRefreshApp(context);
        }

        if (state is HunterDone) {
          return _partsCard(state, partNo);
        }

        return const SizedBox();
      },
    );
  }

  ColumnBuilder _partsCard(HunterDone state, String partNo) {
    List<HunterModel> hunterParts = state.hunter as List<HunterModel>;

    return ColumnBuilder(
      itemCount: hunterParts.length,
      itemBuilder: (context, int i) {
        HunterModel p = hunterParts[i];

        return buildListTile(
          "${p.product} ${p.brand}",
          subTitle: partNo,
          onTap: () {
            pageNavigator(
              context,
              routeName: partsByPartNoRoute,
              arguments: hunterParts,
            );
          },
        );
      },
    );
  }

  ListTile buildListTile(
    String title, {
    String subTitle = '',
    void Function()? onTap,
  }) {
    return ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.capitalizeEach(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.adaptive.arrow_forward, size: 14, color: Colors.grey),
        ],
      ),
      subtitle: SelectionArea(child: Text(subTitle.toUpperCase())),
      onTap: onTap,
    );
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: showCircularProgress(strokeWidth: 2, width: 15, height: 15),
    );
  }
}*/
