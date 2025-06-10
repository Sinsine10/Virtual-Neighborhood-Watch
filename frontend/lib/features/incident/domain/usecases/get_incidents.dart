import '../entities/incident.dart';

abstract class IncidentRepository {
  Future<List<Incident>> getAllIncidents();
}

