import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';

class SecureStorage {
  static LazyBox? _box;

  static Future<LazyBox> _init() async {
    return _box ??= Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
  }

  static Future write({required final String key, required final dynamic value}) async {
    final LazyBox box = await _init();
    await box.put(key, value);
  }

  static Future read({required final String key}) async {
    final LazyBox box = await _init();
    return box.get(key);
  }

  static Future delete({required final String key}) async {
    final LazyBox box = await _init();
    await box.delete(key);
  }

  static Future deleteAll() async {
    final LazyBox box = await _init();
    await box.clear();
  }

  static Future close() async {
    final LazyBox box = await _init();
    await box.close();
  }

  static Future deleteBox() async {
    await Hive.deleteBoxFromDisk('common-box');
  }
}