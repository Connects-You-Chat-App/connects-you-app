import 'package:connects_you/constants/locale.dart';
import 'package:connects_you/controllers/inbox_controller.dart';
import 'package:connects_you/enums/room.dart';
import 'package:connects_you/widgets/common/avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Rooms extends GetView<InboxController> {
  const Rooms({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchRooms(true),
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: Obx(
        () => controller.rooms.isEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
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
                itemBuilder: (context, index) {
                  final room = controller.rooms[index];
                  return ListTile(
                    title: Text(room.name),
                    subtitle: Text(room.description ?? ''),
                    leading: Avatar(
                      photoUrl: room.logoUrl,
                      firstLetter: room.name.isEmpty ? "" : room.name[0],
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