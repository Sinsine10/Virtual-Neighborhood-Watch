import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/incident/data/datasources/incident_remote_datasource.dart';
import 'package:neihborhoodwatch/features/incident/data/repositories/incident_repository_impl.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';

@GenerateMocks([IncidentRemoteDataSource])
import 'incident_repository_impl_test.mocks.dart';

void main() {
  late IncidentRepositoryImpl repository;
  late MockIncidentRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockIncidentRemoteDataSource();
    repository = IncidentRepositoryImpl(mockRemoteDataSource);
  });

  group('getAllIncidents', () {
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

    test('should return list of incidents when remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.fetchIncidents())
          .thenAnswer((_) async => tIncidents);

      // act
      final result = await repository.getAllIncidents();

      // assert
      expect(result, equals(tIncidents));
      verify(mockRemoteDataSource.fetchIncidents());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return empty list when remote data source throws an error',
        () async {
      // arrange
      when(mockRemoteDataSource.fetchIncidents())
          .thenThrow(Exception('Network error'));

      // act
      final result = await repository.getAllIncidents();

      // assert
      expect(result, isEmpty);
      verify(mockRemoteDataSource.fetchIncidents());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('addIncident', () {
    final tIncident = Incident(
      title: 'New Incident',
      description: 'New Description',
      location: 'New Location',
    );

    test('should successfully add an incident', () async {
      // arrange
      when(mockRemoteDataSource.addIncident(tIncident))
          .thenAnswer((_) async => null);

      // act
      await repository.addIncident(tIncident);

      // assert
      verify(mockRemoteDataSource.addIncident(tIncident));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw exception when adding incident fails', () async {
      // arrange
      when(mockRemoteDataSource.addIncident(tIncident))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.addIncident(tIncident),
          throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.addIncident(tIncident));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('updateIncident', () {
    final tIncident = Incident(
      id: '1',
      title: 'Updated Incident',
      description: 'Updated Description',
      location: 'Updated Location',
    );

    test('should successfully update an incident', () async {
      // arrange
      when(mockRemoteDataSource.updateIncident(tIncident))
          .thenAnswer((_) async => null);

      // act
      await repository.updateIncident(tIncident);

      // assert
      verify(mockRemoteDataSource.updateIncident(tIncident));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw exception when updating incident fails', () async {
      // arrange
      when(mockRemoteDataSource.updateIncident(tIncident))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.updateIncident(tIncident),
          throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.updateIncident(tIncident));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('deleteIncident', () {
    const tId = '1';

    test('should successfully delete an incident', () async {
      // arrange
      when(mockRemoteDataSource.deleteIncident(tId))
          .thenAnswer((_) async => null);

      // act
      await repository.deleteIncident(tId);

      // assert
      verify(mockRemoteDataSource.deleteIncident(tId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw exception when deleting incident fails', () async {
      // arrange
      when(mockRemoteDataSource.deleteIncident(tId))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.deleteIncident(tId),
          throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.deleteIncident(tId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
} 