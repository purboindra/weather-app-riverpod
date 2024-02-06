import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_app_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_app_riverpod/widgets/format_text.dart';
import 'package:weather_app_riverpod/widgets/select_city.dart';
import 'package:weather_app_riverpod/widgets/show_icon.dart';
import 'package:weather_app_riverpod/widgets/show_temprature.dart';

class ShowWeather extends ConsumerWidget {
  const ShowWeather({super.key, required this.weatherState});

  final AsyncValue<CurrentWeather?> weatherState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return weatherState.when(
      skipError: true,
      data: (data) {
        if (data == null) {
          return const SelectCity();
        }

        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              data.name,
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
                  '(${data.sys.country})',
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
                  temprature: data.main.temp,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    ShowTemprature(
                      temprature: data.main.tempMax,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ShowTemprature(
                      temprature: data.main.tempMin,
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
                ShowIcon(icon: data.weather[0].icon),
                Expanded(
                  flex: 3,
                  child: FormatText(description: data.weather[0].description),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        if (weatherState.value == null) {
          return const SelectCity();
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text((error as CustomError).errorMessage),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
