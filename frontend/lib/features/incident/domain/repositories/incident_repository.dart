import '../entities/incident.dart';

abstract class IncidentRepository {
  Future<List<Incident>> getAllIncidents();


  Future<void> addIncident(Incident incident);
  Future<void> updateIncident(Incident incident);
  Future<void> deleteIncident(String id);
}
