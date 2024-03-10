import 'package:isar/isar.dart';

import '../common/shared_key.dart';

part 'shared_key_collection.g.dart';

@Collection()
class SharedKeyCollection {
  SharedKeyCollection({
    required this.sharedKey,
    required this.createdAt,
    required this.updatedAt,
    this.id,
    this.forUserId,
    this.forRoomId,
  });

  Id? id;

  String sharedKey;
  String? forUserId;
  String? forRoomId;
  DateTime createdAt;
  DateTime updatedAt;

  static SharedKeyCollection fromSharedKey(final SharedKey key) =>
      SharedKeyCollection(
        sharedKey: key.key,
        forUserId: key.forUserId,
        forRoomId: key.forRoomId,
        createdAt: key.createdAt,
        updatedAt: key.updatedAt,
      );

  SharedKey toSharedKey() => SharedKey(
        key: sharedKey,
        forUserId: forUserId,
        forRoomId: forRoomId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  SharedKeyCollection copyWith({
    final String? key,
    final String? forUserId,
    final String? forRoomId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) =>
      SharedKeyCollection(
        sharedKey: key ?? sharedKey,
        forUserId: forUserId ?? this.forUserId,
        forRoomId: forRoomId ?? this.forRoomId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}