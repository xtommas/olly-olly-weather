import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import './home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<String?> _authUser(LoginData data, AuthService authService) async {
    final success = await authService.login(data.name, data.password);
    return success ? null : 'Invalid username or password';
  }

  Future<String?> _signUpUser(SignupData data, AuthService authService) async {
    final success = await authService.signUp(data.name!, data.password!);
    return success ? null : 'User already exists';
  }

  // Just for demo purposes, not implemented
  Future<String?> _recoverPassword(String name) async {
    return 'Check your email!';
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF6C7B7F),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF6C7B7F), // text cursor
          selectionColor: Color(0x556C7B7F), // text selection background
          selectionHandleColor: Color(0xFF6C7B7F), // handles (drag dots)
        ),
      ),
      child: FlutterLogin(
        title: 'weather',
        logo: const AssetImage('assets/cloud.png'),
        theme: LoginTheme(
          primaryColor: const Color(0xFF1A1A1A),
          accentColor: const Color(0xFF6C7B7F),
          errorColor: const Color(0xFFE57373),

          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 32,
            letterSpacing: 2.0,
          ),

          // Background styling
          pageColorLight: Colors.black,
          pageColorDark: Colors.black,

          // Card styling
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Input field styling
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C7B7F), width: 2),
            ),
            labelStyle: const TextStyle(
              color: Color(0xFF6C7B7F),
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),

          // Button styling
          buttonTheme: LoginButtonTheme(
            splashColor: Colors.transparent,
            backgroundColor: const Color(0xFF1A1A1A),
            highlightColor: const Color(0xFF2A2A2A),
            elevation: 0,
            highlightElevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Text button styling (for "Forgot Password", etc.)
          textFieldStyle: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w400,
          ),

          // Body text styling
          bodyStyle: const TextStyle(color: Color(0xFF4A5568), fontSize: 14),
        ),
        onLogin: (loginData) => _authUser(loginData, authService),
        onSignup: (signupData) => _signUpUser(signupData, authService),
        onRecoverPassword: _recoverPassword,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },

        messages: LoginMessages(
          userHint: 'Email',
          passwordHint: 'Password',
          confirmPasswordHint: 'Confirm Password',
          loginButton: 'LOG IN',
          signupButton: 'SIGN UP',
          forgotPasswordButton: 'Forgot Password?',
          recoverPasswordButton: 'RECOVER',
          goBackButton: 'BACK',
          confirmPasswordError: 'Passwords do not match!',
          recoverPasswordDescription:
              'We will send recovery instructions to your email',
          recoverPasswordSuccess: 'Recovery email sent!',
        ),
      ),
    );
  }
}
