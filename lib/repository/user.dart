import 'package:hive/hive.dart';
part 'user.g.dart';

// Запись БД Пользователь (Клиент)
@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String password;

  @HiveField(2)
  String name;

  User({required this.id, this.password = '', this.name = 'Клиент'});
}
