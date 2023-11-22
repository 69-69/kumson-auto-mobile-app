import 'package:flutter/material.dart';

import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';

class ProductStatusService extends AppLocalDatabase with ChangeNotifier {

  _getData(String key) => readData(key: key);

  // Save product status
  saveProductStatus(bool i, {String? key}) async {
    String s = i ? "new" : "used";
    await writeData(key: key ?? partOldOrNewKey, data: s);
    // notifyListeners();
  }

  // Save VIN / PartNo
  Future saveReadOnly(String vin, {String? key}) async {
    if (vin.isEmpty) return; //Should not be null

    await writeData(key: key ?? readOnlyVinKey, data: vin);
    // notifyListeners();
  }

  // Get product status
  getProductStatus({String? key}) => _getData(key ?? partOldOrNewKey) ?? "";
}
