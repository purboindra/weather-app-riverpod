import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_riverpod/constants/constants.dart';
import 'package:weather_app_riverpod/models/current_weather/app_weather.dart';
import 'package:weather_app_riverpod/pages/home/providers/theme_provider.dart';
import 'package:weather_app_riverpod/pages/home/providers/theme_state.dart';
import 'package:weather_app_riverpod/pages/home/providers/weather_provider.dart';
import 'package:weather_app_riverpod/pages/home/providers/weather_state.dart';
import 'package:weather_app_riverpod/pages/search/search_page.dart';
import 'package:weather_app_riverpod/pages/temp_setting/temp_setting.dart';
import 'package:weather_app_riverpod/services/providers/weather_api_services_provider.dart';
import 'package:weather_app_riverpod/widgets/error_dialog.dart';
import 'package:weather_app_riverpod/widgets/show_weather.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? city;
  bool loading = false;

  @override
  void initState() {
    getInitialLocation();
    super.initState();
  }

  void showGeoLocationError(String errorMessage) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMessage using $kDefaultLocation')));
    });
  }

  Future<bool> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      showGeoLocationError('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        showGeoLocationError('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      showGeoLocationError(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  void getInitialLocation() async {
    final bool permitted = await getLocationPermission();
    if (permitted) {
      try {
        setState(() {
          loading = true;
        });
        final pos = await Geolocator.getCurrentPosition();
        city = await ref
            .read(weatherApiServicesProvider)
            .getReverseGeocoding(pos.latitude, pos.longitude);
      } catch (e) {
        city = kDefaultLocation;
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      city = kDefaultLocation;
    }
    ref.read(weatherProvider.notifier).fetchWeather(city!);
  }

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
      body: loading
          ? const CircularProgressIndicator.adaptive()
          : ShowWeather(weatherState: weatherState),
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
