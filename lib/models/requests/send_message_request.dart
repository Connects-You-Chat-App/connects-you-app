class SendMessageRequest {
  SendMessageRequest({
    required this.messageId,
    required this.roomId,
    required this.message,
    required this.type,
    this.belongsToMessageId,
    this.forwardedFromRoomId,
  });

  final String messageId;
  final String roomId;
  final String message;
  final String type;
  final String? belongsToMessageId;
  final String? forwardedFromRoomId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'messageId': messageId,
      'roomId': roomId,
      'message': message,
      'type': type,
      'belongsToMessageId': belongsToMessageId,
      'forwardedFromRoomId': forwardedFromRoomId,
    };
  }
}