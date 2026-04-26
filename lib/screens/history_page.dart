import 'package:bike_rental_2/components/bike_card.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Widget> _items = [];

  // Загрузка велосипедов и истории аренды из БД и создание карточек:
  List<Widget> downloadItems() {
    List<Widget> items = [];
    for (var rental in repository.getAllUserRentals()) {
      Bike? bike = repository.getBike(rental.bikeId);
      if (bike != null) {
        items.add(BikeCard(bike: bike, rental: rental, inList: true));
      }
    }
    return items;
  }

  @override
  void initState() {
    _items = downloadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return constrainedScaffold(
      context,
      'История',
      surfaceColor,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: listPageBody(_items),
      ),
    );
  }
}
