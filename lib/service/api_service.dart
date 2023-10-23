import 'dart:convert';

import 'package:automasters/models/hunter.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/models/vendor.dart';
import 'package:http/http.dart' as http;
import '../models/make.dart';
import '../models/model.dart';
import '../models/vehicle.dart';
import 'base_api.dart';

class APIService extends BaseAPI {
  // BKR5ES
  // 19unc1b14hy000003 - 19unc1b04hy000002
  // 3CZRU6H35NM701659 - JTEBB71J8LB015918
  // await Future.delayed(const Duration(seconds: 1));

  /// Get Vehicle by VIN[getVehicleByVin]
  Future<bool> isAPIOnline() async {
    var response = await http.get(Uri.parse(url("/api/v1/auth")));
    return response.statusCode == 200 ? true : false;
  }

  /// Get Vehicle by VIN[getVehicleByVin]
  Future<VehicleModel> getVehicleByVin(String vin) async {
    var response = await http.get(
      Uri.parse(url("${apiEndpointsDev['vehicles']}/$vin")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // Map<String, dynamic> data = json.decode(response.body)['content'][0];

      return VehicleModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return VehicleModel().copy();
    }
  }

  /// Get Parts by VFAM[getPartsBy]
  Future<List<PartModel>> getPartsByVFAM(String vfam) async {
    var response = await http.get(
      Uri.parse(
          url("${apiEndpointsDev['parts']}/$vfam${pagination(sort: "part")}")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonList = json.decode(response.body)['content'];
      return jsonList.map((job) => PartModel.fromJson(job)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
      // throw Exception('Failed to load album:');
    }
  }

  /// Get Parts by HunterNo[getPartsByHunterNo]
  Future<PartModel> getPartsByHunterNo(String hunterNo) async {
    var response = await http.get(
      Uri.parse(url("${apiEndpointsDev['parts']}/hunter/$hunterNo")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PartModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return PartModel().copy();
      // throw Exception('Failed to load album:');
    }
  }

  /// Get Part-Hunter by hunter or personnel[getHunterPartsBy]
  Future<List<HunterModel>> getHunterPartsBy(
      {String hunterNo = "", String patNo = ""}) async {
    String endpoint = (hunterNo.isNotEmpty && patNo.isEmpty)
        ? "${apiEndpointsDev['hunter']}/$hunterNo"
        : "${apiEndpointsDev['hunter']}/part_no/$patNo";

    var response = await http.get(
      Uri.parse(url(endpoint)),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonList = json.decode(response.body)['content'];
      return jsonList.map((job) => HunterModel.fromJson(job)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
      // throw Exception('Failed to load album:');
    }
  }

  /// Get Vehicle Make[getMake]
  Future<List<MakeModel>> getMake() async {
    var response = await http.get(
      Uri.parse(url("${apiEndpointsDev['make']}${pagination(sort: "make")}")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonList = json.decode(response.body)['content'];
      return jsonList.map((job) => MakeModel.fromJson(job)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
      // throw Exception('Failed to load album:');
    }
  }

  /// Get Vehicle Model By Make Reference[getModel]
  Future<List<Model>> getModel(String makeRef) async {
    var response = await http.get(
      // ${pagination(100, "make")}
      Uri.parse(url(
          "${apiEndpointsDev['model']}/make_ref/$makeRef${pagination(sort: "model")}")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonList = json.decode(response.body)['content'];
      return jsonList.map((job) => Model.fromJson(job)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
      // throw Exception('Failed to load album:');
    }
  }

  /// Get Vendors Parts By brand & PartNo Reference[getVendorParts]
  Future<List<VendorModel>> getVendorParts(String brand, String partNo) async {
    var response = await http.get(
      Uri.parse(url(
          "${apiEndpointsDev['vendor']}/lowest_price/$brand/$partNo${pagination(sort: "currentPrice")}")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonList = json.decode(response.body)['content'];
      return jsonList.map((job) => VendorModel.fromJson(job)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
      // throw Exception('Failed to load album:');
    }
  }

  /// Get Car Part Years By Make & Model[getCarYears]
  Future<List<dynamic>> getCarYears(String make, String model) async {
    var response = await http.get(
      Uri.parse(url("${apiEndpointsDev['parts']}/year_range/$make/$model")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonList = json.decode(response.body);
      return jsonList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
      // throw Exception('Failed to load album:');
    }
  }

  /// Get Parts by Make & Model[getPartsByVMakeModel]
  Future<List<PartModel>> getPartsByVMakeModel(
      String make, String model) async {
    var response = await http.get(
      Uri.parse(url(
          "${apiEndpointsDev['parts']}/$make/$model${pagination(sort: "part")}")),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonList = json.decode(response.body)['content'];
      return jsonList.map((job) => PartModel.fromJson(job)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
      // throw Exception('Failed to load album:');
    }
  }
}
