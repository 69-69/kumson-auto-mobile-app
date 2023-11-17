import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/search_history_service.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_state.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_state.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_state.dart';
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
      initialChildSize: 0.3,
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
    List<String> historyData = SearchHistoryDB().getFrom(key: key).toList();

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

  ListTile buildListTile(String txt, String txt2, {void Function()? onTap}) {
    return ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt.capitalizeEach(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.restore, size: 14, color: Colors.grey),
        ],
      ),
      subtitle: SelectionArea(child: Text(txt2.toUpperCase())),
      onTap: onTap,
    );
  }

  BlocBuilder vehicleBloc(String vin, BuildContext context) {
    context.read<VehicleByVinBloc>().add(GetVehicleByVinEvent(vin));

    return BlocBuilder<VehicleByVinBloc, VehiclesState>(
      builder: (_, state) {
        if (state is VehiclesLoading) {
          return _loadSpinner();
        }

        if (state is VehiclesError) {
          return buildRefreshApp(context);
        }

        if (state is VehicleByDone) {
          return _buildVehicleCard(state, vin);
        }

        return const SizedBox();
      },
    );
  }

  _buildVehicleCard(VehicleByDone state, String vin) {
    VehicleModel v = state.vehicle as VehicleModel;
    return buildListTile("${v.year} ${v.make} ${v.model}", vin);
  }

  BlocBuilder _partsBloc(String partNo, BuildContext context) {
    context.read<HunterPartsByPartNoBloc>().add(GetHunterPartsByPartNo(partNo));

    return BlocBuilder<HunterPartsByPartNoBloc, HuntersState>(
      builder: (_, state) {
        if (state is PartsLoading) {
          return _loadSpinner();
        }

        if (state is HuntersError) {
          return buildRefreshApp(context);
        }

        if (state is HuntersDone) {
          return _buildPartsCard(state, partNo);
        }

        return const SizedBox();
      },
    );
  }

  ColumnBuilder _buildPartsCard(HuntersDone state, String partNo) {
    List<HunterModel> part = state.hunters as List<HunterModel>;
    return ColumnBuilder(
      itemCount: part.length,
      itemBuilder: (context, int i) {
        HunterModel p = part[i];

        return buildListTile("${p.product} ${p.brand}", partNo);
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
