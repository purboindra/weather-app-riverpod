import 'package:weather_app_riverpod/exceptions/weather_exception.dart';
import 'package:weather_app_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_app_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_app_riverpod/services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;

  WeatherRepository({required this.weatherApiServices});

  Future<CurrentWeather> fetchWeather(String city) async {
    try {
      final directGeocoding = await weatherApiServices.getDirectGeocoding(city);

      final tempWeather = await weatherApiServices.getWeather(directGeocoding);

      final currentWeather = tempWeather.copyWith(
        name: directGeocoding.name,
        sys: tempWeather.sys.copyWith(country: directGeocoding.country),
      );

      return currentWeather;
    } on WeatherException catch (e) {
      throw CustomError(errorMessage: e.message);
    } catch (e) {
      throw CustomError(errorMessage: e.toString());
    }
  }
}
