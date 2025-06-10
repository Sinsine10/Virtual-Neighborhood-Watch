import 'package:dio/dio.dart';
import '../../domain/entities/tip.dart';

class TipRemoteDataSource {
  final Dio _dio;

  TipRemoteDataSource(this._dio) {
    print('TipRemoteDataSource initialized with base URL: ${_dio.options.baseUrl}');
  }

  Future<Tip> createTip(Map<String, dynamic> tipData) async {
    try {
      print('Creating tip at ${_dio.options.baseUrl}/tips');
      final response = await _dio.post('/tips', data: tipData);
      print('Create response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Tip.fromJson(response.data);
      } else {
        throw Exception('Failed to create tip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating tip: $e');
      throw Exception('Error creating tip: $e');
    }
  }

  Future<List<Tip>> fetchTips() async {
    try {
      print('Fetching tips from ${_dio.options.baseUrl}/tips at ${DateTime.now()}');
      final response = await _dio.get('/tips');
      print('Fetch response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List).map((tip) => Tip.fromJson(tip)).toList();
        } else {
          throw Exception('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to fetch tips: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tips at ${DateTime.now()}: $e');
      throw Exception('Error fetching tips: $e');
    }
  }

  Future<void> updateTip(int id, String description) async {
    try {
      print('Updating tip at ${_dio.options.baseUrl}/tips/$id');
      final response = await _dio.put('/tips/$id', data: {'description': description});
      print('Update response: ${response.statusCode}, ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to update tip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating tip: $e');
      throw Exception('Error updating tip: $e');
    }
  }

  Future<void> deleteTip(int id) async {
    try {
      print('Deleting tip at ${_dio.options.baseUrl}/tips/$id');
      final response = await _dio.delete('/tips/$id');
      print('Delete response: ${response.statusCode}, ${response.data}');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete tip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting tip: $e');
      throw Exception('Error deleting tip: $e');
    }
  }

  Future<Tip> fetchTipById(int id) async {
    try {
      print('Fetching tip by ID at ${_dio.options.baseUrl}/tips/$id');
      final response = await _dio.get('/tips/$id');
      print('Fetch by ID response: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        return Tip.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch tip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tip by ID: $e');
      throw Exception('Error fetching tip by ID: $e');
    }
  }
}