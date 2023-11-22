import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';

class SearchHistoryDB extends AppLocalDatabase with ChangeNotifier {
  _getData(String key) => readData(key: key);

  // Save Search History
  Future<void> saveHistory(String searchText, {String? key}) async {
    if (searchText.isEmpty) return; //Should not be null

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        _getData(key ?? allSearchesKey)?.toSet() ?? {};

    // debugPrint(allSearches.toString());
    // Place it at first in the set
    allSearches = {searchText.toLowerCase(), ...allSearches};
    writeData(key: key ?? allSearchesKey, data: allSearches.toList());
  }

  // Get Search History
  List<String> getHistory({String searchText = '', String? key}) {
    List<String> allSearches = _getData(key ?? allSearchesKey) ?? [];

    // debugPrint(allSearches.length.toString());

    return searchText.isEmpty
        ? allSearches
        : allSearches.where((search) => search.startsWith(searchText.toLowerCase())).toList();
  }

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
