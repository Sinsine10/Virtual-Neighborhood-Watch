import '../entities/tip.dart';

abstract class TipRepository {
  Future<List<Tip>> getTips();
  Future<Tip> createTip(Tip tip);
  Future<Tip> updateTip(Tip tip);
  Future<void> deleteTip(int id); // Change to accept int
}