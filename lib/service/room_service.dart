import 'dart:convert';

import 'package:connects_you/constants/status_codes.dart';
import 'package:connects_you/extensions/map.dart';
import 'package:connects_you/models/common/rooms_with_room_users.dart';
import 'package:connects_you/models/requests/create_duet_room_request.dart';
import 'package:connects_you/models/requests/create_group_room_request.dart';
import 'package:connects_you/models/requests/join_group_request.dart';
import 'package:connects_you/models/responses/main.dart';
import 'package:connects_you/service/server.dart';

class RoomService {
  const RoomService._();

  static RoomService? _instance;

  factory RoomService() {
    return _instance ??= const RoomService._();
  }

  Future<Response<RoomWithRoomUsers?>> createDuetRoom(
      CreateDuetRoomRequest createDuetRoomRequest) async {
    final response = await ServerApi().post(
      endpoint: Endpoints.CREATE_DUET_ROOM,
      body: jsonEncode(createDuetRoomRequest.toJson()),
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response(
        code: response.statusCode,
        message: body.get('message', ''),
        response: RoomWithRoomUsers.fromJson(body.get('room', {})),
      );
    }
    return Response(
      code: response.statusCode,
      message: body.get('message', ''),
      response: null,
    );
  }

  Future<Response<RoomWithRoomUsers?>> createGroupRoom(
      CreateGroupRoomRequest createGroupRoomRequest) async {
    final response = await ServerApi().post(
      endpoint: Endpoints.CREATE_GROUP_ROOM,
      body: jsonEncode(createGroupRoomRequest.toJson()),
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response(
        code: response.statusCode,
        message: body.get('message', ''),
        response: RoomWithRoomUsers.fromJson(body.get('room', {})),
      );
    }
    return Response(
      code: response.statusCode,
      message: body.get('message', ''),
      response: null,
    );
  }

  Future<Response<List<RoomWithRoomUsers>>> fetchRooms() async {
    final response = await ServerApi().get(
      endpoint: Endpoints.FETCH_ROOMS,
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response(
        code: response.statusCode,
        message: body.get('message', ''),
        response: (body.get('rooms', []) as List)
            .map((e) => RoomWithRoomUsers.fromJson(e))
            .toList(),
      );
    } else {
      return Response(
        code: response.statusCode,
        message: body.get('message', ''),
        response: [],
      );
    }
  }

  Future joinGroup(JoinGroupRequest joinGroupRequest) async {
    final response = await ServerApi().post(
      endpoint: Endpoints.JOIN_GROUP,
      body: jsonEncode(joinGroupRequest.toJson()),
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response(
        code: response.statusCode,
        message: body.get('message', ''),
        response: null,
      );
    } else {
      return Response(
        code: response.statusCode,
        message: body.get('message', ''),
        response: null,
      );
    }
  }
}