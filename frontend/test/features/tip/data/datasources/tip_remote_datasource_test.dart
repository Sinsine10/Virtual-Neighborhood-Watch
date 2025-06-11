import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:neihborhoodwatch/features/tip/data/datasources/tip_remote_datasource.dart';
import 'package:neihborhoodwatch/features/tip/domain/entities/tip.dart';

@GenerateMocks([Dio])
import 'tip_remote_datasource_test.mocks.dart';

void main() {
  late TipRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = TipRemoteDataSource(mockDio);
  });

  group('fetchTips', () {
    final tTips = [
      {
        'id': 1,
        'description': 'Test Tip 1',
      },
      {
        'id': 2,
        'description': 'Test Tip 2',
      },
    ];

    test('should return list of tips when API call is successful', () async {
      // arrange
      when(mockDio.get('/tips')).thenAnswer((_) async => Response(
            data: tTips,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/tips'),
          ));

      // act
      final result = await dataSource.fetchTips();

      // assert
      expect(result.length, equals(2));
      expect(result[0].id, equals(1));
      expect(result[0].description, equals('Test Tip 1'));
      expect(result[1].id, equals(2));
      expect(result[1].description, equals('Test Tip 2'));
      verify(mockDio.get('/tips'));
    });

    test('should throw exception when API call fails', () async {
      // arrange
      when(mockDio.get('/tips')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/tips'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.fetchTips(), throwsA(isA<Exception>()));
      verify(mockDio.get('/tips'));
    });
  });

  group('createTip', () {
    final tTipData = {
      'id': 1,
      'description': 'New Tip',
    };

    test('should successfully create a tip', () async {
      // arrange
      when(mockDio.post(
        '/tips',
        data: tTipData,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: tTipData,
            statusCode: 201,
            requestOptions: RequestOptions(path: '/tips'),
          ));

      // act
      final result = await dataSource.createTip(tTipData);

      // assert
      expect(result.id, equals(1));
      expect(result.description, equals('New Tip'));
      verify(mockDio.post(
        '/tips',
        data: tTipData,
        options: anyNamed('options'),
      ));
    });

    test('should throw exception when creating tip fails', () async {
      // arrange
      when(mockDio.post(
        '/tips',
        data: tTipData,
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/tips'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.createTip(tTipData), throwsA(isA<Exception>()));
      verify(mockDio.post(
        '/tips',
        data: tTipData,
        options: anyNamed('options'),
      ));
    });
  });

  group('updateTip', () {
    const tId = 1;
    const tDescription = 'Updated Tip';

    test('should successfully update a tip', () async {
      // arrange
      when(mockDio.put(
        '/tips/$tId',
        data: {'description': tDescription},
      )).thenAnswer((_) async => Response(
            data: {'message': 'Success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/tips/$tId'),
          ));

      // act
      await dataSource.updateTip(tId, tDescription);

      // assert
      verify(mockDio.put(
        '/tips/$tId',
        data: {'description': tDescription},
      ));
    });

    test('should throw exception when updating tip fails', () async {
      // arrange
      when(mockDio.put(
        '/tips/$tId',
        data: {'description': tDescription},
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/tips/$tId'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.updateTip(tId, tDescription),
          throwsA(isA<Exception>()));
      verify(mockDio.put(
        '/tips/$tId',
        data: {'description': tDescription},
      ));
    });
  });

  group('deleteTip', () {
    const tId = 1;

    test('should successfully delete a tip', () async {
      // arrange
      when(mockDio.delete('/tips/$tId')).thenAnswer((_) async => Response(
            data: {'message': 'Success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/tips/$tId'),
          ));

      // act
      await dataSource.deleteTip(tId);

      // assert
      verify(mockDio.delete('/tips/$tId'));
    });

    test('should throw exception when deleting tip fails', () async {
      // arrange
      when(mockDio.delete('/tips/$tId')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/tips/$tId'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.deleteTip(tId), throwsA(isA<Exception>()));
      verify(mockDio.delete('/tips/$tId'));
    });
  });

  group('fetchTipById', () {
    const tId = 1;
    final tTipData = {
      'id': tId,
      'description': 'Test Tip',
    };

    test('should successfully fetch a tip by id', () async {
      // arrange
      when(mockDio.get('/tips/$tId')).thenAnswer((_) async => Response(
            data: tTipData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/tips/$tId'),
          ));

      // act
      final result = await dataSource.fetchTipById(tId);

      // assert
      expect(result.id, equals(tId));
      expect(result.description, equals('Test Tip'));
      verify(mockDio.get('/tips/$tId'));
    });

    test('should throw exception when fetching tip by id fails', () async {
      // arrange
      when(mockDio.get('/tips/$tId')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/tips/$tId'),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.fetchTipById(tId), throwsA(isA<Exception>()));
      verify(mockDio.get('/tips/$tId'));
    });
  });
} 