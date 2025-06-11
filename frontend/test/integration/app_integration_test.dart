import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/Admin_Tip_screen.dart';
import 'package:neihborhoodwatch/main.dart';
import 'package:neihborhoodwatch/features/auth/presentation/pages/login_screen.dart';
import 'package:neihborhoodwatch/features/incident/presentation/pages/main_user_screen.dart';
import 'package:neihborhoodwatch/features/tip/presentation/pages/main_Admin_screen.dart';

void main() {
  testWidgets('Complete app flow integration test', (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Test initial app state
    expect(find.text('Neighbourhood Watch'), findsOneWidget);

    // Test login flow
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Login as admin
    await tester.enterText(find.byType(TextFormField).first, 'admin@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'admin123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify admin dashboard
    expect(find.byType(MainAdminScreen), findsOneWidget);
    expect(find.text('Welcome Back, User'), findsOneWidget);

    // Test admin features
    // 1. Tips Management
    await tester.tap(find.text('Tips'));
    await tester.pumpAndSettle();
    expect(find.byType(AdminTipScreen), findsOneWidget);

    // Add a new tip
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'New Safety Tip');
    await tester.tap(find.text('Add Tip'));
    await tester.pumpAndSettle();
    expect(find.text('New Safety Tip'), findsOneWidget);

    // Navigate back to admin dashboard
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 2. Previous Incidents
    await tester.tap(find.text('Previous Incidents'));
    await tester.pumpAndSettle();
    expect(find.text('Previous Incidents'), findsOneWidget);

    // Navigate back to admin dashboard
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 3. Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // Logout
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Verify back to login screen
    expect(find.byType(LoginScreen), findsOneWidget);

    // Login as regular user
    await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'user123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify user dashboard
    expect(find.byType(MainUserScreen), findsOneWidget);
    expect(find.text('Welcome Back Username'), findsOneWidget);

    // Test user features
    // 1. Report Incident
    await tester.tap(find.text('Report Incidents'));
    await tester.pumpAndSettle();
    expect(find.text('Report Incidents'), findsOneWidget);

    // Add new incident
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Incident');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test Description');
    await tester.tap(find.text('6 kilo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('submit'));
    await tester.pumpAndSettle();
    expect(find.text('Test Incident'), findsOneWidget);

    // Navigate back to user dashboard
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 2. View Tips
    await tester.tap(find.text('Tips'));
    await tester.pumpAndSettle();
    expect(find.text('Tips'), findsOneWidget);
    expect(find.text('New Safety Tip'), findsOneWidget);

    // Navigate back to user dashboard
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 3. Emergency Contacts
    await tester.tap(find.text('Emergency Contact'));
    await tester.pumpAndSettle();
    expect(find.text('Emergency Contact'), findsOneWidget);

    // Navigate back to user dashboard
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 4. Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // Logout
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Verify back to login screen
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Navigation and state persistence', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Login as user
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'user123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Test navigation drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify drawer items
    expect(find.text('Report Incidents'), findsOneWidget);
    expect(find.text('Previous Incidents'), findsOneWidget);
    expect(find.text('Tips'), findsOneWidget);
    expect(find.text('Emergency Contact'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Test navigation through drawer
    await tester.tap(find.text('Tips'));
    await tester.pumpAndSettle();
    expect(find.text('Tips'), findsOneWidget);

    // Test back navigation
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(MainUserScreen), findsOneWidget);
  });
} 