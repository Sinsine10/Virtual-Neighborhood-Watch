import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/tip.dart';
import '../states/tip_state.dart';
import '../states/tip_notifier.dart';

final tipProvider = StateNotifierProvider<TipNotifier, TipState>((ref) {
  final apiService = ApiService();
  print('TipProvider creating TipNotifier with ApiService');
  return TipNotifier(apiService);
});

class TipNotifier extends StateNotifier<TipState> {
  final ApiService _apiService;

  TipNotifier(this._apiService) : super(TipState()) {
    print('TipNotifier initialized');
  }

  Future<void> fetchTips() async {
    print('TipNotifier: Starting fetchTips at ${DateTime.now()}');
    state = TipState(isLoading: true);
    try {
      print('TipNotifier: Calling _apiService.fetchTips');
      final tips = await _apiService.fetchTips();
      print('TipNotifier: Fetched tips: $tips');
      state = TipState(tips: tips);
    } catch (e) {
      print('TipNotifier: FetchTips error at ${DateTime.now()}: $e');
      state = TipState(errorMessage: e.toString());
    }
  }

  Future<void> addTip(String description) async {
    print('TipNotifier: Starting addTip');
    state = TipState(isLoading: true);
    try {
      final newTip = Tip(id: state.tips.length + 1, description: description);
      print('TipNotifier: Adding tip: $newTip');
      await _apiService.addTip(newTip);
      state = TipState(tips: [...state.tips, newTip]);
    } catch (e) {
      print('TipNotifier: AddTip error: $e');
      state = TipState(errorMessage: e.toString());
    }
  }

  Future<void> updateTip(int id, String description) async {
    print('TipNotifier: Starting updateTip for ID $id');
    state = TipState(isLoading: true);
    try {
      print('TipNotifier: Updating tip with ID $id, description: $description');
      await _apiService.updateTip(id, description);
      final updatedTips = state.tips.map((tip) {
        return tip.id == id ? Tip(id: id, description: description) : tip;
      }).toList();
      state = TipState(tips: updatedTips);
    } catch (e) {
      print('TipNotifier: UpdateTip error: $e');
      state = TipState(errorMessage: e.toString());
    }
  }

  Future<void> deleteTip(int id) async {
    print('TipNotifier: Starting deleteTip for ID $id');
    state = TipState(isLoading: true);
    try {
      print('TipNotifier: Deleting tip with ID $id');
      await _apiService.deleteTip(id);
      final updatedTips = state.tips.where((tip) => tip.id != id).toList();
      state = TipState(tips: updatedTips);
    } catch (e) {
      print('TipNotifier: DeleteTip error: $e');
      state = TipState(errorMessage: e.toString());
    }
  }
}