import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/LoginRequest.dart';
import '../providers/auth_provider.dart';
import '../state/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isListening = false;


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.listen<AuthState>(authStateProvider, (prev, next) {
        if (next is AuthLoggedIn) {
          print('AuthLoggedIn received');
          print('User role: ${next.user.role}');
          print('Access token: ${next.user.accessToken}');
          final role = next.user.role?.toLowerCase() ?? '';
          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (role == 'user') {
            Navigator.pushReplacementNamed(context, '/user');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed: Unknown role')),
            );
          }
        } else if (next is AuthError) {
          print('AuthError: ${next.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFCA7F7F),
      body: Stack(
        children: [
          // Bottom background image
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: const Offset(0, 110),
              child: Image.asset(
                'assets/login.png',
                width: 450,
                height: 450,
              ),
            ),
          ),
          // Logo image
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 270,
            left: (MediaQuery.of(context).size.width / 2) - 50,
            child: Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),
          ),
          // Title text
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 150,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: const Text(
              'Neighbourhood Watch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Form and button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextFormField(
                      key: const Key('emailField'),
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextFormField(
                      key: const Key('passwordField'),
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 120,
                    height: 48,
                    child: ElevatedButton(
                      key: const Key('loginButton'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF361919),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                        final request = LoginRequest(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        ref
                            .read(authStateProvider.notifier)
                            .login(request, context);
                      },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (state is AuthError)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
