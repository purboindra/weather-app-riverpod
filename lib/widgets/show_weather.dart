import 'package:flutter/material.dart';
import 'package:weather_app_riverpod/models/current_weather/app_weather.dart';
import 'package:weather_app_riverpod/pages/home/providers/weather_state.dart';
import 'package:weather_app_riverpod/widgets/format_text.dart';
import 'package:weather_app_riverpod/widgets/select_city.dart';
import 'package:weather_app_riverpod/widgets/show_icon.dart';
import 'package:weather_app_riverpod/widgets/show_temprature.dart';

class ShowWeather extends StatefulWidget {
  const ShowWeather({super.key, required this.weatherState});

  final WeatherState weatherState;

  @override
  State<ShowWeather> createState() => _ShowWeatherState();
}

class _ShowWeatherState extends State<ShowWeather> {
  Widget prevWeatherWidget = const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final weatherState = widget.weatherState;
    switch (weatherState.status) {
      case WeatherStatus.initial:
        return const SelectCity();

      case WeatherStatus.loading:
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );

      case WeatherStatus.success:
        final appWeather =
            AppWeather.fromCurrentWeather(weatherState.currentWeather!);
        prevWeatherWidget = ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              appWeather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(TimeOfDay.fromDateTime(DateTime.now()).format(context)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '(${appWeather.country})',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTemprature(
                  temprature: appWeather.temp,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    ShowTemprature(
                      temprature: appWeather.tempMax,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ShowTemprature(
                      temprature: appWeather.tempMin,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShowIcon(icon: appWeather.icon),
                Expanded(
                  flex: 3,
                  child: FormatText(description: appWeather.description),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
        return prevWeatherWidget;
      case WeatherStatus.failure:
        return prevWeatherWidget is SizedBox
            ? const SelectCity()
            : prevWeatherWidget;
      default:
        return const SizedBox();
    }
  }
}
