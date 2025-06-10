class User {

  final String? email;
  final String? username;
  final String role;
  final String accessToken;

  User({
    this.email,
    this.username,
    required this.role,
    required this.accessToken,
  });


  bool get isAdmin => role.toLowerCase() == 'admin';

}
