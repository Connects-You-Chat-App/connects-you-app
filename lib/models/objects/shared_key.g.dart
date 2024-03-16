// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_key.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class SharedKeyModel extends _SharedKeyModel
    with RealmEntity, RealmObjectBase, RealmObject {
  SharedKeyModel(
    String key,
    DateTime createdAt,
    DateTime updatedAt, {
    String? forUserId,
    String? forRoomId,
  }) {
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'forUserId', forUserId);
    RealmObjectBase.set(this, 'forRoomId', forRoomId);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  SharedKeyModel._();

  @override
  String get key => RealmObjectBase.get<String>(this, 'key') as String;

  @override
  set key(String value) => RealmObjectBase.set(this, 'key', value);

  @override
  String? get forUserId =>
      RealmObjectBase.get<String>(this, 'forUserId') as String?;

  @override
  set forUserId(String? value) => RealmObjectBase.set(this, 'forUserId', value);

  @override
  String? get forRoomId =>
      RealmObjectBase.get<String>(this, 'forRoomId') as String?;

  @override
  set forRoomId(String? value) => RealmObjectBase.set(this, 'forRoomId', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;

  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime;

  @override
  set updatedAt(DateTime value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<SharedKeyModel>> get changes =>
      RealmObjectBase.getChanges<SharedKeyModel>(this);

  @override
  SharedKeyModel freeze() => RealmObjectBase.freezeObject<SharedKeyModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SharedKeyModel._);
    return const SchemaObject(
        ObjectType.realmObject, SharedKeyModel, 'SharedKeyModel', [
      SchemaProperty('key', RealmPropertyType.string),
      SchemaProperty('forUserId', RealmPropertyType.string,
          optional: true, indexType: RealmIndexType.fullText),
      SchemaProperty('forRoomId', RealmPropertyType.string,
          optional: true, indexType: RealmIndexType.fullText),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp),
    ]);
  }

  // factory SharedKeyModel.fromSharedKey(final SharedKey key) => SharedKeyModel(
  //       key.key,
  //       key.createdAt,
  //       key.updatedAt,
  //       forUserId: key.forUserId,
  //       forRoomId: key.forRoomId,
  //     );

  factory SharedKeyModel.fromJson(final Map<String, dynamic> json) =>
      SharedKeyModel(
        json['key'] as String,
        DateTime.parse(json['createdAt'] as String),
        DateTime.parse(json['updatedAt'] as String),
        forUserId: json['forUserId'] as String?,
        forRoomId: json['forRoomId'] as String?,
      );
//
// SharedKey toSharedKey() => SharedKey(
//       key: sharedKey,
//       forUserId: forUserId,
//       forRoomId: forRoomId,
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//     );
}