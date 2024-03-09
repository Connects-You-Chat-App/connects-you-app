// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_hive_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageUserHiveObjectAdapter extends TypeAdapter<MessageUserHiveObject> {
  @override
  final int typeId = 1;

  @override
  MessageUserHiveObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageUserHiveObject(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      photoUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageUserHiveObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.photoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageUserHiveObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageHiveObjectAdapter extends TypeAdapter<MessageHiveObject> {
  @override
  final int typeId = 2;

  @override
  MessageHiveObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageHiveObject(
      id: fields[0] as String,
      roomId: fields[1] as String,
      senderUser: fields[2] as MessageUserHiveObject,
      message: fields[3] as String,
      type: fields[4] as String,
      isDeleted: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      belongsToMessage: fields[8] as MessageHiveObject?,
      status: fields[9] as String,
      forwardedFromRoomId: fields[10] as String?,
      editedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageHiveObject obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roomId)
      ..writeByte(2)
      ..write(obj.senderUser)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isDeleted)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.belongsToMessage)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.forwardedFromRoomId)
      ..writeByte(11)
      ..write(obj.editedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageHiveObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
