import 'package:flutter/material.dart';

import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';

class ProductStatusService extends AppLocalDatabase with ChangeNotifier {

  _getProductAge(String key) => readData(key: key);

  saveStatus(bool i, {String? key}) async {
    String s = i ? "new" : "used";
    await writeData(key: key ?? partOldOrNewKey, data: s);
    // notifyListeners();
  }

  getStatus() => _getProductAge(partOldOrNewKey) ?? "";
}
