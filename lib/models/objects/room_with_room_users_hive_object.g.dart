// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_with_room_users_hive_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomWithRoomUsersHiveObjectAdapter
    extends TypeAdapter<RoomWithRoomUsersHiveObject> {
  @override
  final int typeId = 3;

  @override
  RoomWithRoomUsersHiveObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomWithRoomUsersHiveObject(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      roomUsers: (fields[7] as List).cast<UserHiveObject>(),
      description: fields[3] as String?,
      logoUrl: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RoomWithRoomUsersHiveObject obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.logoUrl)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.roomUsers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomWithRoomUsersHiveObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
