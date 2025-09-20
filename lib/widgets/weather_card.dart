import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final double width;
  final Widget child;

  const WeatherCard({super.key, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: const BoxConstraints(maxWidth: 450),
      child: Card(
        color: Colors.grey[900],
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(padding: const EdgeInsets.all(32.0), child: child),
      ),
    );
  }
}
