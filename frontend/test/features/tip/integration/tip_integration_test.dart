import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/main_Admin_screen.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/Admin_Tip_screen.dart';
import 'package:neihborhoodwatch/features/incident/presentation/pages/tips_page.dart';

void main() {
  testWidgets('Admin tips management flow', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MainAdminScreen(username: 'Admin'),
        ),
      ),
    );

    // Verify we're on the admin screen
    expect(find.text('Welcome Back, User'), findsOneWidget);
    expect(find.text('Tips'), findsOneWidget);

    // Navigate to tips management
    await tester.tap(find.text('Tips'));
    await tester.pumpAndSettle();

    // Verify we're on the tips screen
    expect(find.byType(AdminTipScreen), findsOneWidget);

    // Test adding a new tip
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill in tip form
    await tester.enterText(find.byType(TextFormField), 'New Safety Tip');
    await tester.tap(find.text('Add Tip'));
    await tester.pumpAndSettle();

    // Verify tip was added
    expect(find.text('New Safety Tip'), findsOneWidget);
  });

  testWidgets('User tips view', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TipsPage(),
        ),
      ),
    );

    // Verify tips page elements
    expect(find.text('Tips'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    // Verify tip cards are displayed
    expect(find.text('Make sure to lock your doors before you go to bed'), findsOneWidget);
    expect(find.text('Take care when standing in line'), findsOneWidget);
    expect(find.text('Be careful who you ask for directions'), findsOneWidget);
  });

  testWidgets('Admin tip management features', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AdminTipScreen(),
        ),
      ),
    );

    // Test tip editing
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Edit tip
    await tester.enterText(find.byType(TextFormField), 'Updated Safety Tip');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify update
    expect(find.text('Updated Safety Tip'), findsOneWidget);

    // Test tip deletion
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify deletion
    expect(find.text('Updated Safety Tip'), findsNothing);
  });
} 