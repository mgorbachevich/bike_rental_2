import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/rental.dart';
import 'package:bike_rental_2/repository/user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Инициализация БД Hive через терминал:
// flutter pub add hive hive_flutter
// flutter pub add dev:hive_generator dev:build_runner
// dart run build_runner build

// Хранилище (БД):
final Repository repository = Repository(); // Singleton

class Repository {
  static final Repository _instance = Repository._internal();

  Repository._internal();

  factory Repository() {
    return _instance;
  }

  Box<Bike>? _bikeBox; // "Таблица" велосипедов
  Box<Rental>? _rentalBox; // "Таблица" бронирования/аренды
  Box<User>? _userBox; // "Таблица" пользователей

  Bike? rentaledBike; // Текущий забронированный/арендованый велосипед
  User? authorisedUser; // Авторизованный пользователь
  Rental? activeRental; // Текущее бронирование/аренда

  // Простенький генератор "уникального" id:
  static String generateId() {
    return (DateTime.now().microsecondsSinceEpoch % 100000000)
        .toString()
        .padLeft(8, '0');
  }

  Future<Box<T>> _openBox<T>(String name) async {
    await Hive.openBox<T>(name);
    return Hive.box<T>(name);
  }

  // Создание и инициализация БД:
  Future<void> create() async {
    await Hive.initFlutter();
    WidgetsFlutterBinding.ensureInitialized();

    Hive.registerAdapter(BikeAdapter());
    Hive.registerAdapter(RentalAdapter());
    Hive.registerAdapter(UserAdapter());

    _bikeBox = await _openBox<Bike>('bikes');
    _rentalBox = await _openBox<Rental>('rentals');
    _userBox = await _openBox<User>('users');

    if (clearRentalBox) {
      await _rentalBox!.clear();
    }
    if (clearAllBoxes) {
      await _bikeBox!.clear();
      await _rentalBox!.clear();
      await _userBox!.clear();

      if (getUser('1') == null) {
        await addUser(User(id: '1', password: '1', name: 'Саша'));
      }
      if (getUser('2') == null) {
        await addUser(User(id: '2', password: '2', name: 'Петя'));
      }
      if (getBike('1') == null) {
        await addBike(
          Bike(
            id: '1',
            name: 'Электрический',
            electro: true,
            image: 'assets/images/1.png',
          ),
        );
      }
      if (getBike('2') == null) {
        await addBike(
          Bike(id: '2', name: 'Горный', image: 'assets/images/2.png'),
        );
      }
      if (getBike('3') == null) {
        await addBike(
          Bike(id: '3', name: 'Детский', image: 'assets/images/3.png'),
        );
      }
      if (getBike('4') == null) {
        await addBike(
          Bike(id: '4', name: 'Трехколесный', image: 'assets/images/4.png'),
        );
      }
      if (getBike('5') == null) {
        await addBike(
          Bike(id: '5', name: 'Дорожный', image: 'assets/images/5.png'),
        );
      }
      if (getBike('6') == null) {
        await addBike(
          Bike(id: '6', name: 'Спортивный', image: 'assets/images/6.png'),
        );
      }
    }
  }

  Bike? getBike(String? id) {
    return _bikeBox?.get(id);
  }

  Rental? getRental(String? id) {
    return _rentalBox?.get(id);
  }

  User? getUser(String? id) {
    return _userBox?.get(id);
  }

  Future<void> addBike(Bike? v) async {
    if (v != null) {
      await _bikeBox?.put(v.id, v);
    }
  }

  Future<void> addRental(Rental? v) async {
    if (v != null) {
      await _rentalBox?.put(v.id, v);
    }
  }

  Future<void> addUser(User? v) async {
    if (v != null) {
      await _userBox?.put(v.id, v);
    }
  }

  // Проверка логин/пароль:
  bool authorisation(String id, String password) {
    authorisedUser = getUser(id);
    if (authorisedUser != null && authorisedUser!.password == password) {
      return true;
    }
    authorisedUser = null;
    return false;
  }

  // Все незанятые велосипеды:
  List<Bike> getAllFreeBikes() {
    List<Bike> bikes = _bikeBox!.values
        .where((b) => b.locked == false && b.rentaled == false)
        .toList();
    bikes.sort((a, b) => a.id.compareTo(b.id));
    return bikes;
  }

  // Все сохраненные аренды авторизованного пользователя:
  List<Rental> getAllUserRentals() {
    List<Rental> rentals = _rentalBox!.values
        .where((r) => r.userId == authorisedUser!.id && r.booking == false)
        .toList();
    rentals.sort((a, b) => b.start!.compareTo(a.start!));
    return rentals;
  }

  // Последнее бронирование/аренда. Поиск и загрузка:
  void setUserLastRental() {
    if (authorisedUser != null) {
      List<Rental> rentals = _rentalBox!.values
          .where((r) => r.userId == authorisedUser!.id && r.finish == null)
          .toList();
      activeRental = rentals.isEmpty ? null : rentals[0];
    } else {
      activeRental = null;
    }
    if (activeRental != null) {
      rentaledBike = getBike(activeRental!.bikeId);
      if (rentaledBike == null) {
        activeRental = null;
      }
    } else {
      rentaledBike = null;
    }
  }

  // Начать бронирование/аренду:
  Future<void> startRental(Bike? bike, bool booking) async {
    if (authorisedUser == null || bike == null) {
      return;
    }
    if (activeRental != null) {
      if (activeRental!.start != null) {
        activeRental!.finish = DateTime.now();
        await addRental(activeRental);
      }
    }
    activeRental = Rental(
      userId: authorisedUser!.id,
      bikeId: bike.id,
      booking: booking,
      start: DateTime.now(),
    );
    await addRental(activeRental);
    if (rentaledBike != null && rentaledBike!.id != bike.id) {
      rentaledBike!.rentaled = false;
      await addBike(rentaledBike);
    }
    rentaledBike = bike;
    rentaledBike!.rentaled = true;
    await addBike(rentaledBike);
  }

  // Завершить бронирование/аренду:
  Future<void> finishRental() async {
    if (activeRental != null) {
      if (activeRental!.start != null) {
        activeRental!.finish = DateTime.now();
        await addRental(activeRental);
      }
      activeRental = null;
    }
    if (rentaledBike != null) {
      rentaledBike!.rentaled = false;
      await addBike(rentaledBike);
      rentaledBike = null;
    }
  }
}
