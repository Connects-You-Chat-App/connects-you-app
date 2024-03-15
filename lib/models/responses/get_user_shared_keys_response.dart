class GetUserSharedKeysResponse {
  const GetUserSharedKeysResponse({
    required this.privateKey,
    required this.publicKey,
  });

  factory GetUserSharedKeysResponse.fromJson(final Map<String, dynamic> json) {
    return GetUserSharedKeysResponse(
        privateKey: json['privateKey'] as String,
        publicKey: json['publicKey'] as String);
  }

  final String privateKey;
  final String publicKey;
}