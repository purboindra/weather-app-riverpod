import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_riverpod/constants/constants.dart';
import 'package:weather_app_riverpod/models/current_weather/app_weather.dart';
import 'package:weather_app_riverpod/pages/home/providers/theme_provider.dart';
import 'package:weather_app_riverpod/pages/home/providers/theme_state.dart';
import 'package:weather_app_riverpod/pages/home/providers/weather_provider.dart';
import 'package:weather_app_riverpod/pages/home/providers/weather_state.dart';
import 'package:weather_app_riverpod/pages/search/search_page.dart';
import 'package:weather_app_riverpod/pages/temp_setting/temp_setting.dart';
import 'package:weather_app_riverpod/widgets/error_dialog.dart';
import 'package:weather_app_riverpod/widgets/show_weather.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? city;

  @override
  Widget build(BuildContext context) {
    ref.listen<WeatherState>(weatherProvider, (previous, next) {
      switch (next.status) {
        case WeatherStatus.failure:
          errorDialog(context, next.error.errorMessage);
          break;
        case WeatherStatus.success:
          final weather = AppWeather.fromCurrentWeather(next.currentWeather!);
          if (weather.temp < kWarmOrNot) {
            ref.read(themeProvider.notifier).changeTheme(const DarkTheme());
          } else {
            ref.read(themeProvider.notifier).changeTheme(const LightTheme());
          }
        case _:
      }
    });

    final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        actions: [
          IconButton(
              onPressed: () async {
                city = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
                if (city != null) {
                  ref.read(weatherProvider.notifier).fetchWeather(city!);
                }
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TempSettingPage(),
                ));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ShowWeather(weatherState: weatherState),
      floatingActionButton: FloatingActionButton(
        onPressed: city == null
            ? null
            : () {
                ref.read(weatherProvider.notifier).fetchWeather(city!);
              },
      ),
    );
  }
}
