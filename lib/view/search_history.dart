import 'package:automasters/models/hunter.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/widgets/column_builder.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/vehicle.dart';
import '../service/api_service.dart';
import '../service/local_storage_service.dart';
import '../widgets/custom_bottom_sheet.dart';

List<String> _oldFilters = const [];

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
      initialChildSize: 0.5,
      // bgColor: const Color.fromRGBO(250, 249, 249, 0.3),
      padding: const EdgeInsets.symmetric(vertical: 20),
      headerWidget: const Text(
        "Search History",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      child: SizedBox(
        height: SizeConfig.screenHeight,
        child: tabsContent(),
      ),
    );
  }

  FutureBuilder buildFutureBuilder({required String key, String id = ""}) {
    final future = LocalStorageService.getRecentSearchesLike(key: key);

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data!;

        return ListView.separated(
          itemCount: _oldFilters.length,
          itemBuilder: (context, int i) => itemBuilder(_oldFilters[i], id),
          separatorBuilder: (context, index) => Divider(
            height: 1,
            indent: getProportionateScreenWidth(20.0),
            endIndent: getProportionateScreenWidth(40.0),
          ),
        );
      },
    );
  }

  itemBuilder(String key, String id) {
    return id == "vin"
        ? buildVehicleFuture(key)
        : id == "part"
            ? buildPartsFuture(key)
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
      subtitle: Text(txt2.toUpperCase()),
      onTap: onTap,
    );
  }

  FutureBuilder buildVehicleFuture(String vin) {
    VehicleModel veh = VehicleModel();

    return FutureBuilder(
      future: APIService().getVehicleByVin(vin),
      builder: (context, snapshot) {
        if (snapshot.hasData) veh = snapshot.data!;
        return snapshot.hasData
            ? _buildVehicleCard(veh)
            : const SizedBox.shrink();
      },
    );
  }

  _buildVehicleCard(VehicleModel v) => buildListTile("${v.year} ${v.make} ${v.model}", v.vin);

  FutureBuilder buildPartsFuture(String partNo) {
    return FutureBuilder(
      future: APIService().getHunterPartsBy(patNo: partNo),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? _buildPartsCard(snapshot.data)
            : const SizedBox.shrink();
      },
    );
  }

  ColumnBuilder _buildPartsCard(List<dynamic> part) => ColumnBuilder(
      itemCount: part.length,
      itemBuilder: (context, int i) {
        HunterModel p = part[i];

        return buildListTile("${p.product} ${p.brand}", p.partNo);
      },
    );

  DefaultTabController tabsContent() {
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
                  buildFutureBuilder(key: "vinSearchHistory", id: "vin"),
                  buildFutureBuilder(key: "partNoSearchHistory", id: "part"),
                  buildFutureBuilder(key: "manualSearchHistory"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
