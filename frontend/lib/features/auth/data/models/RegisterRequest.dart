class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String location;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'location': location,
    };
  }

  // Optional: Create RegisterRequest from JSON
  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'],
      username: json['username'],
      password: json['password'],
      location: json['location'],
    );
  }
}
