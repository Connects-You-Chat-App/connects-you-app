import 'package:connects_you/constants/status_codes.dart';
import 'package:connects_you/extensions/map.dart';
import 'package:connects_you/models/base/notification.dart';
import 'package:connects_you/models/responses/main.dart';
import 'package:connects_you/service/server.dart';

class NotificationService {
  const NotificationService._();

  static NotificationService? _instance;

  factory NotificationService() {
    return _instance ??= const NotificationService._();
  }

  Future<Response<List<Notification>>> getNotifications() async {
    final response = await ServerApi().get(
      endpoint: Endpoints.ALL_NOTIFICATIONS,
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<Notification>>(
        code: response.statusCode,
        message: body.get('message', ''),
        response: body
            .get("notifications", [])
            .map<Notification>((key) => Notification.fromJson(key))
            .toList(),
      );
    }
    return Response<List<Notification>>(
      code: response.statusCode,
      message: body.get('message', ''),
      response: [],
    );
  }
}