import 'package:realm/realm.dart';

part 'shared_key.g.dart';

@RealmModel()
class _SharedKeyModel {
  late String key;
  @Indexed(RealmIndexType.fullText)
  late String? forUserId;
  @Indexed(RealmIndexType.fullText)
  late String? forRoomId;
  late DateTime createdAt;
  late DateTime updatedAt;
}