import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/repositories/weather_repository.dart';
import 'package:weather_app_riverpod/services/providers/weather_api_services_provider.dart';

part 'weather_repository_provider.g.dart';

@riverpod
WeatherRepository weatherRepository(WeatherRepositoryRef ref) {
  return WeatherRepository(
      weatherApiServices: ref.watch(weatherApiServicesProvider));
}
