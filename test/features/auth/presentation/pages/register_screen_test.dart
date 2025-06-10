import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/auth/data/models/RegisterResponse.dart';

import 'package:neihborhoodwatch/features/auth/domain/entities/user.dart';
import 'package:neihborhoodwatch/features/auth/domain/repositories/auth_repository.dart';
import 'package:neihborhoodwatch/features/auth/domain/usecases/login_usecase.dart';
import 'package:neihborhoodwatch/features/auth/domain/usecases/register_usecase.dart';
import 'package:neihborhoodwatch/features/auth/presentation/pages/register_screen.dart';
import 'package:neihborhoodwatch/features/auth/presentation/providers/auth_provider.dart';

@GenerateMocks([AuthRepository])
import 'register_screen_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authStateProvider.overrideWith(
              (ref) => AuthNotifier(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
      ],
      child: const MaterialApp(
        home: RegisterScreen(),
      ),
    );
  }

  group('RegisterScreen Widget Tests', () {
    testWidgets('should show registration form with all required fields',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          expect(find.text('Name'), findsOneWidget);
          expect(find.text('Email'), findsOneWidget);
          expect(find.text('Password'), findsOneWidget);
          expect(find.text('Location'), findsOneWidget);
          expect(find.byType(TextField), findsNWidgets(3));
          expect(find.byType(DropdownButtonFormField), findsOneWidget);
          expect(find.text('Register'), findsOneWidget);
        });

    testWidgets('should show loading indicator when registration is in progress',
            (WidgetTester tester) async {
          when(mockAuthRepository.register(any)).thenAnswer(
                (_) => Future.delayed(const Duration(seconds: 1), () => RegisterResponse(success: true, message: 'Success')),
          );

          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.tap(find.byType(DropdownButtonFormField));
          await tester.pumpAndSettle();
          await tester.tap(find.text('6 Kilo').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Register'));
          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.text('Register'), findsNothing);
        });

    testWidgets('should show error message when registration fails',
            (WidgetTester tester) async {
          when(mockAuthRepository.register(any)).thenThrow(Exception('Email already exists'));

          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'existing@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.tap(find.byType(DropdownButtonFormField));
          await tester.pumpAndSettle();
          await tester.tap(find.text('6 Kilo').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          expect(find.text('Exception: Email already exists'), findsOneWidget);
        });

    testWidgets('should validate required fields before registration',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          verifyNever(mockAuthRepository.register(any));
        });

    testWidgets('should navigate after successful registration',
            (WidgetTester tester) async {
          when(mockAuthRepository.register(any)).thenAnswer(
                (_) async => RegisterResponse(success: true, message: 'Account created'),
          );

          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.enterText(find.widgetWithText(TextField, 'Name'), 'New User');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'new@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.tap(find.byType(DropdownButtonFormField));
          await tester.pumpAndSettle();
          await tester.tap(find.text('6 Kilo').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          verify(mockAuthRepository.register(any)).called(1);
        });

    testWidgets('should show error for invalid email format',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'invalid-email');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.tap(find.byType(DropdownButtonFormField));
          await tester.pumpAndSettle();
          await tester.tap(find.text('6 Kilo').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          verifyNever(mockAuthRepository.register(any));
        });

    testWidgets('should show error for short password',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), '123');
          await tester.tap(find.byType(DropdownButtonFormField));
          await tester.pumpAndSettle();
          await tester.tap(find.text('6 Kilo').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          verifyNever(mockAuthRepository.register(any));
        });

    testWidgets('should show error when location is not selected',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          verifyNever(mockAuthRepository.register(any));
        });

    testWidgets('should clear error message when retrying registration',
            (WidgetTester tester) async {
          bool hasRetried = false;

          when(mockAuthRepository.register(any)).thenAnswer((_) async {
            if (!hasRetried) {
              hasRetried = true;
              throw Exception('Email already exists');
            } else {
              return RegisterResponse(success: true, message: 'Account created');
            }
          });

          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test User');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'existing@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.tap(find.byType(DropdownButtonFormField));
          await tester.pumpAndSettle();
          await tester.tap(find.text('6 Kilo').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          expect(find.text('Exception: Email already exists'), findsOneWidget);

          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'new@example.com');
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();

          expect(find.text('Exception: Email already exists'), findsNothing);
        });
  });
}
