// test/features/auth/application/usecases/login_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neihborhoodwatch/features/auth/data/models/LoginRequest.dart';
import 'package:neihborhoodwatch/features/auth/domain/entities/user.dart';
import 'package:neihborhoodwatch/features/auth/domain/repositories/auth_repository.dart';
import 'package:neihborhoodwatch/features/auth/domain/usecases/login_usecase.dart';


// 1️⃣ Mock class for AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  test('should return User when login is successful', () async {
    // Arrange
    final loginRequest = LoginRequest(email: 'test@example.com', password: 'password123');
    final user = User(
      email: 'test@example.com',
      username: 'testuser',
      role: 'user',
      accessToken: 'dummy_token',
    );

    when(() => mockAuthRepository.login(loginRequest))
        .thenAnswer((_) async => user);

    // Act
    final result = await loginUseCase.call(loginRequest);

    // Assert
    expect(result, isA<User>());
    expect(result.email, 'test@example.com');
    expect(result.accessToken, 'dummy_token');
    verify(() => mockAuthRepository.login(loginRequest)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
