import 'package:bike_rental_2/components/dialog_service.dart';
import 'package:bike_rental_2/components/page_scaffold.dart';
import 'package:bike_rental_2/map/map_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.booking});

  final bool booking;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Нажали на иконку велосипеда:
  void onBikeClicked(Bike? bike) {
    if (bike != null) {
      dialogService.showBikeConfirmation(
        context,
        bike,
        widget.booking ? 'Забронировать?' : 'Арендовать?',
        () async {
          await repository.startRental(bike, widget.booking);
          if (mounted) {
            // На две страницы назад:
            final navigator = Navigator.of(context);
            navigator.pop();
            navigator.pop();
          }
        },
        () {},
      );
    }
  }

  Widget floatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () => mapService.moveCenterToUser(),
          backgroundColor: accentColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.my_location, size: 24, color: onAccentColor),
        ),

        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: () => mapService.zoomIn(),
          backgroundColor: primaryColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 24, color: onAccentColor),
        ),

        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: () => mapService.zoomOut(),
          backgroundColor: primaryColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.remove, size: 24, color: onAccentColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      context: context,
      title: widget.booking ? 'Бронирование' : 'Аренда',
      backColor: surfaceColor,
      floatingButtons: floatingButtons(),
      child: mapService.getMap(onBikeClicked),
    );
  }
}
