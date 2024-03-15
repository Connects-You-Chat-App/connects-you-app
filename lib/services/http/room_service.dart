import 'dart:convert';

import 'package:http_wrapper/http.dart';

import '../../constants/status_codes.dart';
import '../../extensions/map.dart';
import '../../models/objects/room_with_room_users_and_messages.dart';
import '../../models/requests/create_duet_room_request.dart';
import '../../models/requests/create_group_room_request.dart';
import '../../models/requests/join_group_request.dart';
import '../../models/responses/main.dart';
import 'server.dart';

class RoomService {
  const RoomService._();

  static late final RoomService _cachedInstance;

  factory RoomService() => _cachedInstance ??= const RoomService._();

  Future<Response<RoomWithRoomUsersAndMessagesModel?>> createDuetRoom(
      final CreateDuetRoomRequest createDuetRoomRequest) async {
    final DecodedResponse response = await ServerApi().post(
      endpoint: Endpoints.CREATE_DUET_ROOM,
      body: jsonEncode(createDuetRoomRequest.toJson()),
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<RoomWithRoomUsersAndMessagesModel>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: RoomWithRoomUsersAndMessagesModel.fromJson(
            body.get('room', <String, dynamic>{}) as Map<String, dynamic>),
      );
    }
    return Response<RoomWithRoomUsersAndMessagesModel?>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: null,
    );
  }

  Future<Response<RoomWithRoomUsersAndMessagesModel?>> createGroupRoom(
      final CreateGroupRoomRequest createGroupRoomRequest) async {
    final DecodedResponse response = await ServerApi().post(
      endpoint: Endpoints.CREATE_GROUP_ROOM,
      body: jsonEncode(createGroupRoomRequest.toJson()),
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<RoomWithRoomUsersAndMessagesModel>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: RoomWithRoomUsersAndMessagesModel.fromJson(
            body.get('room', <String, dynamic>{}) as Map<String, dynamic>),
      );
    }
    return Response<RoomWithRoomUsersAndMessagesModel?>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: null,
    );
  }

  Future<Response<List<RoomWithRoomUsersAndMessagesModel>>> fetchRooms() async {
    final DecodedResponse response = await ServerApi().get(
      endpoint: Endpoints.FETCH_ROOMS,
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<RoomWithRoomUsersAndMessagesModel>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: (body['rooms'] as List<dynamic>)
            .map((final dynamic e) =>
                RoomWithRoomUsersAndMessagesModel.fromJson(
                    e as Map<String, dynamic>))
            .toList(growable: true),
      );
    } else {
      return Response<List<RoomWithRoomUsersAndMessagesModel>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: <RoomWithRoomUsersAndMessagesModel>[],
      );
    }
  }

  Future<Response<void>> joinGroup(
      final JoinGroupRequest joinGroupRequest) async {
    final DecodedResponse response = await ServerApi().post(
      endpoint: Endpoints.JOIN_GROUP,
      body: jsonEncode(joinGroupRequest.toJson()),
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<void>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: null,
      );
    } else {
      return Response<void>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: null,
      );
    }
  }
}