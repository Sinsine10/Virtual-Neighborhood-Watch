import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neihborhoodwatch/features/incident/presentation/pages/incident_screen.dart';
import 'package:neihborhoodwatch/features/incident/presentation/pages/main_user_screen.dart';
import 'package:neihborhoodwatch/features/incident/domain/entities/incident.dart';
import 'package:neihborhoodwatch/features/incident/presentation/providers/incident_provider.dart';

void main() {
  testWidgets('Incident reporting flow integration test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MainUserScreen(),
        ),
      ),
    );

    // Verify we're on the main user screen
    expect(find.text('Welcome Back Username'), findsOneWidget);
    expect(find.text('Report Incidents'), findsOneWidget);

    // Navigate to incident reporting
    await tester.tap(find.text('Report Incidents'));
    await tester.pumpAndSettle();

    // Verify we're on the incident screen
    expect(find.text('Report Incidents'), findsOneWidget);
    expect(find.byType(UserReportsPage), findsOneWidget);

    // Test adding a new incident
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill in incident form
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Incident');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test Description');
    await tester.tap(find.text('6 kilo')); // Select location
    await tester.pumpAndSettle();
    await tester.tap(find.text('submit'));
    await tester.pumpAndSettle();

    // Verify incident was added
    expect(find.text('Test Incident'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('Incident management flow', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: UserReportsPage(),
        ),
      ),
    );

    // Test incident editing
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Edit incident details
    await tester.enterText(find.byType(TextFormField).first, 'Updated Incident');
    await tester.enterText(find.byType(TextFormField).last, 'Updated Description');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify updates
    expect(find.text('Updated Incident'), findsOneWidget);
    expect(find.text('Updated Description'), findsOneWidget);

    // Test incident deletion
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify deletion
    expect(find.text('Updated Incident'), findsNothing);
  });

  testWidgets('Previous incidents view', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MainUserScreen(),
        ),
      ),
    );

    // Navigate to previous incidents
    await tester.tap(find.text('Previous Incidents'));
    await tester.pumpAndSettle();

    // Verify previous incidents screen
    expect(find.text('Previous Incidents'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
} 