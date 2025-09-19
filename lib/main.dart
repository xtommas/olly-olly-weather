import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database.dart';
import 'data/user_dao.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

// made main async, which allows us to await initialization steps (like db connection)
// and also for future-proofing
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase(connect());
  final userDao = UserDao(db);
  final authService = AuthService(userDao);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        Provider<UserDao>.value(value: userDao),
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      home: const PlaceholderLoginScreen(),
    );
  }
}
