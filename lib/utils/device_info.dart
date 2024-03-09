import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import '../models/common/device_info.dart';

Future<DeviceInfo> getDeviceInfo() async {
  String deviceId;
  String deviceName;
  if (Platform.isAndroid) {
    final AndroidDeviceInfo val = await DeviceInfoPlugin().androidInfo;
    deviceId = val.id;
    deviceName = '${val.manufacturer} ${val.model}';
  } else if (Platform.isIOS) {
    final IosDeviceInfo val = await DeviceInfoPlugin().iosInfo;
    deviceId = val.identifierForVendor ?? val.utsname.machine;
    deviceName = '${val.systemName} ${val.model}';
  } else {
    deviceId = 'unknown';
    deviceName = 'unknown';
  }

  return DeviceInfo(
    deviceId: deviceId,
    deviceName: deviceName,
    deviceOS: Platform.operatingSystem,
  );
}