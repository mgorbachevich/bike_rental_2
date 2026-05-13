import 'package:bike_rental_2/components/animated_gesture_detector.dart';
import 'package:bike_rental_2/components/bike_card.dart';
import 'package:bike_rental_2/components/dialog_service.dart';
import 'package:bike_rental_2/components/page_scaffold.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:bike_rental_2/screens/map_page.dart';
import 'package:flutter/material.dart';

class BikeListPage extends StatefulWidget {
  const BikeListPage({super.key, required this.booking});
  final bool booking;

  @override
  State<BikeListPage> createState() => _BikeListPageState();
}

class _BikeListPageState extends State<BikeListPage> {
  List<Widget> _items = [];

  // Загрузка велосипедов из БД и создание карточек:
  List<Widget> downloadItems() {
    List<Widget> items = [];
    for (var bike in repository.getAllFreeBikes(true)) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: BikeCard(
            bike: bike,
            onClicked: () => onItemClicked(bike, widget.booking),
          ),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    _items = downloadItems();
    super.initState();
  }

  // Нажали на карточку велосипеда:
  void onItemClicked(Bike bike, bool booking) {
    dialogService.showBikeConfirmation(
      context,
      bike,
      booking ? 'Забронировать?' : 'Арендовать?',
      () async {
        await repository.startRental(bike, booking);
        if (mounted) {
          Navigator.pop(context);
        }
      },
      () {},
    );
  }

  Widget floatingButtons() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage(booking: widget.booking),
          ),
        );
      },
      backgroundColor: accentColor,
      shape: const CircleBorder(),
      child: Icon(Icons.map, size: 24, color: onAccentColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      context: context,
      title: widget.booking ? 'Бронирование' : 'Аренда',
      backColor: surfaceColor,
      floatingButtons: floatingButtons(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: uiService.listPageBody(_items),
      ),
    );
  }
}
