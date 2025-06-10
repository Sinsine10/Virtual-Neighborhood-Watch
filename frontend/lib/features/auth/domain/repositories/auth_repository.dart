import '../../data/models/LoginRequest.dart';
import '../../data/models/RegisterRequest.dart';
import '../../data/models/RegisterResponse.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(LoginRequest request);

  Future<RegisterResponse> register(RegisterRequest request);



}




