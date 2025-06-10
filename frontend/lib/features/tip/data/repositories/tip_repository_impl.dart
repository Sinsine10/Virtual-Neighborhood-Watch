import '../../domain/entities/tip.dart';
import '../../domain/repositories/tip_repository.dart';
import '../datasources/tip_remote_datasource.dart';

class TipRepositoryImpl implements TipRepository {
  final TipRemoteDataSource remoteDataSource;

  TipRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Tip>> getTips() async {
    try {
      return await remoteDataSource.fetchTips();
    } catch (e) {
      throw Exception('Failed to fetch tips: $e');
    }
  }

  @override
  Future<Tip> createTip(Tip tip) async {
    try {
      return await remoteDataSource.createTip(tip.toJson());
    } catch (e) {
      throw Exception('Failed to create tip: $e');
    }
  }

  @override
  Future<Tip> updateTip(Tip tip) async {
    try {
      await remoteDataSource.updateTip(tip.id, tip.description);
      // Optionally refetch the updated tip to ensure consistency
      return await remoteDataSource.fetchTipById(tip.id);
    } catch (e) {
      if (e.toString().contains('404')) {
        throw Exception('Tip with ID ${tip.id} not found');
      }
      throw Exception('Failed to update tip: $e');
    }
  }

  @override
  Future<Tip> deleteTip(int id) async {
    try {
      Tip deletedTip = await remoteDataSource.fetchTipById(id); // Fetch before delete
      await remoteDataSource.deleteTip(id);
      return deletedTip;
    } catch (e) {
      if (e.toString().contains('404')) {
        throw Exception('Tip with ID $id not found');
      }
      throw Exception('Failed to delete tip: $e');
    }
  }
}