import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_databse_pem.dart';

class SearchHistoryDB extends AppLocalDatabase {
  _getRecentSearches(String key) => readData(key: key);

  Future<void> saveTo(String searchText, {String? key}) async {
    if (searchText.isEmpty) return; //Should not be null

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        _getRecentSearches(key ?? allSearchesKey)?.toSet() ?? {};

    // debugPrint(allSearches.toString());
    // Place it at first in the set
    allSearches = {searchText, ...allSearches};
    writeData(key: key ?? allSearchesKey, data: allSearches.toList());
  }

  List<String> getFrom({String searchText = '', String? key}) {
    List<String> allSearches = _getRecentSearches(key ?? allSearchesKey) ?? [];

    // debugPrint(allSearches.length.toString());

    return searchText.isEmpty
        ? allSearches
        : allSearches.where((search) => search.startsWith(searchText)).toList();
  }
}
