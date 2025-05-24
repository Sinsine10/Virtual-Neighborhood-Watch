import '../models/incident_model.dart';
import '../services/api_service.dart';

class IncidentRepository {
  final ApiService _apiService = ApiService();

  Future<List<Incident>> fetchIncidents() async {
    final List<Map<String, dynamic>> data = await _apiService.getIncidents();
    return data.map((json) => Incident.fromJson(json)).toList();
  }

  Future<void> addIncident(Incident incident) async {
    await _apiService.addIncident(incident.toJson());
  }
}
