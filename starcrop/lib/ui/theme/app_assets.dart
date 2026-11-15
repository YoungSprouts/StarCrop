/// Central registry of every bundled asset path, so screens never hardcode
/// strings. Update here if a file is renamed.
class AppIcons {
  AppIcons._();

  // Home
  static const skyChart = 'assets/icons/home/sky_chart_icon.png';
  static const farmerGuide = 'assets/icons/home/farmer_guide_icon.png';
  static const activities = 'assets/icons/home/activities_icon.png';
  static const weather = 'assets/icons/home/weather_icon.png';

  // Farmer guidance
  static const plant = 'assets/icons/farmer_guidance/plant.png';
  static const spray = 'assets/icons/farmer_guidance/spray_icon.png';
  static const harvest = 'assets/icons/farmer_guidance/harvest_icon.png';
  static const prepare = 'assets/icons/farmer_guidance/prepare_icon.png';
  static const note = 'assets/icons/farmer_guidance/note_icon.png';
  static const user = 'assets/icons/farmer_guidance/user_icon.png';
  static const shieldCheck = 'assets/icons/farmer_guidance/shield_check_icon.png';
  static const addSign = 'assets/icons/farmer_guidance/add_sign_1.png';

  // Camera check
  static const cameraDark = 'assets/icons/camera/camera_icon_1b3d26.png';
  static const cameraGold = 'assets/icons/camera/camera_icon_c8aa35.png';
  static const camera = 'assets/icons/camera/camera_icon.png';
  static const camera2 = 'assets/icons/camera/camera_icon_2.png';
  static const flash = 'assets/icons/camera/flash_icon.png';
  static const gallery = 'assets/icons/camera/gallery_icon.png';
  static const scan = 'assets/icons/camera/scan.png';
  static const verified = 'assets/icons/camera/verified.png';

  // Weather
  static const sun = 'assets/icons/weather/sun.png';
  static const moon = 'assets/icons/weather/moon.png';
  static const cloudy = 'assets/icons/weather/cloudy.png';
  static const partlyRainy = 'assets/icons/weather/partly_rainy.png';
  static const lightRain = 'assets/icons/weather/light_rain.png';
  static const waterDrop2 = 'assets/icons/weather/water_drop_2.png';
  static const waterDrop3 = 'assets/icons/weather/water_drop_3.png';

  // Location
  static const locationPinWhite = 'assets/icons/location/location_pin_ffffff.png';
  static const locationPinDark = 'assets/icons/location/location_pin_1b3d26.png';
  static const locationPinGold = 'assets/icons/location/location_pin_c8aa35.png';
  static const searchDark = 'assets/icons/location/search_icon_1b3d26.png';
  static const searchWhite = 'assets/icons/location/search_icon_ffffff.png';

  // Navigation
  static const chevronLeftDark = 'assets/icons/navigation/chevron_left_1b3d26.png';
  static const chevronLeftWhite = 'assets/icons/navigation/chevron_left_ffffff.png';
  static const chevronRightDark = 'assets/icons/navigation/chevron_right_1b3d26.png';
  static const chevronRightWhite = 'assets/icons/navigation/chevron_right_ffffff.png';
  static const settingsDark = 'assets/icons/navigation/settings_1b3d26.png';
  static const settingsWhite = 'assets/icons/navigation/settings_ffffff.png';
  static const trackerGold = 'assets/icons/navigation/tracker_c8aa35.png';
  static const trackerWhite = 'assets/icons/navigation/tracker_ffffff.png';

  // Logo
  static const logoDark = 'assets/icons/logo/logo_1b3d26.png';
  static const logoGold = 'assets/icons/logo/logo_c8aa35.png';
}

class AppImages {
  AppImages._();

  static const homeScreen = 'assets/images/homescreenimage.jpg';
  static const taurusDetail = 'assets/images/taurus_skychartdetails_image.png';
}

/// Maps a weather condition keyword (from Open-Meteo interpretation or your
/// own bucketing of rain/cloud values) to the matching bundled icon.
String weatherIconFor(String condition) {
  switch (condition) {
    case 'sun':
    case 'clear':
      return AppIcons.sun;
    case 'moon':
    case 'clear_night':
      return AppIcons.moon;
    case 'cloudy':
      return AppIcons.cloudy;
    case 'partly_rainy':
      return AppIcons.partlyRainy;
    case 'light_rain':
      return AppIcons.lightRain;
    default:
      return AppIcons.cloudy;
  }
}

/// Maps an activity_type from the Activities table to its icon.
String activityIconFor(String activityType) {
  switch (activityType) {
    case 'plant':
      return AppIcons.plant;
    case 'spray':
      return AppIcons.spray;
    case 'harvest':
      return AppIcons.harvest;
    case 'prepare':
      return AppIcons.prepare;
    default:
      return AppIcons.note;
  }
}
