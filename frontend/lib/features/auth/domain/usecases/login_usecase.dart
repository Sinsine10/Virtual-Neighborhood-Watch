import '../../data/models/LoginRequest.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(LoginRequest request) {
    return repository.login(request);
  }
}
