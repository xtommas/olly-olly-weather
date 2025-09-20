import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService();
  Weather? _weather;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isCelsius = true;

  // Choose proper animation based on weather condition
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }

    // https://openweathermap.org/weather-conditions
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
        return 'assets/partly-shower.json'; // Fixed typo: was 'aseets'
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
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentPosition = await _weatherService.getCurrentLocation();
      final unit = _isCelsius ? 'metric' : 'imperial';

      final weatherData = await _weatherService.getWeather(
        currentPosition.latitude,
        currentPosition.longitude,
        unit,
      );

      setState(() {
        _weather = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleLogout(AuthService authService) {
    authService.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget _buildUnitToggle(String label, bool isCelsius) {
    final isSelected = _isCelsius == isCelsius;
    return GestureDetector(
      onTap: () {
        if (_isCelsius != isCelsius) {
          setState(() => _isCelsius = isCelsius);
          _loadWeatherData();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    final cardWidth = isDesktop ? 400.0 : screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with user info and logout
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          user?.email ?? 'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _handleLogout(authService),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    tooltip: 'Log out',
                  ),
                ],
              ),
            ),

            // Expanded area to center the card
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: cardWidth,
                    constraints: BoxConstraints(maxWidth: 450),
                    child: Card(
                      color: Colors.grey[900],
                      elevation: 12,
                      shadowColor: Colors.black.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isLoading) ...[
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Getting your weather...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],

                            if (_errorMessage != null) ...[
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 64,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Oops! Something went wrong',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _loadWeatherData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Try Again'),
                              ),
                            ],

                            if (!_isLoading &&
                                _errorMessage == null &&
                                _weather != null) ...[
                              // City
                              Text(
                                _weather?.cityName ?? 'Unknown Location',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 32),

                              // Weather icon animation
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: Lottie.asset(
                                  getWeatherAnimation(_weather?.mainCondition),
                                  fit: BoxFit.contain,
                                ),
                              ),

                              // Temperature
                              Text(
                                '${_weather!.temperature.round()}°${_isCelsius ? 'C' : 'F'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),

                              // Main Condition
                              Text(
                                _weather?.mainCondition ?? '',
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.8,
                                ),
                              ),

                              const SizedBox(height: 50),

                              // Row for the refresh and toggle buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Refresh button
                                  TextButton.icon(
                                    onPressed: _loadWeatherData,
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Refresh',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),

                                  // Temperature unit toggle
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildUnitToggle('°C', true),
                                        _buildUnitToggle('°F', false),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
