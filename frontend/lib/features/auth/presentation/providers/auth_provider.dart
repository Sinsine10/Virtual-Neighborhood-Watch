import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../incident/presentation/pages/main_user_screen.dart';
import '../../../tip/presentation/pages/main_Admin_screen.dart';

import 'package:dio/dio.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/LoginRequest.dart';
import '../../data/models/RegisterRequest.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../state/auth_state.dart';

// Dio provider with baseUrl setup
final dioProvider = Provider<Dio>((ref) => Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000')));

// DataSource provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRemoteDataSource(dio);
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// UseCases providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RegisterUseCase(repository);
});

// Unified AuthNotifier provider with both login and register use cases injected
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.read(loginUseCaseProvider);
  final registerUseCase = ref.read(registerUseCaseProvider);
  return AuthNotifier(loginUseCase: loginUseCase, registerUseCase: registerUseCase);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(AuthInitial());

  Future<void> login(LoginRequest request, BuildContext context) async {
    state = AuthLoading();
    try {
      final user = await loginUseCase(request);
      state = AuthLoggedIn(user);

      // Navigate based on role
      if (user.role.toLowerCase() == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainAdminScreen(username: user.accessToken),
          ),
        );
      } else if (user.role.toLowerCase() == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainUserScreen(),
          ),
        );
      } else {
        state = AuthError("Unknown role: ${user.role}");
      }
    } catch (e) {
      state = AuthError("Login failed: ${e.toString()}");
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = AuthLoading();
    try {
      final response = await registerUseCase(request);
      if (response.success) {
        // Optionally, you might want to automatically log the user in or convert RegisterResponse to User
        state = AuthLoggedIn(User(
          email: request.email,
          username: request.username,
          role: 'user',
          accessToken: '',
        ));


      } else {
        state = AuthError(response.message);
      }
    } catch (e) {
      state = AuthError('Registration failed: $e');
    }
  }
}
