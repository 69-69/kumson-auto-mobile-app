import 'package:automasters/features/auto_mobile/data/models/product.dart';
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
    asyncItems: (String query) async {
      List v = await _getData(query, "car_makes?page=0&size=300&sort=make,asc");
      v.add({'make': 'Others: specify', 'makeRef': 'others'});
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
    asyncItems: (String query) async {
      final v = await _getData(query,
          "car_models/make_ref/$makeRef?page=0&size=300&sort=model,desc");
      v.add({'model': 'Others: specify', 'modelRef': 'others'});
      List<Model> matches = Model.fromJsonList(v);

      filterResults<Model>(matches, query);
      return matches;
    },
  );
}

CustomDropdown buildProductsDropdown({
  TextEditingController? controller,
  required Function(dynamic) onChanged,
}) {
  return CustomDropdown<Product>(
    controller: controller,
    value: controller?.text,
    hintText: 'Product Name',
    onChanged: onChanged,
    asyncItems: (String query) async {
      final v = await _getData(query,
          "car_products?page=0&size=300&sort=techName,desc");
      v.add({'techName': 'Others: specify', 'partCode': 'others'});
      List<Product> matches = Product.fromJsonList(v);

      filterResults<Product>(matches, query);
      return matches;
    },
  );
}

Future _getData(String query, String endPoint) async {
  return HomeRepositoryImpl().getData(query, endPoint);
}
