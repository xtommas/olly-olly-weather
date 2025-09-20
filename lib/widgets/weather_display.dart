import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import 'temperature_unit_toggle.dart';

class WeatherDisplay extends StatelessWidget {
  final Weather weather;
  final bool isCelsius;
  final VoidCallback onRefresh;
  final ValueChanged<bool> onUnitToggle;

  const WeatherDisplay({
    super.key,
    required this.weather,
    required this.isCelsius,
    required this.onRefresh,
    required this.onUnitToggle,
  });

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'sand':
      case 'ash':
      case 'squall':
      case 'tornado':
        return 'assets/windy.json';
      case 'rain':
      case 'drizzle':
        return 'assets/partly-shower.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'snow':
        return 'assets/snow.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // City
        Text(
          weather.cityName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Weather animation
        SizedBox(
          height: 150,
          width: 150,
          child: Lottie.asset(
            getWeatherAnimation(weather.mainCondition),
            fit: BoxFit.contain,
          ),
        ),

        // Temperature
        Text(
          '${weather.temperature.round()}°${isCelsius ? 'C' : 'F'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 56,
            fontWeight: FontWeight.w100,
          ),
        ),

        // Condition
        Text(
          weather.mainCondition,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 50),

        // Bottom controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, color: Colors.white70, size: 18),
              label: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
            TemperatureUnitToggle(isCelsius: isCelsius, onToggle: onUnitToggle),
          ],
        ),
      ],
    );
  }
}
