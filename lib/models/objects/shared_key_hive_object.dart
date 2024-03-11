import 'package:hive/hive.dart';

import '../common/shared_key.dart';

part 'shared_key_hive_object.g.dart';

@HiveType(typeId: 4)
class SharedKeyHiveObject extends HiveObject {
  SharedKeyHiveObject({
    required this.sharedKey,
    required this.createdAt,
    required this.updatedAt,
    this.forUserId,
    this.forRoomId,
  });

  @HiveField(0)
  String sharedKey;
  @HiveField(1)
  String? forUserId;
  @HiveField(2)
  String? forRoomId;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  DateTime updatedAt;

  static SharedKeyHiveObject fromSharedKey(final SharedKey key) =>
      SharedKeyHiveObject(
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

  SharedKeyHiveObject copyWith({
    final String? key,
    final String? forUserId,
    final String? forRoomId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) =>
      SharedKeyHiveObject(
        sharedKey: key ?? sharedKey,
        forUserId: forUserId ?? this.forUserId,
        forRoomId: forRoomId ?? this.forRoomId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}