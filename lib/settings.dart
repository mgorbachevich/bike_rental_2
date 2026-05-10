final Settings settings = Settings(); // Singleton

class Settings {
  static final Settings _instance = Settings._internal();

  Settings._internal();

  factory Settings() {
    return _instance;
  }

  bool clearAllBoxes = true; // Очистка БД перед запуском
  bool clearRentalBox = false; // Очистка только истории перед запуском
  int maxBookingMinutes = 60;
}
