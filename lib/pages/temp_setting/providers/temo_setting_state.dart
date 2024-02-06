sealed class TempSettingsState {
  const TempSettingsState();
}

final class Celcius extends TempSettingsState {
  const Celcius();

  @override
  String toString() => 'Celsius';
}

final class Fahrenheit extends TempSettingsState {
  const Fahrenheit();

  @override
  String toString() => 'Fahrenheit';
}
