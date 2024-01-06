class SaveUserKeysRequest {
  final String privateKey;
  final String publicKey;

  const SaveUserKeysRequest({
    required this.privateKey,
    required this.publicKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'privateKey': privateKey,
      'publicKey': publicKey,
    };
  }
}