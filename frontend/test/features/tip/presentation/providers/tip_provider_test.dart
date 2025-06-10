import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/tip/data/services/api_service.dart';
import 'package:neihborhoodwatch/features/tip/domain/entities/tip.dart';
import 'package:neihborhoodwatch/features/tip/presentation/providers/tip_provider.dart';
import 'package:neihborhoodwatch/features/tip/presentation/states/tip_state.dart';

@GenerateMocks([ApiService])
import 'tip_provider_test.mocks.dart';

void main() {
  late TipNotifier notifier;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    notifier = TipNotifier(mockApiService);
  });

  group('TipNotifier', () {
    final tTips = [
      Tip(id: 1, description: 'Test Tip 1'),
      Tip(id: 2, description: 'Test Tip 2'),
    ];

    test('initial state should be empty list', () {
      expect(notifier.state.tips, isEmpty);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('fetchTips should update state with tips', () async {
      // arrange
      when(mockApiService.fetchTips())
          .thenAnswer((_) async => tTips);

      // act
      await notifier.fetchTips();

      // assert
      expect(notifier.state.tips, equals(tTips));
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
      verify(mockApiService.fetchTips()).called(1);
    });

    test('fetchTips should handle errors gracefully', () async {
      // arrange
      when(mockApiService.fetchTips())
          .thenThrow(Exception('Network error'));

      // act
      await notifier.fetchTips();

      // assert
      expect(notifier.state.tips, isEmpty);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNotNull);
      verify(mockApiService.fetchTips()).called(1);
    });

    test('addTip should add new tip and update state', () async {
      // arrange
      const newDescription = 'New Tip Description';
      final newTip = Tip(id: 3, description: newDescription);
      when(mockApiService.addTip(any))
          .thenAnswer((_) async => null);

      // act
      await notifier.addTip(newDescription);

      // assert
      verify(mockApiService.addTip(any)).called(1);
      expect(notifier.state.tips.last.description, equals(newDescription));
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('updateTip should update tip and refresh state', () async {
      // arrange
      const tipId = 1;
      const updatedDescription = 'Updated Tip Description';
      when(mockApiService.updateTip(tipId, updatedDescription))
          .thenAnswer((_) async => null);

      // act
      await notifier.updateTip(tipId, updatedDescription);

      // assert
      verify(mockApiService.updateTip(tipId, updatedDescription)).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('deleteTip should remove tip and update state', () async {
      // arrange
      const tipId = 1;
      when(mockApiService.deleteTip(tipId))
          .thenAnswer((_) async => null);

      // act
      await notifier.deleteTip(tipId);

      // assert
      verify(mockApiService.deleteTip(tipId)).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('error handling in addTip should update error state', () async {
      // arrange
      const newDescription = 'New Tip Description';
      when(mockApiService.addTip(any))
          .thenThrow(Exception('Network error'));

      // act
      await notifier.addTip(newDescription);

      // assert
      verify(mockApiService.addTip(any)).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNotNull);
    });

    test('error handling in updateTip should update error state', () async {
      // arrange
      const tipId = 1;
      const updatedDescription = 'Updated Tip Description';
      when(mockApiService.updateTip(tipId, updatedDescription))
          .thenThrow(Exception('Network error'));

      // act
      await notifier.updateTip(tipId, updatedDescription);

      // assert
      verify(mockApiService.updateTip(tipId, updatedDescription)).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNotNull);
    });

    test('error handling in deleteTip should update error state', () async {
      // arrange
      const tipId = 1;
      when(mockApiService.deleteTip(tipId))
          .thenThrow(Exception('Network error'));

      // act
      await notifier.deleteTip(tipId);

      // assert
      verify(mockApiService.deleteTip(tipId)).called(1);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNotNull);
    });
  });
} 