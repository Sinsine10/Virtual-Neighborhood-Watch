// login_response.dart
class LoginResponse {
  final String accessToken;
  final String role;

  LoginResponse({
    required this.accessToken,
    required this.role,
  });

  // Create LoginResponse object from JSON map
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      role: json['role'],
    );
  }

  // Optional: Convert LoginResponse to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'role': role,
    };
  }
}
