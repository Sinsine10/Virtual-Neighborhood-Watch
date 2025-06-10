import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neihborhoodwatch/features/auth/presentation/pages/home_screen.dart';
import 'package:neihborhoodwatch/features/auth/presentation/pages/login_screen.dart';
import 'package:neihborhoodwatch/features/auth/presentation/pages/register_screen.dart';

import 'package:neihborhoodwatch/features/auth/presentation/providers/usecase_provider.dart';

void main() {
  testWidgets('Authentication flow integration test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: NeighbourhoodWatchApp(),
        ),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify we start at the home screen
    expect(find.text('Neighbourhood Watch'), findsOneWidget);

    // Look for login and register buttons more specifically
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(2));

    // Test login navigation - find button by key or text
    final loginButton = find.byWidgetPredicate(
            (widget) => widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'Login'
    );

    if (loginButton.evaluate().isNotEmpty) {
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    }

    // Verify we're on the login screen
    expect(find.byType(LoginScreen), findsOneWidget);

    // Test login form - find text fields more reliably
    final textFields = find.byType(TextFormField);
    expect(textFields, findsAtLeastNWidgets(2));

    if (textFields.evaluate().length >= 2) {
      await tester.enterText(textFields.at(0), 'test@example.com');
      await tester.enterText(textFields.at(1), 'password123');

      // Find and tap login button
      final submitButton = find.byWidgetPredicate(
              (widget) => widget is ElevatedButton &&
              widget.child is Text &&
              (widget.child as Text).data == 'Login'
      );

      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
      }
    }

    // Test register navigation
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Verify we're on the register screen
    expect(find.byType(TextFormField), findsNWidgets(3)); // Name, Email, Password
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget); // Location


    // Test registration form
    await tester.enterText(find.byType(TextFormField).at(0), 'newuser@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'newpassword123');
    await tester.enterText(find.byType(TextFormField).at(2), 'newpassword123');
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();




    // Verify we're back at the home screen
    expect(find.text('Neighbourhood Watch'), findsOneWidget);
  });

  testWidgets('Authentication error handling', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: NeighbourhoodWatchApp(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Test login with invalid credentials
    final loginButton = find.byWidgetPredicate(
            (widget) => widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'Login'
    );

    if (loginButton.evaluate().isNotEmpty) {
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    }

    final textFields = find.byType(TextFormField);
    if (textFields.evaluate().length >= 2) {
      await tester.enterText(textFields.at(0), 'invalid@example.com');
      await tester.enterText(textFields.at(1), 'wrongpassword');

      final submitButton = find.byWidgetPredicate(
              (widget) => widget is ElevatedButton &&
              widget.child is Text &&
              (widget.child as Text).data == 'Login'
      );

      if (submitButton.evaluate().isNotEmpty) {
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
      }
    }

    // Verify error message is shown
    expect(find.text('Invalid email or password'), findsOneWidget);

    // Test registration with mismatched passwords
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'newuser@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'differentpassword');
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Verify password mismatch error
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
} 