import 'package:bike_rental_2/components/animated_gesture_detector.dart';
import 'package:bike_rental_2/components/bike_card.dart';
import 'package:bike_rental_2/components/dialog_service.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/repository.dart';
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
    for (var bike in repository.getAllFreeBikes()) {
      items.add(
        AnimatedGestureDetector(
          onClicked: () => onItemClicked(bike, widget.booking),
          child: BikeCard(bike: bike, inList: true),
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
    dialogService.showConfirmation(
      context,
      booking
          ? 'Забронировать велосипед ${bike.id}?'
          : 'Арендовать велосипед ${bike.id}?',
      () async {
        await repository.startRental(bike, booking);
        if (mounted) {
          Navigator.pop(context);
        }
      },
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return constrainedScaffold(
      context,
      'Велосипеды',
      surfaceColor,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: listPageBody(_items),
      ),
    );
  }
}
