import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:neihborhoodwatch/features/incident/data/datasources/incident_remote_datasource.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';

@GenerateMocks([Dio])
import 'incident_remote_datasource_test.mocks.dart';

void main() {
  late IncidentRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = IncidentRemoteDataSource(mockDio);
  });

  group('fetchIncidents', () {
    final tIncidents = [
      {
        '_id': '1',
        'title': 'Test Incident 1',
        'description': 'Description 1',
        'location': 'Location 1',
      },
      {
        '_id': '2',
        'title': 'Test Incident 2',
        'description': 'Description 2',
        'location': 'Location 2',
      },
    ];

    test('should return list of incidents when API call is successful', () async {
      // arrange
      when(mockDio.get('/incidents')).thenAnswer((_) async => Response(
            data: tIncidents,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/incidents'),
          ));

      // act
      final result = await dataSource.fetchIncidents();

      // assert
      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[0].title, equals('Test Incident 1'));
      expect(result[1].id, equals('2'));
      expect(result[1].title, equals('Test Incident 2'));
      verify(mockDio.get('/incidents'));
    });

    test('should return empty list when API call fails', () async {
      // arrange
      when(mockDio.get('/incidents')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/incidents'),
        error: 'Network error',
      ));

      // act
      final result = await dataSource.fetchIncidents();

      // assert
      expect(result, isEmpty);
      verify(mockDio.get('/incidents'));
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
      when(mockDio.post(
        '/incidents',
        data: tIncident.toJson(),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {'message': 'Success'},
            statusCode: 201,
            requestOptions: RequestOptions(path: '/incidents'),
          ));

      // act
      await dataSource.addIncident(tIncident);

      // assert
      verify(mockDio.post(
        '/incidents',
        data: tIncident.toJson(),
        options: anyNamed('options'),
      ));
    });

    test('should throw exception when adding incident fails', () async {
      // arrange
      when(mockDio.post(
        '/incidents',
        data: tIncident.toJson(),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/incidents'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.addIncident(tIncident),
          throwsA(isA<DioException>()));
      verify(mockDio.post(
        '/incidents',
        data: tIncident.toJson(),
        options: anyNamed('options'),
      ));
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
      when(mockDio.put(
        '/incidents/${tIncident.id}',
        data: tIncident.toJson(),
      )).thenAnswer((_) async => Response(
            data: {'message': 'Success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/incidents/1'),
          ));

      // act
      await dataSource.updateIncident(tIncident);

      // assert
      verify(mockDio.put(
        '/incidents/${tIncident.id}',
        data: tIncident.toJson(),
      ));
    });

    test('should throw exception when updating incident fails', () async {
      // arrange
      when(mockDio.put(
        '/incidents/${tIncident.id}',
        data: tIncident.toJson(),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/incidents/1'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.updateIncident(tIncident),
          throwsA(isA<DioException>()));
      verify(mockDio.put(
        '/incidents/${tIncident.id}',
        data: tIncident.toJson(),
      ));
    });
  });

  group('deleteIncident', () {
    const tId = '1';

    test('should successfully delete an incident', () async {
      // arrange
      when(mockDio.delete('/incidents/$tId')).thenAnswer((_) async => Response(
            data: {'message': 'Success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/incidents/$tId'),
          ));

      // act
      await dataSource.deleteIncident(tId);

      // assert
      verify(mockDio.delete('/incidents/$tId'));
    });

    test('should throw exception when deleting incident fails', () async {
      // arrange
      when(mockDio.delete('/incidents/$tId')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/incidents/$tId'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.deleteIncident(tId),
          throwsA(isA<DioException>()));
      verify(mockDio.delete('/incidents/$tId'));
    });
  });
} 