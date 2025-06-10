import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/tip/data/datasources/tip_remote_datasource.dart';
import 'package:neihborhoodwatch/features/tip/data/repositories/tip_repository_impl.dart';
import 'package:neihborhoodwatch/features/tip/domain/entities/tip.dart';

@GenerateMocks([TipRemoteDataSource])
import 'tip_repository_impl_test.mocks.dart';

void main() {
  late TipRepositoryImpl repository;
  late MockTipRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockTipRemoteDataSource();
    repository = TipRepositoryImpl(mockRemoteDataSource);
  });

  group('getTips', () {
    final tTips = [
      Tip(id: 1, description: 'Test Tip 1'),
      Tip(id: 2, description: 'Test Tip 2'),
    ];

    test('should return list of tips when remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.fetchTips())
          .thenAnswer((_) async => tTips);

      // act
      final result = await repository.getTips();

      // assert
      expect(result, equals(tTips));
      verify(mockRemoteDataSource.fetchTips());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw exception when remote data source throws an error',
        () async {
      // arrange
      when(mockRemoteDataSource.fetchTips())
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.getTips(), throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.fetchTips());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('createTip', () {
    final tTip = Tip(id: 1, description: 'New Tip');

    test('should successfully create a tip', () async {
      // arrange
      when(mockRemoteDataSource.createTip(tTip.toJson()))
          .thenAnswer((_) async => tTip);

      // act
      final result = await repository.createTip(tTip);

      // assert
      expect(result, equals(tTip));
      verify(mockRemoteDataSource.createTip(tTip.toJson()));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw exception when creating tip fails', () async {
      // arrange
      when(mockRemoteDataSource.createTip(tTip.toJson()))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.createTip(tTip), throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.createTip(tTip.toJson()));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('updateTip', () {
    final tTip = Tip(id: 1, description: 'Updated Tip');

    test('should successfully update a tip', () async {
      // arrange
      when(mockRemoteDataSource.updateTip(tTip.id, tTip.description))
          .thenAnswer((_) async => null);
      when(mockRemoteDataSource.fetchTipById(tTip.id))
          .thenAnswer((_) async => tTip);

      // act
      final result = await repository.updateTip(tTip);

      // assert
      expect(result, equals(tTip));
      verify(mockRemoteDataSource.updateTip(tTip.id, tTip.description));
      verify(mockRemoteDataSource.fetchTipById(tTip.id));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw exception when updating tip fails', () async {
      // arrange
      when(mockRemoteDataSource.updateTip(tTip.id, tTip.description))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.updateTip(tTip), throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.updateTip(tTip.id, tTip.description));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('deleteTip', () {
    const tId = 1;
    final tTip = Tip(id: tId, description: 'Tip to Delete');

    test('should successfully delete a tip', () async {
      // arrange
      when(mockRemoteDataSource.fetchTipById(tId))
          .thenAnswer((_) async => tTip);
      when(mockRemoteDataSource.deleteTip(tId))
          .thenAnswer((_) async => null);

      // act
      final result = await repository.deleteTip(tId);

      // assert
      expect(result, equals(tTip));
      verify(mockRemoteDataSource.fetchTipById(tId));
      verify(mockRemoteDataSource.deleteTip(tId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw exception when deleting tip fails', () async {
      // arrange
      when(mockRemoteDataSource.fetchTipById(tId))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.deleteTip(tId), throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.fetchTipById(tId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
} 