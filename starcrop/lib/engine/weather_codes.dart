/// Maps Open-Meteo WMO weather codes to (a) a key understood by
/// `weatherIconFor()` in app_assets.dart and (b) a short human label.
///
/// NOTE: the icon choices are a best guess — only 7 weather icons exist
/// (sun, moon, cloudy, partly_rainy, light_rain, 2 water drops) and the
/// artwork wasn't visible when this was written. Adjust here in one place.
String weatherConditionKey(int? code) {
  switch (code) {
    case 0:
    case 1:
      return 'sun';
    case 2:
    case 3:
    case 45:
    case 48:
      return 'cloudy';
    case 51:
    case 53:
    case 55:
    case 61:
    case 80:
      return 'partly_rainy'; // drizzle / slight rain / slight showers
    case 56:
    case 57:
    case 63:
    case 65:
    case 66:
    case 67:
    case 81:
    case 82:
    case 95:
    case 96:
    case 99:
      return 'light_rain'; // heavier rain / storms (only rain icon available)
    default:
      return 'cloudy';
  }
}

String weatherLabel(int? code) {
  switch (code) {
    case 0:
      return 'Clear skies';
    case 1:
      return 'Mostly clear';
    case 2:
      return 'Partly cloudy';
    case 3:
      return 'Overcast';
    case 45:
    case 48:
      return 'Foggy';
    case 51:
    case 53:
    case 55:
      return 'Drizzle';
    case 56:
    case 57:
    case 66:
    case 67:
      return 'Freezing rain';
    case 61:
      return 'Light rain';
    case 63:
      return 'Rain';
    case 65:
      return 'Heavy rain';
    case 80:
      return 'Light showers';
    case 81:
      return 'Showers';
    case 82:
      return 'Heavy showers';
    case 95:
      return 'Thunderstorm';
    case 96:
    case 99:
      return 'Thunderstorm, hail';
    default:
      return 'Weather';
  }
}
