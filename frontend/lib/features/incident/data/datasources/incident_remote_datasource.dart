import 'package:dio/dio.dart';
import '../../domain/entities/incident.dart';

class IncidentRemoteDataSource {
  final Dio dio;

  IncidentRemoteDataSource(this.dio);

  Future<List<Incident>> fetchIncidents() async {
    try {
      final response = await dio.get('/incidents');
      print('API Response: ${response.data}');
      final data = response.data as List;
      return data.map((json) => Incident.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching incidents: $e');
      return [];
    }
  }

  Future<void> addIncident(Incident incident) async {
    try {
      await dio.post(
        '/incidents',
        data: incident.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('Incident POST success');
    } catch (e) {
      print('Error posting incident: $e');
      rethrow;
    }
  }



  Future<void> updateIncident(Incident incident) async {
    await dio.put('/incidents/${incident.id}', data: incident.toJson());
  }

  Future<void> deleteIncident(String id) async {
    await dio.delete('/incidents/$id');
  }



}
