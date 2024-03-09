class SharedKey {
  SharedKey({
    required this.key,
    required this.createdAt,
    required this.updatedAt,
    this.forUserId,
    this.forRoomId,
  });

  factory SharedKey.fromJson(final Map<String, dynamic> json) {
    return SharedKey(
      key: json['key'] as String,
      forUserId: json['forUserId'] as String?,
      forRoomId: json['forRoomId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String key;
  final String? forUserId;
  final String? forRoomId;
  final DateTime createdAt;
  DateTime updatedAt;
}