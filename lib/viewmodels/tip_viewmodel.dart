import 'package:flutter/material.dart';
import '../data/models/tip.dart';
import '../services/api_service.dart';

class TipViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Tip> _tips = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Tip> get tips => _tips;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tips = await _apiService.fetchTips();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTip(String description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newTip = Tip(id: _tips.length + 1, description: description);
      await _apiService.addTip(newTip);
      _tips.add(newTip);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTip(int id, String description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateTip(id, description);
      final index = _tips.indexWhere((tip) => tip.id == id);
      if (index != -1) {
        _tips[index] = Tip(id: id, description: description);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTip(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteTip(id);
      _tips.removeWhere((tip) => tip.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}