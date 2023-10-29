import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveToRecentSearches(
    String searchText, {
    required String key,
  }) async {
    if (searchText.isEmpty) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches = pref.getStringList(key)?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList(key, allSearches.toList());
  }

  static Future<List<String>> getRecentSearchesLike({
    String searchText = '',
    required String key,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList(key) ?? [];

    return searchText.isEmpty ? allSearches : allSearches.where((search) => search.startsWith(searchText)).toList();
  }
}
