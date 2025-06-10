import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/delete_usecase.dart';


// Provide the repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

// Provide the use case
final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return DeleteAccountUseCase(repo);
});

// Trigger the delete operation
final deleteAccountProvider = FutureProvider<void>((ref) async {
  final useCase = ref.watch(deleteAccountUseCaseProvider);
  await useCase.execute();
});
