import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/data/models/jwt.dart';
import 'package:automasters/features/auto_mobile/data/models/sms_config.dart';
import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';

class AppLocalService extends AppLocalDatabase with ChangeNotifier {
  _getData(String key) => readCache(key: key);

  appToken(JWTModel token) {
    writeCache(key: accessTokenCacheKey, data: token.accessToken);
    writeCache(key: accessExpiresCacheKey, data: token.expiresIn);
    writeCache(key: refreshTokenCacheKey, data: token.refreshToken);
    writeCache(key: refreshExpiresCacheKey, data: token.refreshExpiresIn);
  }

  SMSConfigModel get smsConfigCache{
    var smsConfig = readCache(key: smsConfigKey);
    if(smsConfig==null) SMSConfigModel.empty;

    Map<String, dynamic> smsConfigMap = createNewMap(smsConfig);
    if (smsConfigMap.entries.isEmpty) return SMSConfigModel.empty;

    return SMSConfigModel.fromJson(smsConfigMap);
  }

  // Save Search History
  Future<void> saveHistory(String searchText, {String? key}) async {
    if (searchText.isEmpty) return; //Should not be null

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches = _getData(key ?? allSearchesCacheKey)?.toSet() ?? {};

    // debugPrint(allSearches.toString());
    // Place it at first in the set
    allSearches = {searchText.toLowerCase(), ...allSearches};
    writeCache(key: key ?? allSearchesCacheKey, data: allSearches.toList());
  }

  // Get Search History
  List<String> getHistory({String searchText = '', String? key}) {
    List<String> allSearches = _getData(key ?? allSearchesCacheKey) ?? [];

    // debugPrint(allSearches.length.toString());

    return searchText.isEmpty
        ? allSearches
        : allSearches
            .where((search) => search.startsWith(searchText.toLowerCase()))
            .toList();
  }

  // Save product status
  saveProductStatus(bool i, {String? key}) async {
    String s = i ? "new" : "used";
    await writeCache(key: key ?? partOldOrNewCacheKey, data: s);
    // notifyListeners();
  }

  // Save VIN / PartNo
  Future saveReadOnly(String vin, {String? key}) async {
    if (vin.isEmpty) return; //Should not be null

    await writeCache(key: key ?? sendRequestVinCacheKey, data: vin);
    // notifyListeners();
  }

  // Get product status
  getProductStatus({String? key}) => _getData(key ?? partOldOrNewCacheKey) ?? "";
}
