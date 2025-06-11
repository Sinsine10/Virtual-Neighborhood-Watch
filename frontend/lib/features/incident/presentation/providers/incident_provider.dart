import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/incident.dart';
import '../../domain/usecases/get_incidents.dart';
import '../../../incident/data/repositories/incident_repository_impl.dart';
import '../../../incident/data/datasources/incident_remote_datasource.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'));
});

final incidentRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return IncidentRepositoryImpl(IncidentRemoteDataSource(dio));
});

final incidentNotifierProvider =
StateNotifierProvider<IncidentNotifier, List<Incident>>((ref) {
  final repo = ref.watch(incidentRepositoryProvider);
  return IncidentNotifier(repo);
});

class IncidentNotifier extends StateNotifier<List<Incident>> {
  final IncidentRepositoryImpl repository;

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  IncidentNotifier(this.repository) : super([]) {
    loadIncidents();
  }

  Future<void> loadIncidents() async {
    print('Loading incidents...');
    try {
      final data = await repository.getAllIncidents();
      print('Loaded ${data.length} incidents');
      state = data;
    } catch (e) {
      print('Error loading incidents: $e');
    } finally {
      _hasLoaded = true;
    }
  }

  Future<void> addIncident(Incident newIncident) async {
    try {
      await repository.addIncident(newIncident);
      await loadIncidents(); // Refresh the list from backend
    } catch (e) {
      print('Error adding incident: $e');
    }
  }



  Future<void> updateIncident(Incident updated) async {
    await repository.updateIncident(updated); // API call
    await loadIncidents(); // Refresh state from backend
  }

  Future<void> deleteIncident(String id) async {
    await repository.deleteIncident(id); // API call
    await loadIncidents(); // Refresh state from backend
  }

}
