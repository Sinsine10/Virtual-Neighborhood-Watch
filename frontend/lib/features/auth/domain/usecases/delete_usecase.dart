import '../repositories/user_repository.dart';

class DeleteAccountUseCase {
  final UserRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> execute() async {
    await repository.deleteAccount();
  }
}
