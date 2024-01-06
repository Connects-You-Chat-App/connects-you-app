class OtherUserEncryptedSharedKey {
  final String userId;
  final String encryptedRoomSecretKey;

  OtherUserEncryptedSharedKey({
    required this.userId,
    required this.encryptedRoomSecretKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'encryptedRoomSecretKey': encryptedRoomSecretKey,
    };
  }
}

class CreateGroupRoomRequest {
  final String? name;
  final String? description;
  final String? logoUrl;
  final String selfEncryptedRoomSecretKey;
  final List<OtherUserEncryptedSharedKey> otherUsersEncryptedRoomSecretKeys;

  CreateGroupRoomRequest({
    this.name,
    this.description,
    this.logoUrl,
    required this.selfEncryptedRoomSecretKey,
    required this.otherUsersEncryptedRoomSecretKeys,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'selfEncryptedRoomSecretKey': selfEncryptedRoomSecretKey,
      'otherUsersEncryptedRoomSecretKeys':
          otherUsersEncryptedRoomSecretKeys.map((e) => e.toJson()).toList(),
    };
  }
}