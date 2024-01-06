import 'package:connects_you/constants/hive_box_keys.dart';
import 'package:hive/hive.dart';

class SecureStorage {
  static LazyBox? _box;

  static Future<LazyBox> _init() async {
    return _box ??= Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
  }

  static Future write({required String key, required dynamic value}) async {
    final box = await _init();
    await box.put(key, value);
  }

  static Future read({required String key}) async {
    final box = await _init();
    return box.get(key);
  }

  static Future delete({required String key}) async {
    final box = await _init();
    await box.delete(key);
  }

  static Future deleteAll() async {
    final box = await _init();
    await box.clear();
  }

  static Future close() async {
    final box = await _init();
    await box.close();
  }

  static Future deleteBox() async {
    await Hive.deleteBoxFromDisk('common-box');
  }
}