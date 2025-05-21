import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/models/incident.dart';
import '../data/models/tip.dart';


class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Tip>> fetchTips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tips'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Tip.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tips: $e');
    }
  }

  Future<void> addTip(Tip tip) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tips'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tip.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add tip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding tip: $e');
    }
  }

  Future<void> updateTip(int id, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tips/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'description': description}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update tip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating tip: $e');
    }
  }

  Future<void> deleteTip(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tips/$id'));
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete tip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting tip: $e');
    }
  }

  Future<List<Incident>> fetchIncidents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/incidents'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Incident.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load incidents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching incidents: $e');
    }
  }
}