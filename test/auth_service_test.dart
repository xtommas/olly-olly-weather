import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    tearDown(() {
      authService.logout(); // Clean up after each test
    });

    group('Login Tests', () {
      test('should login successfully with valid credentials', () async {
        // Act
        final result = await authService.login('tomas', 'dontdothisinprod');

        // Assert
        expect(result, isTrue);
        expect(authService.currentUser, isNotNull);
        expect(authService.currentUser?.username, equals('tomas'));
      });

      test('should fail login with invalid username', () async {
        // Act
        final result = await authService.login(
          'nonexistentuser',
          'password123',
        );

        // Assert
        expect(result, isFalse);
        expect(authService.currentUser, isNull);
      });

      test('should fail login with invalid password', () async {
        // Act
        final result = await authService.login('admin', 'wrongpassword');

        // Assert
        expect(result, isFalse);
        expect(authService.currentUser, isNull);
      });

      test('should fail login with empty credentials', () async {
        // Act
        final result1 = await authService.login('', 'password');
        final result2 = await authService.login('user', '');

        // Assert
        expect(result1, isFalse);
        expect(result2, isFalse);
        expect(authService.currentUser, isNull);
      });
    });

    group('Sign Up Tests', () {
      test('should create new user with valid credentials', () async {
        // Act
        final result = await authService.signUp('newuser', 'newpassword123');

        // Assert
        expect(result, isTrue);
        expect(authService.currentUser, isNotNull);
        expect(authService.currentUser?.username, equals('newuser'));

        // Verify password was hashed
        expect(
          authService.currentUser?.passwordHash,
          isNot(equals('newpassword123')),
        );
        expect(
          BCrypt.checkpw(
            'newpassword123',
            authService.currentUser!.passwordHash,
          ),
          isTrue,
        );
      });

      test('should fail signup with existing username', () async {
        // Act
        final result = await authService.signUp('tomas', 'dontdothisinprod');

        // Assert
        expect(result, isFalse);
        expect(authService.currentUser, isNull);
      });

      test('should assign unique IDs to new users', () async {
        // Act
        await authService.signUp('user1', 'password1');
        final user1Id = authService.currentUser?.id;
        authService.logout();

        await authService.signUp('user2', 'password2');
        final user2Id = authService.currentUser?.id;

        // Assert
        expect(user1Id, isNotNull);
        expect(user2Id, isNotNull);
        expect(user1Id, isNot(equals(user2Id)));
      });

      test('should be able to login after signup', () async {
        // Arrange
        const username = 'signup-then-login';
        const password = 'testpassword';

        // Act
        final signupResult = await authService.signUp(username, password);
        authService.logout();
        final loginResult = await authService.login(username, password);

        // Assert
        expect(signupResult, isTrue);
        expect(loginResult, isTrue);
        expect(authService.currentUser?.username, equals(username));
      });
    });

    group('Logout Tests', () {
      test('should clear current user on logout', () async {
        // Arrange
        await authService.login('admin', 'admin');
        expect(authService.currentUser, isNotNull);

        // Act
        authService.logout();

        // Assert
        expect(authService.currentUser, isNull);
      });

      test('should handle logout when no user is logged in', () {
        // Act & Assert (should not throw)
        expect(() => authService.logout(), returnsNormally);
        expect(authService.currentUser, isNull);
      });
    });

    group('Utility Method Tests', () {
      test('userExists should return true for existing users', () {
        // Act & Assert
        expect(authService.userExists('admin'), isTrue);
        expect(authService.userExists('tomas'), isTrue);
        expect(authService.userExists('nonexistent'), isFalse);
      });

      test('allUsers should return all registered users', () {
        // Act
        final users = authService.allUsers;

        // Assert
        expect(
          users.length,
          greaterThanOrEqualTo(2),
        ); // At least the 2 default users
        expect(users.map((u) => u.username), contains('tomas'));
        expect(users.map((u) => u.username), contains('admin'));
      });
    });

    group('ChangeNotifier Tests', () {
      test('should notify listeners on successful login', () async {
        // Arrange
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        // Act
        await authService.login('tomas', 'dontdothisinprod');

        // Assert
        expect(notificationCount, equals(1));
      });

      test('should notify listeners on successful signup', () async {
        // Arrange
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        // Act
        await authService.signUp('newnewuser', 'password123');

        // Assert
        expect(notificationCount, equals(1));
      });

      test('should notify listeners on logout', () async {
        // Arrange
        await authService.login('tomas', 'dontdothisinprod');
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        // Act
        authService.logout();

        // Assert
        expect(notificationCount, equals(1));
      });

      test('should not notify listeners on failed login', () async {
        // Arrange
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        // Act
        await authService.login('tomas', 'wrongpassword');

        // Assert
        expect(notificationCount, equals(0));
      });
    });
  });
}
