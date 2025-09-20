import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_display.dart';
import '../widgets/weather_error_state.dart';
import '../widgets/weather_header.dart';
import '../widgets/weather_loading_state.dart';

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

  void _handleUnitToggle(bool newIsCelsius) {
    if (_isCelsius != newIsCelsius) {
      setState(() => _isCelsius = newIsCelsius);
      _loadWeatherData();
    }
  }

  Widget _buildCardContent() {
    if (_isLoading) {
      return const WeatherLoadingState();
    }

    if (_errorMessage != null) {
      return WeatherErrorState(
        errorMessage: _errorMessage!,
        onRetry: _loadWeatherData,
      );
    }

    if (_weather != null) {
      return WeatherDisplay(
        weather: _weather!,
        isCelsius: _isCelsius,
        onRefresh: _loadWeatherData,
        onUnitToggle: _handleUnitToggle,
      );
    }

    return const SizedBox.shrink();
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
            WeatherHeader(
              email: user?.email ?? 'User',
              onLogout: () => _handleLogout(authService),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: WeatherCard(
                    width: cardWidth,
                    child: _buildCardContent(),
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
