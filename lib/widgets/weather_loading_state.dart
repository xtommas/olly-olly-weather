import 'package:flutter/material.dart';

class WeatherLoadingState extends StatelessWidget {
  const WeatherLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircularProgressIndicator(color: Colors.white),
        SizedBox(height: 24),
        Text(
          'Getting your weather...',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}
