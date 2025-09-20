import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final Map<String, User> _users = {
    'admin@example.com': User(
      id: 1,
      email: 'admin@example.com',
      passwordHash: BCrypt.hashpw('admin', BCrypt.gensalt()),
    ),
    'tomas@example.com': User(
      id: 2,
      email: 'tomas@example.com',
      passwordHash: BCrypt.hashpw('dontdothisinprod', BCrypt.gensalt()),
    ),
  };

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<bool> signUp(String email, String password) async {
    if (_users.containsKey(email)) {
      return false;
    }

    final newUser = User(
      id: _users.length + 1,
      email: email,
      passwordHash: BCrypt.hashpw(password, BCrypt.gensalt()),
    );

    _users[email] = newUser;
    _currentUser = newUser;
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = _users[email];

      if (user != null && BCrypt.checkpw(password, user.passwordHash)) {
        _currentUser = user;
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Mainly for tests
  List<User> get allUsers => _users.values.toList();
  bool userExists(String email) => _users.containsKey(email);
}
