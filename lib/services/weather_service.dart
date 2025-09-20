import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  Future<Weather> getWeather(double lat, double lon, String units) async {
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&units=$units&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Couldn't load weather data");
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      throw Exception('Failed to get location from browser: $e');
    }
  }
}
