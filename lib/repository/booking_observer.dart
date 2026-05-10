import 'dart:async';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:bike_rental_2/settings.dart';
import 'package:flutter/material.dart';

// Паттерн Обозреватель.
// Оповещение о истечении времени бронирования
final BookingObserver bookingObserver = BookingObserver(); // Singleton

class BookingObserver extends ChangeNotifier {
  static final BookingObserver _instance = BookingObserver._internal();

  static const int timerSeconds = 30;

  BookingObserver._internal() {
    // Запуск таймера в конструкторе:
    Timer.periodic(const Duration(seconds: timerSeconds), (v) {
      if (repository.activeRental != null &&
          repository.activeRental!.booking &&
          repository.activeRental!.start != null &&
          repository.activeRental!.finish == null &&
          DateTime.now().difference(repository.activeRental!.start!).inSeconds >
              settings.maxBookingMinutes * 60) {
        notifyListeners();
      }
    });
  }

  factory BookingObserver() {
    return _instance;
  }
}
