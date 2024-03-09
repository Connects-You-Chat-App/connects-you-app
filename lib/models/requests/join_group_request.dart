class JoinGroupRequest {
  JoinGroupRequest({
    required this.invitationId,
    required this.selfEncryptedRoomSecretKey,
  });

  final String invitationId;
  final String selfEncryptedRoomSecretKey;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'invitationId': invitationId,
      'selfEncryptedRoomSecretKey': selfEncryptedRoomSecretKey,
    };
  }
}