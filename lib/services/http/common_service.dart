import 'package:http_wrapper/http.dart';

import '../../constants/status_codes.dart';
import '../../extensions/map.dart';
import '../../models/responses/main.dart';
import 'server.dart';

class CommonService {
  const CommonService._();

  static CommonService? _cachedInstance;

  factory CommonService() => _cachedInstance ??= const CommonService._();

  Future<Response<Map<String, dynamic>>> getUpdatedDataAfter(
      final DateTime date) async {
    final DecodedResponse response = await ServerApi().get(
      endpoint:
          '${Endpoints.UPDATED_DATA}/${date.toLocal().toIso8601String()}Z',
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<Map<String, dynamic>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: body,
      );
    }
    return Response<Map<String, dynamic>>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: <String, dynamic>{},
    );
  }
}