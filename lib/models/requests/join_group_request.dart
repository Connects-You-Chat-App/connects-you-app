class JoinGroupRequest {
  final String invitationId;
  final String selfEncryptedRoomSecretKey;

  JoinGroupRequest({
    required this.invitationId,
    required this.selfEncryptedRoomSecretKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'invitationId': invitationId,
      'selfEncryptedRoomSecretKey': selfEncryptedRoomSecretKey,
    };
  }
}