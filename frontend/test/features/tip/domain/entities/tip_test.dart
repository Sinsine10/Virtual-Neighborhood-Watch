import 'package:flutter_test/flutter_test.dart';
import 'package:neihborhoodwatch/features/tip/domain/entities/tip.dart';

void main() {
  group('Tip Entity Tests', () {
    test('should create a Tip instance with required fields', () {
      // arrange
      const id = 1;
      const description = 'Test Tip Description';

      // act
      final tip = Tip(
        id: id,
        description: description,
      );

      // assert
      expect(tip.id, equals(id));
      expect(tip.description, equals(description));
    });

    test('should create a Tip instance from JSON', () {
      // arrange
      final json = {
        'id': 1,
        'description': 'Test Tip Description',
      };

      // act
      final tip = Tip.fromJson(json);

      // assert
      expect(tip.id, equals(1));
      expect(tip.description, equals('Test Tip Description'));
    });

    test('should convert Tip to JSON', () {
      // arrange
      final tip = Tip(
        id: 1,
        description: 'Test Tip Description',
      );

      // act
      final json = tip.toJson();

      // assert
      expect(json['id'], equals(1));
      expect(json['description'], equals('Test Tip Description'));
    });

    test('should handle invalid JSON data', () {
      // arrange
      final json = {
        'id': 'invalid', // String instead of int
        'description': 'Test Tip Description',
      };

      // act & assert
      expect(() => Tip.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('should handle missing description in JSON', () {
      // arrange
      final json = {
        'id': 1,
      };

      // act & assert
      expect(() => Tip.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
} 