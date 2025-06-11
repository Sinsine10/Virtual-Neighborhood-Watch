import 'package:flutter_test/flutter_test.dart';
import 'package:neihborhoodwatch/features/auth/domain/entities/user.dart';

void main() {
  test('should identify admin user correctly', () {
    final adminUser = User(
      email: 'admin@example.com',
      username: 'adminUser',
      role: 'Admin',
      accessToken: 'token123',
    );

    final normalUser = User(
      email: 'user@example.com',
      username: 'normalUser',
      role: 'User',
      accessToken: 'token456',
    );

    expect(adminUser.isAdmin, true);
    expect(normalUser.isAdmin, false);
  });

  test('should store email and access token correctly', () {
    final user = User(
      email: 'test@example.com',
      username: 'testuser',
      role: 'User',
      accessToken: 'some_token',
    );

    expect(user.email, 'test@example.com');
    expect(user.accessToken, 'some_token');
  });
}
