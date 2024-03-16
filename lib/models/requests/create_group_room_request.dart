class OtherUserEncryptedSharedKey {
  OtherUserEncryptedSharedKey({
    required this.userId,
    required this.encryptedRoomSecretKey,
  });

  final String userId;
  final String encryptedRoomSecretKey;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'encryptedRoomSecretKey': encryptedRoomSecretKey,
    };
  }
}

class CreateGroupRoomRequest {
  CreateGroupRoomRequest({
    required this.selfEncryptedRoomSecretKey,
    required this.otherUsersEncryptedRoomSecretKeys,
    this.name,
    this.description,
    this.logoUrl,
  });

  final String? name;
  final String? description;
  final String? logoUrl;
  final String selfEncryptedRoomSecretKey;
  final List<OtherUserEncryptedSharedKey> otherUsersEncryptedRoomSecretKeys;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'selfEncryptedRoomSecretKey': selfEncryptedRoomSecretKey,
      'otherUsersEncryptedRoomSecretKeys': otherUsersEncryptedRoomSecretKeys
          .map((final OtherUserEncryptedSharedKey e) => e.toJson())
          .toList(),
    };
  }
}