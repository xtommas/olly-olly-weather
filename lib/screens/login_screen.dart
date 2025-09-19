import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class PlaceholderLoginScreen extends StatefulWidget {
  const PlaceholderLoginScreen({super.key});

  @override
  State<PlaceholderLoginScreen> createState() => _PlaceholderLoginScreenState();
}

class _PlaceholderLoginScreenState extends State<PlaceholderLoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String message = '';

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Auth Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  final success = await auth.signUp(username, password);
                  setState(() {
                    if (success) {
                      message = 'Sign up successful for "$username"';
                    } else {
                      message = 'Sign up failed: user already exists';
                    }
                  });
                },
                child: const Text('Sign Up'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  final success = await auth.login(username, password);
                  setState(() {
                    if (success) {
                      message = 'Login successful for "$username"';
                    } else {
                      message =
                          'Login failed: user not found or wrong password';
                    }
                  });
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
