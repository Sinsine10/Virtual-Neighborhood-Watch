import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/LoginRequest.dart';
import '../models/RegisterRequest.dart';
import '../models/RegisterResponse.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(LoginRequest request) async {
    final response = await remoteDataSource.login(request);
    return User(accessToken: response.accessToken, role: response.role);
  }


  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    return remoteDataSource.register(request);
  }


}
