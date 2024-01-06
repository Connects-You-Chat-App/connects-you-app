// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_hive_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentUserHiveObjectAdapter extends TypeAdapter<CurrentUserHiveObject> {
  @override
  final int typeId = 0;

  @override
  CurrentUserHiveObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUserHiveObject(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      photoUrl: fields[3] as String?,
      publicKey: fields[4] as String,
      privateKey: fields[5] as String,
      token: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUserHiveObject obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.publicKey)
      ..writeByte(5)
      ..write(obj.privateKey)
      ..writeByte(6)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserHiveObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}