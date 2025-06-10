import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/incident/data/repositories/incident_repository_impl.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';
import 'package:neihborhoodwatch/features/incident/domain/repositories/incident_repository.dart';
import 'package:neihborhoodwatch/features/incident/presentation/pages/incident_screen.dart';
import 'package:neihborhoodwatch/features/incident/presentation/providers/incident_provider.dart';


import '../providers/incident_provider_test.mocks.dart';
@GenerateMocks([IncidentRepositoryImpl], customMocks: [MockSpec<IncidentRepositoryImpl>(as: #MockIncidentRepositoryImpl)])
import 'incident_screen_test.mocks.dart';

void main() {
  late MockIncidentRepositoryImpl mockIncidentRepository;

  setUp(() {
    mockIncidentRepository = MockIncidentRepositoryImpl();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        incidentNotifierProvider.overrideWith((ref) => IncidentNotifier(mockIncidentRepository)),
      ],
      child: const MaterialApp(
        home: UserReportsPage(),
      ),
    );
  }

  group('IncidentScreen Widget Tests', () {
    testWidgets('should show loading indicator when fetching incidents',
            (WidgetTester tester) async {
          // arrange
          when(mockIncidentRepository.getAllIncidents()).thenAnswer(
                (_) => Future.delayed(const Duration(seconds: 1), () => []),
          );

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pump();

          // assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('should display incidents when data is loaded',
            (WidgetTester tester) async {
          // arrange
          final incidents = [
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
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => incidents);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          // assert
          expect(find.text('Test Incident 1'), findsOneWidget);
          expect(find.text('Test Incident 2'), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);
        });

    testWidgets('should show error message when fetch fails',
            (WidgetTester tester) async {
          // arrange
          when(mockIncidentRepository.getAllIncidents())
              .thenThrow(Exception('Failed to fetch incidents'));

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          // assert
          expect(find.text('Exception: Failed to fetch incidents'), findsOneWidget);
        });

    testWidgets('should show add incident dialog when FAB is pressed',
            (WidgetTester tester) async {
          // arrange
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => []);
          when(mockIncidentRepository.addIncident(any)).thenAnswer((_) async => null);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          // assert
          expect(find.text('Add Incident'), findsOneWidget);
          expect(find.byType(TextField), findsNWidgets(3)); // Title, Description, Location
          expect(find.text('Submit'), findsOneWidget);
        });

    testWidgets('should add new incident when dialog is submitted',
            (WidgetTester tester) async {
          // arrange
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => []);
          when(mockIncidentRepository.addIncident(any)).thenAnswer((_) async => null);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          // Enter incident details
          await tester.enterText(find.widgetWithText(TextField, 'Title'), 'New Incident');
          await tester.enterText(find.widgetWithText(TextField, 'Description'), 'New Description');
          await tester.enterText(find.widgetWithText(TextField, 'Location'), 'New Location');

          await tester.tap(find.text('Submit'));
          await tester.pumpAndSettle();

          // assert
          verify(mockIncidentRepository.addIncident(any)).called(1);
        });

    testWidgets('should show edit incident dialog when edit button is pressed',
            (WidgetTester tester) async {
          // arrange
          final incidents = [
            Incident(
              id: '1',
              title: 'Test Incident',
              description: 'Description',
              location: 'Location',
            ),
          ];
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => incidents);
          when(mockIncidentRepository.updateIncident(any)).thenAnswer((_) async => null);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.edit));
          await tester.pumpAndSettle();

          // assert
          expect(find.text('Edit Incident'), findsOneWidget);
          expect(find.byType(TextField), findsNWidgets(3));
          expect(find.text('Update'), findsOneWidget);
        });

    testWidgets('should update incident when edit dialog is submitted',
            (WidgetTester tester) async {
          // arrange
          final incidents = [
            Incident(
              id: '1',
              title: 'Test Incident',
              description: 'Description',
              location: 'Location',
            ),
          ];
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => incidents);
          when(mockIncidentRepository.updateIncident(any)).thenAnswer((_) async => null);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.edit));
          await tester.pumpAndSettle();

          // Update incident details
          await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Updated Incident');
          await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Updated Description');
          await tester.enterText(find.widgetWithText(TextField, 'Location'), 'Updated Location');

          await tester.tap(find.text('Update'));
          await tester.pumpAndSettle();

          // assert
          verify(mockIncidentRepository.updateIncident(any)).called(1);
        });

    testWidgets('should show delete confirmation dialog when delete button is pressed',
            (WidgetTester tester) async {
          // arrange
          final incidents = [
            Incident(
              id: '1',
              title: 'Test Incident',
              description: 'Description',
              location: 'Location',
            ),
          ];
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => incidents);
          when(mockIncidentRepository.deleteIncident(any)).thenAnswer((_) async => null);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.delete));
          await tester.pumpAndSettle();

          // assert
          expect(find.text('Delete Incident'), findsOneWidget);
          expect(find.text('Are you sure you want to delete this incident?'), findsOneWidget);
          expect(find.text('Delete'), findsOneWidget);
          expect(find.text('Cancel'), findsOneWidget);
        });

    testWidgets('should delete incident when delete is confirmed',
            (WidgetTester tester) async {
          // arrange
          final incidents = [
            Incident(
              id: '1',
              title: 'Test Incident',
              description: 'Description',
              location: 'Location',
            ),
          ];
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => incidents);
          when(mockIncidentRepository.deleteIncident(any)).thenAnswer((_) async => null);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.delete));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Delete'));
          await tester.pumpAndSettle();

          // assert
          verify(mockIncidentRepository.deleteIncident('1')).called(1);
        });

    testWidgets('should cancel delete when cancel is pressed',
            (WidgetTester tester) async {
          // arrange
          final incidents = [
            Incident(
              id: '1',
              title: 'Test Incident',
              description: 'Description',
              location: 'Location',
            ),
          ];
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => incidents);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.delete));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Cancel'));
          await tester.pumpAndSettle();

          // assert
          verifyNever(mockIncidentRepository.deleteIncident(any));
          expect(find.text('Test Incident'), findsOneWidget); // Incident should still be visible
        });

    testWidgets('should validate required fields in add incident form',
            (WidgetTester tester) async {
          // arrange
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => []);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Submit'));
          await tester.pumpAndSettle();

          // assert
          expect(find.text('Please enter a title'), findsOneWidget);
          expect(find.text('Please enter a description'), findsOneWidget);
          verifyNever(mockIncidentRepository.addIncident(any));
        });

    testWidgets('should validate required fields in edit incident form',
            (WidgetTester tester) async {
          // arrange
          final incidents = [
            Incident(
              id: '1',
              title: 'Test Incident',
              description: 'Description',
              location: 'Location',
            ),
          ];
          when(mockIncidentRepository.getAllIncidents()).thenAnswer((_) async => incidents);

          // act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.edit));
          await tester.pumpAndSettle();

          // Clear all fields
          await tester.enterText(find.widgetWithText(TextField, 'Title'), '');
          await tester.enterText(find.widgetWithText(TextField, 'Description'), '');
          await tester.enterText(find.widgetWithText(TextField, 'Location'), '');

          await tester.tap(find.text('Update'));
          await tester.pumpAndSettle();

          // assert
          expect(find.text('Please enter a title'), findsOneWidget);
          expect(find.text('Please enter a description'), findsOneWidget);
          verifyNever(mockIncidentRepository.updateIncident(any));
        });
  });
}