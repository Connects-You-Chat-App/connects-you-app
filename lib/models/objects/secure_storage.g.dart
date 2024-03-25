// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class SecureStorageModel extends _SecureStorageModel
    with RealmEntity, RealmObjectBase, RealmObject {
  SecureStorageModel(
    String id, {
    Map<String, String> value = const {},
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set<RealmMap<String>>(
        this, 'value', RealmMap<String>(value));
  }

  SecureStorageModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  RealmMap<String> get value =>
      RealmObjectBase.get<String>(this, 'value') as RealmMap<String>;
  @override
  set value(covariant RealmMap<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<SecureStorageModel>> get changes =>
      RealmObjectBase.getChanges<SecureStorageModel>(this);

  @override
  SecureStorageModel freeze() =>
      RealmObjectBase.freezeObject<SecureStorageModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SecureStorageModel._);
    return const SchemaObject(
        ObjectType.realmObject, SecureStorageModel, 'SecureStorageModel', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('value', RealmPropertyType.string,
          collectionType: RealmCollectionType.map),
    ]);
  }
}
