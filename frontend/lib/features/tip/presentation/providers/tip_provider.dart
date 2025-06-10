import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/api_service.dart';
import '../../domain/entities/tip.dart';
import '../states/tip_state.dart';
import '../states/tip_notifier.dart';



// Define a provider for the TipNotifier
final tipProvider = StateNotifierProvider<TipNotifier, TipState>((ref) {
  final apiService = ApiService(); // Instantiate your API service
  return TipNotifier(apiService);
});

// TipNotifier manages the state for tips
class TipNotifier extends StateNotifier<TipState> {
  final ApiService _apiService;

  TipNotifier(this._apiService) : super(TipState());

  Future<void> fetchTips() async {
    state = TipState(isLoading: true);
    try {
      final tips = await _apiService.fetchTips();
      state = TipState(tips: tips);
    } catch (e) {
      state = TipState(errorMessage: e.toString());
    }
  }

  Future<void> addTip(String description) async {
    state = TipState(isLoading: true);
    try {
      final newTip = Tip(id: state.tips.length + 1, description: description);
      await _apiService.addTip(newTip);
      state = TipState(tips: [...state.tips, newTip]);
    } catch (e) {
      state = TipState(errorMessage: e.toString());
    }
  }

  Future<void> updateTip(int id, String description) async {
    state = TipState(isLoading: true);
    try {
      await _apiService.updateTip(id, description);
      final updatedTips = state.tips.map((tip) {
        return tip.id == id ? Tip(id: id, description: description) : tip;
      }).toList();
      state = TipState(tips: updatedTips);
    } catch (e) {
      state = TipState(errorMessage: e.toString());
    }
  }

  Future<void> deleteTip(int id) async {
    state = TipState(isLoading: true);
    try {
      await _apiService.deleteTip(id);
      final updatedTips = state.tips.where((tip) => tip.id != id).toList();
      state = TipState(tips: updatedTips);
    } catch (e) {
      state = TipState(errorMessage: e.toString());
    }
  }
}