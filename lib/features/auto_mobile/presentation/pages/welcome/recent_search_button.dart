import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
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
            fontSize: 16,
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
        onPressed: () {
          KeyboardUtil.hide(context);
          Future.delayed(const Duration(seconds: 1));
          displaySearchHistory(context);
        },
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

      return historyData.isNotEmpty ? _VehicleBc(vin: historyData.first) : const Text(
        "Recent Search",
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      );
     /*else {
      List<String> historyData = getHistory(partNoSearchHistoryCacheKey);
      return historyData.isEmpty
          ? const Text(
              "Recent Search",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            )
          : _PartsBc(partNo: historyData.first);
    }*/
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

class _VehicleBc extends StatelessWidget {
  const _VehicleBc({required this.vin});

  final String vin;

  @override
  Widget build(BuildContext context) {
    return _vehicleBloc(context);
  }

  BlocBuilder _vehicleBloc(BuildContext context) {
    context.read<VehicleByVinBloc>().add(GetVehicleByVinEvent(vin));

    return BlocBuilder<VehicleByVinBloc, VehicleState>(
      builder: (_, state) {
        if (state is VehicleError) {
          return textRecent();
        }

        if (state is VehicleDone) {
          VehicleModel v = VehicleModel.fromEntity(state.vehicle);

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

        return textRecent();
      },
    );
  }

  Text textRecent() {
    return const Text(
        "Recent Search",
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
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
        if (state is HunterError) {
          return textRecent();
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

        return textRecent();
      },
    );
  }

  Text textRecent() {
    return const Text(
        "Recent Search",
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      );
  }
}*/
