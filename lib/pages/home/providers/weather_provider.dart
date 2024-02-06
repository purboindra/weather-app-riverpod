import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_app_riverpod/pages/home/providers/weather_state.dart';
import 'package:weather_app_riverpod/repositories/providers/weather_repository_provider.dart';

part 'weather_provider.g.dart';

@riverpod
class Weather extends _$Weather {
  @override
  WeatherState build() {
    return WeatherState.initial();
  }

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(
      status: WeatherStatus.loading,
    );

    try {
      final currentWeather =
          await ref.read(weatherRepositoryProvider).fetchWeather(city);
      state = state.copyWith(
          status: WeatherStatus.success, currentWeather: currentWeather);
    } on CustomError catch (e) {
      state = state.copyWith(
        status: WeatherStatus.failure,
        currentWeather: null,
        error: e,
      );
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
