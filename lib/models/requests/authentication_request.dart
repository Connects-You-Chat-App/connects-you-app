import 'package:connects_you/models/common/device_info.dart';

class AuthenticationRequest {
  final String token;
  final String fcmToken;
  final DeviceInfo deviceInfo;

  const AuthenticationRequest({
    required this.token,
    required this.fcmToken,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'fcmToken': fcmToken,
      'deviceInfo': {
        'deviceId': deviceInfo.deviceId,
        'deviceName': deviceInfo.deviceName,
        'deviceOS': deviceInfo.deviceOS,
      },
    };
  }
}