import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../../../../../constants/locale.dart';
import '../../../../../controllers/rooms_controller.dart';
import '../../../../../enums/room.dart';
import '../../../../../models/objects/room_with_room_users_and_messages.dart';
import '../../../../common/avatar.dart';

class Rooms extends StatelessWidget {
  Rooms({super.key}) {
    _controller = Get.put(RoomsController());
  }

  late final RoomsController _controller;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: RefreshIndicator(
        onRefresh: () => _controller.fetchRooms(),
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: StreamBuilder<
            RealmResultsChanges<RoomWithRoomUsersAndMessagesModel>>(
          stream: _controller.roomStream,
          builder: (
            final BuildContext context,
            final AsyncSnapshot<
                    RealmResultsChanges<RoomWithRoomUsersAndMessagesModel>>
                snapshot,
          ) {
            if (snapshot.hasData) {
              final List<RoomWithRoomUsersAndMessagesModel> rooms =
                  snapshot.data!.results.toList().reversed.toList();
              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (final BuildContext context, final int index) {
                  final RoomWithRoomUsersAndMessagesModel room = rooms[index];
                  return ListTile(
                    onTap: () => _controller.redirectToRoom(room),
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
      ),
    );
  }
}