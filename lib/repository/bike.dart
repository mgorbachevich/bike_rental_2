import 'package:bike_rental_2/repository/repository.dart';
import 'package:hive/hive.dart';
part 'bike.g.dart';

// Записи БД Велосипед:
@HiveType(typeId: 0)
class Bike extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool electro;

  @HiveField(3)
  bool locked; // Не используется

  @HiveField(4)
  bool rentaled;

  @HiveField(5)
  int charge;

  @HiveField(6)
  String image;

  Bike({
    this.id = '',
    this.name = 'Велосипед',
    this.electro = false,
    this.locked = false,
    this.rentaled = false,
    this.charge = 0,
    this.image = '',
  }) {
    if (id == '') id = Repository.generateId();
  }
}
