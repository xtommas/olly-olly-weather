import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';

import '../data/database.dart';
import '../data/user_dao.dart';

class AuthService extends ChangeNotifier {
  final UserDao userDao;
  User? _currentUser;

  AuthService(this.userDao);

  User? get currentUser => _currentUser;

  Future<bool> signUp(String username, String password) async {
    final existing = await userDao.getUserByUsername(username);

    // username is taken
    if (existing != null) {
      return false;
    }

    final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
    await userDao.createUser(username, passwordHash);

    _currentUser = await userDao.getUserByUsername(username);
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    final user = await userDao.getUserByUsername(username);

    // user exists and the password is correct
    if (user != null && BCrypt.checkpw(password, user.passwordHash)) {
      _currentUser = user;
      notifyListeners();
      return true;
    }

    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
