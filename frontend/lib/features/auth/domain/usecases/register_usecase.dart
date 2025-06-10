import '../../data/models/RegisterRequest.dart';
import '../../data/models/RegisterResponse.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<RegisterResponse> call(RegisterRequest request) {
    return repository.register(request);
  }
}
