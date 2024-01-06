class CreateDuetRoomRequest {
  final String userId;
  final String encryptedSharedKey;

  CreateDuetRoomRequest({
    required this.userId,
    required this.encryptedSharedKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'encryptedSharedKey': encryptedSharedKey,
    };
  }
}