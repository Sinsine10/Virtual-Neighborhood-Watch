import 'package:flutter_test/flutter_test.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';

void main() {
  group('Incident Entity Tests', () {
    test('should create an Incident instance with required fields', () {
      // arrange
      const title = 'Test Incident';
      const description = 'Test Description';
      const location = 'Test Location';

      // act
      final incident = Incident(
        title: title,
        description: description,
        location: location,
      );

      // assert
      expect(incident.title, equals(title));
      expect(incident.description, equals(description));
      expect(incident.location, equals(location));
      expect(incident.id, isNull);
    });

    test('should create an Incident instance from JSON', () {
      // arrange
      final json = {
        '_id': '123',
        'title': 'Test Incident',
        'description': 'Test Description',
        'location': 'Test Location',
      };

      // act
      final incident = Incident.fromJson(json);

      // assert
      expect(incident.id, equals('123'));
      expect(incident.title, equals('Test Incident'));
      expect(incident.description, equals('Test Description'));
      expect(incident.location, equals('Test Location'));
    });

    test('should convert Incident to JSON', () {
      // arrange
      final incident = Incident(
        id: '123',
        title: 'Test Incident',
        description: 'Test Description',
        location: 'Test Location',
      );

      // act
      final json = incident.toJson();

      // assert
      expect(json['title'], equals('Test Incident'));
      expect(json['description'], equals('Test Description'));
      expect(json['location'], equals('Test Location'));
      expect(json.containsKey('id'), isFalse); // id should not be included in toJson
    });

    test('should create a copy of Incident with updated fields', () {
      // arrange
      final original = Incident(
        id: '123',
        title: 'Original Title',
        description: 'Original Description',
        location: 'Original Location',
      );

      // act
      final updated = original.copyWith(
        title: 'Updated Title',
        location: 'Updated Location',
      );

      // assert
      expect(updated.id, equals('123')); // id should remain the same
      expect(updated.title, equals('Updated Title'));
      expect(updated.description, equals('Original Description')); // unchanged
      expect(updated.location, equals('Updated Location'));
    });

    test('should handle null location in fromJson', () {
      // arrange
      final json = {
        '_id': '123',
        'title': 'Test Incident',
        'description': 'Test Description',
      };

      // act
      final incident = Incident.fromJson(json);

      // assert
      expect(incident.location, equals('')); // should default to empty string
    });
  });
} 