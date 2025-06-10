import '../../domain/entities/incident.dart';
import '../../domain/repositories/incident_repository.dart';
import '../datasources/incident_remote_datasource.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource remoteDataSource;

  IncidentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Incident>> getAllIncidents() {
    return remoteDataSource.fetchIncidents(); // Returns List<IncidentModel>
  }


  Future<void> addIncident(Incident incident) {
    return remoteDataSource.addIncident(incident);
  }


  Future<void> updateIncident(Incident incident) {
    return remoteDataSource.updateIncident(incident);
  }

  Future<void> deleteIncident(String id) {
    return remoteDataSource.deleteIncident(id);
  }

}

