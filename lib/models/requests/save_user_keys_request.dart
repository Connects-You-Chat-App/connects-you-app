class SaveUserKeysRequest {
  const SaveUserKeysRequest({
    required this.privateKey,
    required this.publicKey,
  });

  final String privateKey;
  final String publicKey;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'privateKey': privateKey,
      'publicKey': publicKey,
    };
  }
}