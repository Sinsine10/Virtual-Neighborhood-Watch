import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neihborhoodwatch/features/auth/data/models/RegisterRequest.dart';
import 'package:neihborhoodwatch/features/auth/data/models/RegisterResponse.dart';
import 'package:neihborhoodwatch/features/auth/domain/repositories/auth_repository.dart';
import 'package:neihborhoodwatch/features/auth/domain/usecases/register_usecase.dart';


// Mock class for AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUseCase registerUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  test('should return RegisterResponse when register is successful', () async {
    // Arrange
    final registerRequest = RegisterRequest(
      email: 'test@example.com',
      password: 'password123',
      username: 'testuser', location: '',
    );

    final registerResponse = RegisterResponse(
      success: true,
      message: 'Registration successful',
    );

    when(() => mockAuthRepository.register(registerRequest))
        .thenAnswer((_) async => registerResponse);

    // Act
    final result = await registerUseCase.call(registerRequest);

    // Assert
    expect(result, isA<RegisterResponse>());
    expect(result.success, true);
    expect(result.message, 'Registration successful');
    verify(() => mockAuthRepository.register(registerRequest)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
