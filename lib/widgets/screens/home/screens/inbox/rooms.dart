import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../../../../../constants/locale.dart';
import '../../../../../controllers/rooms_controller.dart';
import '../../../../../enums/room.dart';
import '../../../../../models/objects/room_with_room_users_and_messages.dart';
import '../../../../common/avatar.dart';

class Rooms extends GetView<RoomsController> {
  const Rooms({super.key});

  @override
  Widget build(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchRooms(),
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child:
          StreamBuilder<RealmResultsChanges<RoomWithRoomUsersAndMessagesModel>>(
        stream: controller.roomStream,
        builder: (
          final BuildContext context,
          final AsyncSnapshot<
                  RealmResultsChanges<RoomWithRoomUsersAndMessagesModel>>
              snapshot,
        ) {
          if (snapshot.hasData) {
            final List<RoomWithRoomUsersAndMessagesModel> rooms =
                snapshot.data!.results.toList();
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: rooms.length,
              itemBuilder: (final BuildContext context, final int index) {
                final RoomWithRoomUsersAndMessagesModel room = rooms[index];
                return ListTile(
                  onTap: () => controller.redirectToRoom(room),
                  title: Text(room.name),
                  subtitle: Text(room.description ?? ''),
                  leading: Avatar(
                    photoUrl: room.logoUrl,
                    firstLetter: room.name.isEmpty ? '' : room.name[0],
                    icon: room.type == RoomType.GROUP.name
                        ? const Icon(Icons.group)
                        : null,
                  ),
                );
              },
            );
          }
          return SingleChildScrollView(
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
          );
        },
      ),
    );
  }
}