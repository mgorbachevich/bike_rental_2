import 'package:bike_rental_2/repository/repository.dart';
import 'package:hive/hive.dart';
part 'rental.g.dart';

// Запись БД Аренда/Бронирование:
@HiveType(typeId: 1)
class Rental extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String bikeId;

  @HiveField(3)
  bool booking; // true - бронирование, false - аренда

  @HiveField(4)
  DateTime? start; // Время начала

  @HiveField(5)
  DateTime? finish; // Время окончания, null - не завершено

  Rental({
    this.id = '',
    required this.userId,
    required this.bikeId,
    this.start,
    this.finish,
    this.booking = true,
  }) {
    if (id == '') id = Repository.generateId(); // Генерация id
    start ??= DateTime.now();
  }
}
