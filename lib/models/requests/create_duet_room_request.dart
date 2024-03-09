class CreateDuetRoomRequest {
  CreateDuetRoomRequest({
    required this.userId,
    required this.encryptedSharedKey,
  });

  final String userId;
  final String encryptedSharedKey;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'encryptedSharedKey': encryptedSharedKey,
    };
  }
}