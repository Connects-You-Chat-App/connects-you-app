class SharedKey {
  final String key;
  final String? forUserId;
  final String? forRoomId;

  const SharedKey({
    required this.key,
    this.forUserId,
    this.forRoomId,
  });

  factory SharedKey.fromJson(Map<String, dynamic> json) {
    return SharedKey(
      key: json['key'],
      forUserId: json['forUserId'],
      forRoomId: json['forRoomId'],
    );
  }
}