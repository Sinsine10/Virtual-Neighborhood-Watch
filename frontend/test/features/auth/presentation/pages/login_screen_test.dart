import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neihborhoodwatch/features/auth/domain/entities/user.dart';
import 'package:neihborhoodwatch/features/auth/domain/repositories/auth_repository.dart';
import 'package:neihborhoodwatch/features/auth/domain/usecases/login_usecase.dart';
import 'package:neihborhoodwatch/features/auth/domain/usecases/register_usecase.dart';
import 'package:neihborhoodwatch/features/auth/presentation/pages/login_screen.dart';
import 'package:neihborhoodwatch/features/auth/presentation/providers/auth_provider.dart';
import 'package:neihborhoodwatch/features/auth/data/models/LoginRequest.dart';

@GenerateMocks([AuthRepository])
import 'login_screen_test.mocks.dart';

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
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('should show login form with email and password fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should show error message when login fails', (tester) async {
      final request = LoginRequest(email: 'test@example.com', password: 'wrongpassword');

      when(mockAuthRepository.login(argThat(
        isA<LoginRequest>()
            .having((r) => r.email, 'email', request.email)
            .having((r) => r.password, 'password', request.password),
      ))).thenThrow(Exception('Invalid credentials'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Email'), request.email);
      await tester.enterText(find.widgetWithText(TextField, 'Password'), request.password);
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Exception: Invalid credentials'), findsOneWidget);
    });

    testWidgets('should navigate to user screen when user logs in', (tester) async {
      final request = LoginRequest(email: 'user@example.com', password: 'userpass');

      when(mockAuthRepository.login(argThat(
        isA<LoginRequest>()
            .having((r) => r.email, 'email', request.email)
            .having((r) => r.password, 'password', request.password),
      ))).thenAnswer(
            (_) async => User(accessToken: 'token', role: 'user'),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Email'), request.email);
      await tester.enterText(find.widgetWithText(TextField, 'Password'), request.password);
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      verify(mockAuthRepository.login(argThat(
        isA<LoginRequest>()
            .having((r) => r.email, 'email', request.email)
            .having((r) => r.password, 'password', request.password),
      ))).called(1);

      expect(find.text('Login'), findsNothing); // Ensures screen changed
    });

    testWidgets('should validate required fields before login', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      verifyNever(mockAuthRepository.login(any));
    });
  });
}
