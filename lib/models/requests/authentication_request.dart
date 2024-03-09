import '../common/device_info.dart';

class AuthenticationRequest {
  const AuthenticationRequest({
    required this.token,
    required this.fcmToken,
    required this.deviceInfo,
  });

  final String token;
  final String fcmToken;
  final DeviceInfo deviceInfo;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'fcmToken': fcmToken,
      'deviceInfo': <String, String>{
        'deviceId': deviceInfo.deviceId,
        'deviceName': deviceInfo.deviceName,
        'deviceOS': deviceInfo.deviceOS,
      },
    };
  }
}