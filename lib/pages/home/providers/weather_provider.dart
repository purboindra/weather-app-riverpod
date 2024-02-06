import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_app_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_app_riverpod/pages/home/providers/weather_state.dart';
import 'package:weather_app_riverpod/repositories/providers/weather_repository_provider.dart';

part 'weather_provider.g.dart';

@riverpod
class Weather extends _$Weather {
  @override
  WeatherState build() {
    return const WeatherStateInitial();
  }

  Future<void> fetchWeather(String city) async {
    state = const WeatherStateLoading();

    try {
      final currentWeather =
          await ref.read(weatherRepositoryProvider).fetchWeather(city);
      state = WeatherStateSuccess(currentWeather: currentWeather);
    } on CustomError catch (e) {
      state = WeatherStateFailure(error: e);
    }
  }
}

// @riverpod
// class Weather extends _$Weather {
//   @override
//   FutureOr<CurrentWeather?> build() {
//     return Future<CurrentWeather?>.value(null);
//   }

//   Future<void> fetchWeather(String city) async {
//     state = const AsyncLoading();

//     state = await AsyncValue.guard(() async {
//       final currentWeather =
//           await ref.read(weatherRepositoryProvider).fetchWeather(city);
//       return currentWeather;
//     });
//   }
// }
