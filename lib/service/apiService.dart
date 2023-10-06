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
  // 3CZRU6H35NM701659 - JTEBB71J8LB015918
  //await Future.delayed(const Duration(seconds: 1));

  /// Get Vehicle by VIN[getVehicleByVin]
  Future<VehicleModel> getVehicleByVin(String vin) async {
    var response = await http.get(
      Uri.parse(url("${apiEndpoints['vehicles']}/$vin")),
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

  /// Get Parts by VFAM[getPartsByVfam]
  Future<List<PartModel>> getPartsByVfam(String vfam) async {
    var response = await http.get(
      Uri.parse(url("${apiEndpoints['parts']}/$vfam${pagination(100, "id")}")),
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

  /// Get Part-Hunter by hunter or personnel[getHunterParts]
  Future<List<HunterModel>> getHunterParts(
      {String hunterNo = "", String patNo = ""}) async {

    String endpoint = (hunterNo.isNotEmpty && patNo.isEmpty)
        ? "${apiEndpoints['hunter']}/$hunterNo"
        : "${apiEndpoints['hunter']}/part_no/$patNo";

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
      Uri.parse(url("${apiEndpoints['make']}${pagination(100, "make")}")),
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
          "${apiEndpoints['model']}/make_ref/$makeRef${pagination(100, "id")}")),
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
          "${apiEndpoints['vendor']}/lowest_price/$brand/$partNo${pagination(100, "currentPrice")}")),
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
}
