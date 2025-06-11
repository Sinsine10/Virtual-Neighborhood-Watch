import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/incident/data/repositories/incident_repository_impl.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';
import 'package:neihborhoodwatch/features/incident/presentation/providers/incident_provider.dart';

@GenerateMocks([IncidentRepositoryImpl])
import 'incident_provider_test.mocks.dart';

void main() {
  late IncidentNotifier notifier;
  late MockIncidentRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockIncidentRepositoryImpl();
    notifier = IncidentNotifier(mockRepository);
  });

  group('IncidentNotifier', () {
    final tIncidents = [
      Incident(
        id: '1',
        title: 'Test Incident 1',
        description: 'Description 1',
        location: 'Location 1',
      ),
      Incident(
        id: '2',
        title: 'Test Incident 2',
        description: 'Description 2',
        location: 'Location 2',
      ),
    ];

    test('initial state should be empty list', () {
      expect(notifier.state, isEmpty);
    });

    test('loadIncidents should update state with incidents', () async {
      // arrange
      when(mockRepository.getAllIncidents())
          .thenAnswer((_) async => tIncidents);

      // act
      await notifier.loadIncidents();

      // assert
      expect(notifier.state, equals(tIncidents));
      expect(notifier.hasLoaded, isTrue);
      verify(mockRepository.getAllIncidents()).called(1);
    });

    test('loadIncidents should handle errors gracefully', () async {
      // arrange
      when(mockRepository.getAllIncidents())
          .thenThrow(Exception('Network error'));

      // act
      await notifier.loadIncidents();

      // assert
      expect(notifier.state, isEmpty);
      expect(notifier.hasLoaded, isTrue);
      verify(mockRepository.getAllIncidents()).called(1);
    });

    test('addIncident should add new incident and refresh list', () async {
      // arrange
      final newIncident = Incident(
        title: 'New Incident',
        description: 'New Description',
        location: 'New Location',
      );
      when(mockRepository.addIncident(newIncident))
          .thenAnswer((_) async => null);
      when(mockRepository.getAllIncidents())
          .thenAnswer((_) async => [...tIncidents, newIncident]);

      // act
      await notifier.addIncident(newIncident);

      // assert
      verify(mockRepository.addIncident(newIncident)).called(1);
      verify(mockRepository.getAllIncidents()).called(1);
      expect(notifier.state, contains(newIncident));
    });

    test('updateIncident should update incident and refresh list', () async {
      // arrange
      final updatedIncident = Incident(
        id: '1',
        title: 'Updated Title',
        description: 'Updated Description',
        location: 'Updated Location',
      );
      when(mockRepository.updateIncident(updatedIncident))
          .thenAnswer((_) async => null);
      when(mockRepository.getAllIncidents())
          .thenAnswer((_) async => [updatedIncident, tIncidents[1]]);

      // act
      await notifier.updateIncident(updatedIncident);

      // assert
      verify(mockRepository.updateIncident(updatedIncident)).called(1);
      verify(mockRepository.getAllIncidents()).called(1);
      expect(notifier.state, contains(updatedIncident));
    });

    test('deleteIncident should remove incident and refresh list', () async {
      // arrange
      const idToDelete = '1';
      when(mockRepository.deleteIncident(idToDelete))
          .thenAnswer((_) async => null);
      when(mockRepository.getAllIncidents())
          .thenAnswer((_) async => [tIncidents[1]]); // Only second incident remains

      // act
      await notifier.deleteIncident(idToDelete);

      // assert
      verify(mockRepository.deleteIncident(idToDelete)).called(1);
      verify(mockRepository.getAllIncidents()).called(1);
      expect(notifier.state, isNot(contains(tIncidents[0])));
      expect(notifier.state, contains(tIncidents[1]));
    });

    test('error handling in addIncident should not crash', () async {
      // arrange
      final newIncident = Incident(
        title: 'New Incident',
        description: 'New Description',
        location: 'New Location',
      );
      when(mockRepository.addIncident(newIncident))
          .thenThrow(Exception('Network error'));

      // act
      await notifier.addIncident(newIncident);

      // assert
      verify(mockRepository.addIncident(newIncident)).called(1);
      expect(notifier.state, isEmpty); // State should remain unchanged
    });

    test('error handling in updateIncident should not crash', () async {
      // arrange
      final updatedIncident = Incident(
        id: '1',
        title: 'Updated Title',
        description: 'Updated Description',
        location: 'Updated Location',
      );
      when(mockRepository.updateIncident(updatedIncident))
          .thenThrow(Exception('Network error'));

      // act
      await notifier.updateIncident(updatedIncident);

      // assert
      verify(mockRepository.updateIncident(updatedIncident)).called(1);
      expect(notifier.state, isEmpty); // State should remain unchanged
    });

    test('error handling in deleteIncident should not crash', () async {
      // arrange
      const idToDelete = '1';
      when(mockRepository.deleteIncident(idToDelete))
          .thenThrow(Exception('Network error'));

      // act
      await notifier.deleteIncident(idToDelete);

      // assert
      verify(mockRepository.deleteIncident(idToDelete)).called(1);
      expect(notifier.state, isEmpty); // State should remain unchanged
    });
  });
} 