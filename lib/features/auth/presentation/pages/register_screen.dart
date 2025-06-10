import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/RegisterRequest.dart';
import '../providers/auth_provider.dart';
import '../state/auth_state.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final List<String> _locations = ['6 Kilo', '5 Kilo', '4 Kilo', 'Sefere Selam', 'Lideta'];
  String? _selectedLocation;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.listen<AuthState>(authStateProvider, (prev, next) {
        if (next is AuthLoggedIn && next.user.role.toLowerCase() == 'user') {
          Navigator.pushReplacementNamed(context, '/user');
        } else if (next is AuthError) {
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
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 360,
            left: (MediaQuery.of(context).size.width / 2) - 50,
            child: Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 250,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'Name'),
                  const SizedBox(height: 16),
                  _buildTextField(emailController, 'Email'),
                  const SizedBox(height: 16),
                  _buildTextField(passwordController, 'Password', obscure: true),
                  const SizedBox(height: 16),

                  // Location Dropdown
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      items: _locations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        labelStyle: TextStyle(color: Color(0xFF361919)),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF361919),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                        final request = RegisterRequest(
                          email: emailController.text.trim(),
                          username: nameController.text.trim(),
                          password: passwordController.text.trim(),
                          location: _selectedLocation ?? '',
                        );

                       ref.read(authStateProvider.notifier).register(request);
                      },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Text("Register", style: TextStyle(color: Colors.white)),
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

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
