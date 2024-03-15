// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class CurrentUserModel extends _CurrentUserModel
    with RealmEntity, RealmObjectBase, RealmObject {
  CurrentUserModel(
    String id,
    String name,
    String email,
    String publicKey,
    String privateKey,
    String token,
    String userKey, {
    String? description,
    String? photoUrl,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'photoUrl', photoUrl);
    RealmObjectBase.set(this, 'publicKey', publicKey);
    RealmObjectBase.set(this, 'privateKey', privateKey);
    RealmObjectBase.set(this, 'token', token);
    RealmObjectBase.set(this, 'userKey', userKey);
  }

  CurrentUserModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;

  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;

  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;

  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;

  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get photoUrl =>
      RealmObjectBase.get<String>(this, 'photoUrl') as String?;

  @override
  set photoUrl(String? value) => RealmObjectBase.set(this, 'photoUrl', value);

  @override
  String get publicKey =>
      RealmObjectBase.get<String>(this, 'publicKey') as String;

  @override
  set publicKey(String value) => RealmObjectBase.set(this, 'publicKey', value);

  @override
  String get privateKey =>
      RealmObjectBase.get<String>(this, 'privateKey') as String;

  @override
  set privateKey(String value) =>
      RealmObjectBase.set(this, 'privateKey', value);

  @override
  String get token => RealmObjectBase.get<String>(this, 'token') as String;

  @override
  set token(String value) => RealmObjectBase.set(this, 'token', value);

  @override
  String get userKey => RealmObjectBase.get<String>(this, 'userKey') as String;

  @override
  set userKey(String value) => RealmObjectBase.set(this, 'userKey', value);

  @override
  Stream<RealmObjectChanges<CurrentUserModel>> get changes =>
      RealmObjectBase.getChanges<CurrentUserModel>(this);

  @override
  CurrentUserModel freeze() =>
      RealmObjectBase.freezeObject<CurrentUserModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CurrentUserModel._);
    return const SchemaObject(
        ObjectType.realmObject, CurrentUserModel, 'CurrentUserModel', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('photoUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('publicKey', RealmPropertyType.string),
      SchemaProperty('privateKey', RealmPropertyType.string),
      SchemaProperty('token', RealmPropertyType.string),
      SchemaProperty('userKey', RealmPropertyType.string),
    ]);
  }

// factory CurrentUserModel.fromCurrentUser(final CurrentUser user) =>
//     CurrentUserModel(
//       user.id,
//       user.name,
//       user.email,
//       user.publicKey,
//       user.privateKey,
//       user.token,
//       user.userKey,
//       photoUrl: user.photoUrl,
//       description: user.description,
//     );
//
// CurrentUser toCurrentUser() => CurrentUser(
//     id: id,
//     name: name,
//     email: email,
//     photoUrl: photoUrl,
//     publicKey: publicKey,
//     privateKey: privateKey,
//     token: token,
//     userKey: userKey,
//     description: description);
}