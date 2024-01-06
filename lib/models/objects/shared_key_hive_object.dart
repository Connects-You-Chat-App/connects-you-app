import 'package:connects_you/models/common/shared_key.dart';
import 'package:hive/hive.dart';

part 'shared_key_hive_object.g.dart';

@HiveType(typeId: 1)
class SharedKeyHiveObject extends HiveObject {
  @HiveField(0)
  final String key;
  @HiveField(1)
  final String? forUserId;
  @HiveField(2)
  final String? forRoomId;

  SharedKeyHiveObject({
    required this.key,
    this.forUserId,
    this.forRoomId,
  });

  static SharedKeyHiveObject fromSharedKey(SharedKey user) =>
      SharedKeyHiveObject(
        key: user.key,
        forUserId: user.forUserId,
        forRoomId: user.forRoomId,
      );

  SharedKey toSharedKey() => SharedKey(
        key: key,
        forUserId: forUserId,
        forRoomId: forRoomId,
      );
}