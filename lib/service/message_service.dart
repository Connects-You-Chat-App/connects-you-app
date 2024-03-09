import 'dart:convert';

import 'package:http_wrapper/http.dart';

import '../constants/status_codes.dart';
import '../extensions/map.dart';
import '../models/base/message.dart';
import '../models/requests/send_message_request.dart';
import '../models/responses/main.dart';
import 'server.dart';

class MessageService {
  factory MessageService() {
    return _cachedInstance ??= const MessageService._();
  }

  const MessageService._();

  static MessageService? _cachedInstance;

  Future<Response<bool>> sendMessage(
      final SendMessageRequest sendMessageRequest) async {
    final DecodedResponse response = await ServerApi().post(
      endpoint: Endpoints.SEND_MESSAGE,
      body: json.encode(sendMessageRequest.toJson()),
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      if (body.containsKey('message')) {
        return Response<bool>(
            code: response.statusCode,
            message: body.get('message', '') as String? ?? '',
            response: true);
      }
    }
    return Response<bool>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: false,
    );
  }

  Future<Response<List<Message>>> fetchAllMessages(final String roomId) async {
    final DecodedResponse response = await ServerApi().get(
      endpoint: '${Endpoints.GET_ROOM_MESSAGES}/$roomId',
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      if (body.containsKey('message')) {
        return Response<List<Message>>(
          code: response.statusCode,
          message: body.get('message', '') as String? ?? '',
          response: (body['messages'] as List<dynamic>).map((final dynamic e) {
            return Message.fromJson(e as Map<String, dynamic>);
          }).toList(),
        );
      }
    }
    return Response<List<Message>>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: <Message>[],
    );
  }
}