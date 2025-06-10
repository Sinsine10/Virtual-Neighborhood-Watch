import '../entities/tip.dart';
import '../repositories/tip_repository.dart';

class FetchTipsUseCase {
  final TipRepository repository;

  FetchTipsUseCase(this.repository);

  Future<List<Tip>> execute() async {
    return await repository.getTips();
  }
}