import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/RegisterRequest.dart';
import '../../data/models/RegisterResponse.dart';
import '../../domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  final User user; // Unified logged-in user

  AuthLoggedIn(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Future<User> Function(String email, String password) _login;
  final Future<RegisterResponse> Function(RegisterRequest request) _register;

  AuthNotifier({
    required Future<User> Function(String email, String password) login,
    required Future<RegisterResponse> Function(RegisterRequest request) register,
  })  : _login = login,
        _register = register,
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await _login(email, password);
      state = AuthLoggedIn(user);
    } catch (e) {
      state = AuthError("Login failed: ${e.toString()}");
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = AuthLoading();
    try {
      final response = await _register(request);
      if (response.success) {
        // Convert response to User object (you can adapt this part)
        final user = User(
          email: request.email,
          username: request.username,
          role: 'user',
          accessToken: '',
        );


        state = AuthLoggedIn(user);
      } else {
        state = AuthError(response.message);
      }
    } catch (e) {
      state = AuthError('An error occurred: $e');
    }
  }
}
