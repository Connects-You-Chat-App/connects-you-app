import 'package:http_wrapper/http.dart';

import '../../constants/status_codes.dart';
import '../../extensions/map.dart';
import '../../models/base/notification.dart';
import '../../models/responses/main.dart';
import 'server.dart';

class NotificationService {
  const NotificationService._();

  static NotificationService? _cachedInstance;

  factory NotificationService() =>
      _cachedInstance ??= const NotificationService._();

  Future<Response<List<Notification>>> getNotifications() async {
    final DecodedResponse response = await ServerApi().get(
      endpoint: Endpoints.ALL_NOTIFICATIONS,
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<Notification>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: (body['notifications'] as List<dynamic>)
            .map((final dynamic notification) =>
                Notification.fromJson(notification as Map<String, dynamic>))
            .toList(),
      );
    }
    return Response<List<Notification>>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: <Notification>[],
    );
  }
}