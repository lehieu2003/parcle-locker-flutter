class User {
  final String username;
  final String accessToken;
  final String? email;
  final String? phoneNumber;
  final String? role;

  User({
    required this.username,
    required this.accessToken,
    this.email,
    this.phoneNumber,
    this.role,
  });
}
