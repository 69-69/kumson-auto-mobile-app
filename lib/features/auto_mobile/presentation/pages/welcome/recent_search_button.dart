import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/index.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../../bloc/vehicle/remote/index.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Search Parts',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(25),
          width: getProportionateScreenWidth(150),
          child: buildRecentSearchBtn(context),
        ),
      ],
    );
  }

  buildRecentSearchBtn(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(const EdgeInsets.all(1)),
          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
        ),
        label: getTitle(context),
        onPressed: () => displaySearchHistory(context),
        icon: const Icon(
          Icons.car_crash,
          color: Colors.white,
          semanticLabel: "Recent Search",
        ),
      ),
    );
  }

  getHistory(String k) => AppLocalService().getHistory(key: k).toList();

  getTitle(BuildContext context) {
    List<String> historyData = getHistory(vinSearchHistoryCacheKey);
    if (historyData.isNotEmpty) {
      return _vehicleBloc(historyData.last, context);
    } else {
      List<String> historyData = getHistory(partNoSearchHistoryCacheKey);
      return _partsBloc(historyData.last, context);
    }
  }

  BlocBuilder _vehicleBloc(String vin, BuildContext context) {
    context.read<VehicleByVinBloc>().add(GetVehicleByVinEvent(vin));

    return BlocBuilder<VehicleByVinBloc, VehicleState>(
      builder: (_, state) {
        if (state is VehicleError) {
          return const Text(
            "Recent Search",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          );
        }

        if (state is VehicleDone) {
          VehicleModel v = state.vehicle.cast<VehicleModel>();

          return Text(
            "${v.year} ${v.make} ${v.model}".capitalizeEach(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  BlocBuilder _partsBloc(String partNo, BuildContext context) {
    context
        .read<HunterPartsByPartNoBloc>()
        .add(GetHunterPartsByPartNoEvent(partNo));

    return BlocBuilder<HunterPartsByPartNoBloc, HunterState>(
      builder: (_, state) {
        if (state is HunterError) {
          return const Text(
            "Recent Search",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          );
        }

        if (state is HunterDone) {
          HunterModel h = state.hunter.cast<HunterModel>()[0];
          return Text(
            "${h.product} ${h.brand}".capitalizeEach(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  displaySearchHistory(BuildContext context) {
    KeyboardUtil.hide;

    return buildModal(
      context,
      const SearchHistory(),
      bgColor: Colors.transparent,
      barColor: const Color.fromRGBO(250, 249, 249, 0.3),
    );
  }
}
