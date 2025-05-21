import 'package:flutter/material.dart';
import '../data/models/incident.dart';
import '../services/api_service.dart';

class IncidentViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Incident> _incidents = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedLocation;

  List<Incident> get incidents => _selectedLocation == null
      ? _incidents
      : _incidents.where((incident) => incident.location == _selectedLocation).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedLocation => _selectedLocation;

  Future<void> fetchIncidents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _incidents = await _apiService.fetchIncidents();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  List<String> getLocations() {
    return _incidents.map((incident) => incident.location).toSet().toList();
  }
}