class GetUserSharedKeysResponse {
  final String privateKey;
  final String publicKey;

  const GetUserSharedKeysResponse({
    required this.privateKey,
    required this.publicKey,
  });

  factory GetUserSharedKeysResponse.fromJson(Map<String, dynamic> json) {
    return GetUserSharedKeysResponse(
      privateKey: json['privateKey'],
      publicKey: json['publicKey'],
    );
  }
}