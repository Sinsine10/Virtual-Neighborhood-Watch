

import '../../domain/entities/tip.dart';

class TipState {
  final List<Tip> tips;
  final bool isLoading;
  final String? errorMessage;

  TipState({
    this.tips = const [],
    this.isLoading = false,
    this.errorMessage,
  });
}