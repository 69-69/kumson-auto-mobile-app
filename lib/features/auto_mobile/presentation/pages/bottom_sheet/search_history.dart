import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/search_history_service.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/column_builder.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/refresh_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_capitalize/string_capitalize.dart';

import 'custom_bottom_sheet.dart';

// typedef OnSearchChanged = String Function(String);

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
      headerWidget: const Text(
        "Search History",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      child: SizedBox(
        height: SizeConfig.screenHeight,
        child: _buildBody(),
      ),
    );
  }

  _buildListView({required String key, String id = ""}) {
    List<String> historyData = SearchHistoryDB().getHistory(key: key).toList();

    return historyData.isNotEmpty ? ListView.separated(
      itemCount: historyData.length,
      itemBuilder: (context, int i) => itemBuilder(historyData[i], id, context),
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: getProportionateScreenWidth(20.0),
        endIndent: getProportionateScreenWidth(40.0),
      ),
    ) : const SizedBox.shrink();
  }

  itemBuilder(String searchKey, String id, BuildContext context) {
    return id == "vin"
        ? vehicleBloc(searchKey, context)
        : id == "part"
            ? _partsBloc(searchKey, context)
            : const SizedBox.shrink();
  }

  ListTile buildListTile(String title, String subTitle, {void Function()? onTap}) {
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

  BlocBuilder vehicleBloc(String vin, BuildContext context) {
    context.read<VehicleByVinBloc>().add(GetVehicleByVinEvent(vin));

    return BlocBuilder<VehicleByVinBloc, VehiclesState>(
      builder: (context2, state) {
        if (state is VehiclesLoading) {
          return _loadSpinner();
        }

        if (state is VehiclesError) {
          return buildRefreshApp(context);
        }

        if (state is VehiclesDone) {
          return _vehicleCard(state, vin, context2);
        }

        return const SizedBox();
      },
    );
  }

  _vehicleCard(VehiclesDone state, String vin, BuildContext context) {

    VehicleModel v = state.vehicle as VehicleModel;
    Map<String, dynamic> vic = {"vehicle": v};

    return buildListTile("${v.year} ${v.make} ${v.model}", vin, onTap: (){

      pageNavigator(
        context,
        routeName: vehicleDetailsRoute,
        arguments: vic,
      );
    });
  }

  BlocBuilder _partsBloc(String partNo, BuildContext context) {
    context.read<HunterPartsByPartNoBloc>().add(GetHunterPartsByPartNoEvent(partNo));

    return BlocBuilder<HunterPartsByPartNoBloc, HuntersState>(
      builder: (_, state) {
        if (state is HuntersLoading) {
          return _loadSpinner();
        }

        if (state is HuntersError) {
          return buildRefreshApp(context);
        }

        if (state is HuntersDone) {
          return _partsCard(state, partNo);
        }

        return const SizedBox();
      },
    );
  }

  ColumnBuilder _partsCard(HuntersDone state, String partNo) {
    List<HunterModel> hunterParts = state.hunter as List<HunterModel>;
    return ColumnBuilder(
      itemCount: hunterParts.length,
      itemBuilder: (context, int i) {
        HunterModel p = hunterParts[i];

        return buildListTile("${p.product} ${p.brand}", partNo, onTap: (){

          pageNavigator(
            context,
            routeName: partsByPartNoRoute,
            arguments: hunterParts,
          );
        });
      },
    );
  }

  DefaultTabController _buildBody() {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            isScrollable: true,
            tabs: ["VIN", "Part No.", "Manual"]
                .map((String e) => Tab(text: e))
                .toList(),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TabBarView(
                children: [
                  _buildListView(key: vinSearchHistoryKey, id: "vin"),
                  _buildListView(key: partNoSearchHistoryKey, id: "part"),
                  _buildListView(key: manualSearchHistoryKey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _loadSpinner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: showCircularProgress(strokeWidth: 2, width: 15, height: 15),
    );
  }
}
