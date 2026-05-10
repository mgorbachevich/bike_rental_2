final Settings settings = Settings(); // Singleton

class Settings {
  static final Settings _instance = Settings._internal();

  Settings._internal();

  factory Settings() {
    return _instance;
  }

  int maxBookingMinutes = 60;
}
