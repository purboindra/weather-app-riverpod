import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_riverpod/pages/temp_setting/providers/temo_setting_state.dart';
import 'package:weather_app_riverpod/pages/temp_setting/providers/temp_setting_provider.dart';

class TempSettingPage extends StatelessWidget {
  const TempSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temp Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          title: const Text('Temprature Unit'),
          subtitle: const Text('Celcius/Fahrenheit (Default: Celcius)'),
          trailing: Consumer(builder: (context, ref, child) {
            final tempUnit = ref.watch(tempSettingsProvider);
            return Switch(
              value: switch (tempUnit) {
                Celcius() => true,
                Fahrenheit() => false,
              },
              onChanged: (_) {
                ref.read(tempSettingsProvider.notifier).toggleTempUnit();
              },
            );
          }),
        ),
      ),
    );
  }
}
