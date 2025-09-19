import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final Map<String, User> _users = {
    'admin': User(
      id: 1,
      username: 'admin',
      passwordHash: BCrypt.hashpw('admin', BCrypt.gensalt()),
    ),
    'tomas': User(
      id: 2,
      username: 'tomas',
      passwordHash: BCrypt.hashpw('dontdothisinprod', BCrypt.gensalt()),
    ),
  };

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<bool> signUp(String username, String password) async {
    if (_users.containsKey(username)) {
      return false;
    }

    final newUser = User(
      id: _users.length + 1,
      username: username,
      passwordHash: BCrypt.hashpw(password, BCrypt.gensalt()),
    );

    _users[username] = newUser;
    _currentUser = newUser;
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = _users[username];

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
  bool userExists(String username) => _users.containsKey(username);
}
