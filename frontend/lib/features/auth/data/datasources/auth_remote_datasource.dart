import 'package:dio/dio.dart';
import '../models/LoginRequest.dart';
import '../models/LoginResponse.dart';
import '../models/RegisterRequest.dart';
import '../models/RegisterResponse.dart';


class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await dio.post(
      'http://10.0.2.2:3000/auth/login',
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data);
  }


  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await dio.post('/auth/register', data: request.toJson());

    print('Register API raw response: ${response.data}'); // 👈 Debug this

    return RegisterResponse.fromJson(response.data);
  }



}
