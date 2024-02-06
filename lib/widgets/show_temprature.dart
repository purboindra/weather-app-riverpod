import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_riverpod/pages/temp_setting/providers/temo_setting_state.dart';
import 'package:weather_app_riverpod/pages/temp_setting/providers/temp_setting_provider.dart';

class ShowTemprature extends ConsumerWidget {
  final double temprature;
  final double fontSize;
  final FontWeight fontWeight;

  const ShowTemprature({
    super.key,
    required this.temprature,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempUnit = ref.watch(tempSettingsProvider);
    final currentTemprature = switch (tempUnit) {
      Celcius() => '${temprature.toStringAsFixed(2)}\u2103',
      Fahrenheit() => '${((temprature * 9 / 5) + 32).toStringAsFixed(2)}\u2109',
    };

    return Text(
      currentTemprature,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
