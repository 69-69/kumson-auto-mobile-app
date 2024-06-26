import 'package:automasters/core/util/get_distinct_by.dart';
import 'package:automasters/features/auto_mobile/data/models/parts.dart';
import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/models/product.dart';
import 'package:automasters/features/auto_mobile/data/models/make.dart';
import 'package:automasters/features/auto_mobile/data/models/model.dart';
import 'package:automasters/features/auto_mobile/data/repositories/search_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_dropdown.dart';

class ProductsDropdown {
  final SearchRepositoryImpl repo = SearchRepositoryImpl();

  final suffixIcon = const Icon(
    Icons.keyboard_arrow_down_rounded,
    color: Colors.black,
  );

  CustomDropdown buildMakesDropdown({
    bool? enabledTextField,
    TextEditingController? controller,
    required Function(dynamic) onChanged,
  }) {
    return CustomDropdown<MakeModel>(
      enabledTextField: enabledTextField,
      value: controller?.text,
      hintText: 'Car Make',
      onChanged: onChanged,
      suffixIcon: suffixIcon,
      asyncItems: (String search) async {
        List v = await SearchRepositoryImpl().getCarMake();
        v.add({'make': 'others: specify', 'makeRef': 'others'});
        List<MakeModel> matches = MakeModel.fromJsonList(v);

        // debugPrint(matches.toString());
        filterResults<MakeModel>(matches, search);
        return matches;
      },
    );
  }

  CustomDropdown buildModelsDropdown(
    String makeRef, {
    bool? enabledTextField,
    TextEditingController? controller,
    required Function(dynamic) onChanged,
  }) {
    return CustomDropdown<Model>(
      enabledTextField: enabledTextField,
      value: controller?.text,
      hintText: 'Car Model',
      onChanged: onChanged,
      suffixIcon: suffixIcon,
      asyncItems: (String search) async {
        List v = await SearchRepositoryImpl().getCarModel(makeRef);
        v.add({'model': 'others: specify', 'modelRef': 'others'});
        List<Model> matches = Model.fromJsonList(v);

        filterResults<Model>(matches, search);
        return matches;
      },
    );
  }

  buildYearsDropdown(
    String make,
    String model, {
    bool? enabledTextField,
    TextEditingController? controller,
    required Function(dynamic) onChanged,
  }) {
    return CustomDropdown<int>(
      enabledTextField: enabledTextField,
      value: controller?.text,
      hintText: 'Car Year',
      onChanged: onChanged,
      suffixIcon: suffixIcon,
      asyncItems: (String search) async {
        List<int> v = await SearchRepositoryImpl().getCarYears(make, model);
        debugPrint('Car Year $v');
        List<int> matches = v.cast<int>();

        filterResults<int>(matches, search);
        return matches;
      },
    );
  }

  buildEnginesDropdown(
    String make,
    String model, {
    bool? enabledTextField,
    TextEditingController? controller,
    required Function(dynamic) onChanged,
  }) {
    return CustomDropdown<PartModel>(
      enabledTextField: enabledTextField,
      value: controller?.text,
      hintText: 'Engine Type',
      onChanged: (val) async {
        List<dynamic> list = await _getEngineTypes(make, model);
        final filter =
            list.where((e) => e['engineType'] == val.toString()).toList();

        onChanged(filter);
      },
      suffixIcon: suffixIcon,
      asyncItems: (String search) async {
        List<dynamic> v = await _getEngineTypes(make, model);
        List res = v.getDistinctBy((x) => x['engineType']).toList();
        List<PartModel> matches = PartModel.fromJsonList(res);

        filterResults<PartModel>(matches, search);
        return matches;
      },
    );
  }

  Future<List<dynamic>> _getEngineTypes(String make, String model) async {
    List v = await SearchRepositoryImpl().getCarEngineType(make, model);
    return v;
  }

  CustomDropdown buildProductsDropdown({
    bool? enabledTextField,
    TextEditingController? controller,
    required Function(dynamic) onChanged,
  }) {
    return CustomDropdown<ProductModel>(
      enabledTextField: enabledTextField,
      value: controller?.text,
      hintText: 'Product Name',
      onChanged: onChanged,
      suffixIcon: suffixIcon,
      asyncItems: (String search) async {
        List v = await SearchRepositoryImpl().getCarProduct();
        List<ProductModel> matches = ProductModel.fromJsonList(v);

        filterResults<ProductModel>(matches, search);
        return matches;
      },
    );
  }

  filterResults<T>(List<T> matches, String query) {
    return matches.retainWhere(
        (s) => s.toString().toLowerCase().contains(query.toLowerCase()));
  }
}
