import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' hide Options;
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> deleteAccount() async {
    final token = await _storage.read(key: 'access_token');
    await _dio.delete(
      'https://http://10.0.2.2:3000/users/me',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
