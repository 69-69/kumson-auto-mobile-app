import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/models/make.dart';
import 'package:automasters/features/auto_mobile/data/models/model.dart';
import 'package:automasters/features/auto_mobile/data/repositories/home_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_dropdown.dart';

void filterResults<T>(List<T> matches, String query) {
  matches.retainWhere(
      (s) => s.toString().toLowerCase().contains(query.toLowerCase()));
}

CustomDropdown buildMakesDropdown({
  TextEditingController? controller,
  required Function(dynamic) onChanged,
}) {
  return CustomDropdown<MakeModel>(
    controller: controller,
    value: controller?.text,
    hintText: 'Car Make',
    onChanged: onChanged,
    setter: (dynamic newValue) => debugPrint("make-2 $newValue"),
    asyncItems: (String query) async {
      final v =
          await _getData(query, "car_makes?page=0&size=300&sort=make,asc");
      List<MakeModel> matches = MakeModel.fromJsonList(v);

      filterResults<MakeModel>(matches, query);
      return matches;
    },
  );
}

CustomDropdown buildModelsDropdown(
  String makeRef, {
  TextEditingController? controller,
  required Function(dynamic) onChanged,
}) {
  return CustomDropdown<Model>(
    controller: controller,
    value: controller?.text,
    hintText: 'Car Model',
    onChanged: onChanged,
    setter: (dynamic newValue) => debugPrint("model-2 $newValue"),
    asyncItems: (String query) async {
      final v = await _getData(query,
          "car_models/make_ref/$makeRef?page=0&size=300&sort=model,desc");
      List<Model> matches = Model.fromJsonList(v);

      filterResults<Model>(matches, query);
      return matches;
    },
  );
}

Future _getData(String query, String endPoint) async {
  return HomeRepositoryImpl().getData(query, endPoint);
}
