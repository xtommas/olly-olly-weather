import 'package:drift/drift.dart';

import 'database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<int> createUser(String username, String passwordHash) {
    return into(users).insert(
      UsersCompanion.insert(username: username, passwordHash: passwordHash),
    );
  }

  Future<User?> getUserByUsername(String username) {
    return (select(
      users,
    )..where((u) => u.username.equals(username))).getSingleOrNull();
  }
}
