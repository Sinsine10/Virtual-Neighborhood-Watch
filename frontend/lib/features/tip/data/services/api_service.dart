import 'package:dio/dio.dart';
import 'package:neihborhoodwatch/features/incident/data/models/incident_model.dart';
import '../../../../data/models/incident.dart';
import '../../../incident/data/datasources/incident_remote_datasource.dart';
import '../../domain/entities/tip.dart';
import '../datasources/tip_remote_datasource.dart';

class ApiService {
  final TipRemoteDataSource _dataSource;
  final IncidentRemoteDataSource _incidentDataSource;

  ApiService()
      : _dataSource = TipRemoteDataSource(Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:3000',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 5),
  ))),
        _incidentDataSource = IncidentRemoteDataSource(Dio(BaseOptions(
          baseUrl: 'http://10.0.2.2:3000',
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ))) {
    print('ApiService initialized with base URL: http://10.0.2.2:3000');
  }

  // --- Tips ---
  Future<List<Tip>> fetchTips() async {
    try {
      print('ApiService calling fetchTips');
      return await _dataSource.fetchTips();
    } catch (e) {
      print('ApiService fetchTips error: $e');
      throw Exception('Failed to fetch tips: $e');
    }
  }

  Future<void> addTip(Tip tip) async {
    try {
      print('ApiService calling addTip');
      await _dataSource.createTip(tip.toJson());
    } catch (e) {
      print('ApiService addTip error: $e');
      throw Exception('Failed to add tip: $e');
    }
  }

  Future<void> updateTip(int id, String description) async {
    try {
      print('ApiService calling updateTip for ID $id');
      await _dataSource.updateTip(id, description);
    } catch (e) {
      print('ApiService updateTip error: $e');
      throw Exception('Failed to update tip: $e');
    }
  }

  Future<void> deleteTip(int id) async {
    try {
      print('ApiService calling deleteTip for ID $id');
      await _dataSource.deleteTip(id);
    } catch (e) {
      print('ApiService deleteTip error: $e');
      throw Exception('Failed to delete tip: $e');
    }
  }

  Future<List<Incident>> fetchIncidents() async {
    try {
      print('ApiService calling fetchIncidents');
      final List<dynamic> data = await _incidentDataSource.fetchIncidents();

      final incidents = data
          .map((json) => IncidentModel.fromJson(json) as Incident)
          .toList();
      return incidents;
    } catch (e) {
      print('ApiService fetchIncidents error: $e');
      throw Exception('Failed to fetch incidents: $e');
    }
  }


}
