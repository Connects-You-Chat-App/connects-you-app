class User {
  late String id;
  late String name;
  late String email;
  late String? photoUrl;
  late String publicKey;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.publicKey,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      publicKey: json['publicKey'] as String,
    );
  }
}