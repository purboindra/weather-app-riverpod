import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app_riverpod/pages/temp_setting/providers/temo_setting_state.dart';

part 'temp_setting_provider.g.dart';

@Riverpod(keepAlive: true)
class TempSettings extends _$TempSettings {
  @override
  TempSettingsState build() {
    ref.onDispose(() {});
    return const Celcius();
  }

  void toggleTempUnit() {
    state = switch (state) {
      Celcius() => const Fahrenheit(),
      Fahrenheit() => const Celcius(),
    };
  }
}
