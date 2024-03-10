import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/locale.dart';
import '../../../../../controllers/rooms_controller.dart';
import '../../../../../enums/room.dart';
import '../../../../../models/common/rooms_with_room_users.dart';
import '../../../../common/avatar.dart';

class Rooms extends GetView<RoomsController> {
  const Rooms({super.key});

  @override
  Widget build(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchRooms(fromServer: true),
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: Obx(
        () => controller.rooms.isEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo.png',
                      ),
                      const Text(Locale.appName)
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemCount: controller.rooms.length,
                itemBuilder: (final BuildContext context, final int index) {
                  final RoomWithRoomUsers room = controller.rooms[index];
                  return ListTile(
                    onTap: () => controller.redirectToRoom(index),
                    title: Text(room.name),
                    subtitle: Text(room.description ?? ''),
                    leading: Avatar(
                      photoUrl: room.logoUrl,
                      firstLetter: room.name.isEmpty ? '' : room.name[0],
                      icon: room.type == RoomType.GROUP
                          ? const Icon(Icons.group)
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}