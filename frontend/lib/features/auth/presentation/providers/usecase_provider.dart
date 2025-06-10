import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neihborhoodwatch/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'dio_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepositoryImpl(dio as AuthRemoteDataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUseCase(repo);
});

// final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
//   final repo = ref.read(authRepositoryProvider);
//   return RegisterUseCase(repo);
// });
