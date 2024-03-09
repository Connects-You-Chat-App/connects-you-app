// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_key_hive_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedKeyHiveObjectAdapter extends TypeAdapter<SharedKeyHiveObject> {
  @override
  final int typeId = 4;

  @override
  SharedKeyHiveObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedKeyHiveObject(
      sharedKey: fields[0] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      forUserId: fields[1] as String?,
      forRoomId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SharedKeyHiveObject obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.sharedKey)
      ..writeByte(1)
      ..write(obj.forUserId)
      ..writeByte(2)
      ..write(obj.forRoomId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedKeyHiveObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
