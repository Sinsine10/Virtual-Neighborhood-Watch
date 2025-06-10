// core/network/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: 'http://10.0.2.2:3000/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

// Similarly: get, put, delete...
}
