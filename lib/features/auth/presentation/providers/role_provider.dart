import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_state.dart';
import 'auth_provider.dart'; // <-- where authStateProvider is defined

final roleProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState is AuthLoggedIn) {
    return authState.user.role;
  }
  return null;
});
