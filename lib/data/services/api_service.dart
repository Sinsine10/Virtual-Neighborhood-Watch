import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Dynamically set baseUrl for different platforms
  final String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000' // Android emulator special alias to host's localhost
      : 'http://localhost:3000'; // iOS simulator & Web

  Future<List<Map<String, dynamic>>> getIncidents() async {
    final response = await http.get(Uri.parse('$baseUrl/incidents'));

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load incidents: ${response.statusCode}');
    }
  }

  Future<void> addIncident(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/incidents'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add incident: ${response.statusCode}');
    }
  }

  Future<void> deleteIncident(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/incidents/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete incident: ${response.statusCode}');
    }
  }

  Future<void> updateIncident(int id, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/incidents/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update incident: ${response.statusCode}');
    }
  }
}
