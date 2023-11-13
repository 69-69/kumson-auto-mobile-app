import 'package:hive_flutter/adapters.dart';

const _boxName = "app_db_data";

class AppLocalDatabase {

  static Future<void> initFlutterHive() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  _hibBoxName({String? dbName}) => Hive.box(dbName ?? _boxName);

  Future<void> writeData({required String key, dynamic data}) async {
    await _hibBoxName().put(key, data);
  }

  Future<void> writeDataAt({required int index, dynamic data}) async {
    await Hive.box(_boxName).putAt(index, data);
  }

  dynamic readData({required String key, dynamic defaultValue}) {
    return _hibBoxName().get(key, defaultValue: defaultValue);
  }

  dynamic readDataAt({required int index}) => _hibBoxName().getAt(index);

  Future<void> delete({required String key}) async => await _hibBoxName().delete(key);

  Future<void> deleteFromDisk() async => await _hibBoxName().deleteFromDisk();

}
