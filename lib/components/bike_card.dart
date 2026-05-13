import 'package:bike_rental_2/components/animated_gesture_detector.dart';
import 'package:bike_rental_2/components/hidden.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/components/map_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/rental.dart';
import 'package:flutter/material.dart';

const double _smallImageSize = 128;
const double _borderRadius = 24;

// Карточка велосипеда и бронирования/аренды:
class BikeCard extends StatelessWidget {
  const BikeCard({
    super.key,
    required this.bike,
    this.rental,
    this.leftImage = true,
    this.history = false,
    this.onClicked,
  });

  final Bike? bike;
  final Rental? rental;
  final bool leftImage; // Слева или сверху(false)
  final bool history;
  final VoidCallback? onClicked;

  // Картинка:
  Widget bikeImage() {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_borderRadius)),
        child: leftImage
            ? Image.asset(
                bike!.image,
                width: _smallImageSize,
                height: _smallImageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    // Возвращаем другой виджет вместо сломанной картинки
                    defaultImage,
                    width: _smallImageSize,
                    height: _smallImageSize,
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                bike!.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(defaultImage, fit: BoxFit.cover);
                },
              ),
      ),
    );
  }

  // Описание велосипеда:
  Widget bikeInfo() {
    final bool showCharge = !history && bike!.electro;
    final bool showDistance = !history && (rental == null || !leftImage);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bike id:
          uiService.iconedText(
            Icons.pedal_bike,
            onAccentColor,
            primaryColor,
            bike!.id,
            onSurfaceColor,
          ),
          SizedBox(height: 2),
          // Bike name:
          Text(
            bike!.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: onSurfaceColor,
            ),
          ),
          Hidden(show: showCharge, child: const SizedBox(height: 2)),
          // Bike charge:
          Hidden(
            show: showCharge,
            child: uiService.iconedText(
              Icons.battery_charging_full,
              onAccentColor,
              accentColor,
              bike!.charge.toString(),
              onSurfaceColor,
            ),
          ),
          Hidden(show: showDistance, child: const SizedBox(height: 2)),
          // Distance:
          Hidden(
            show: showDistance,
            child: uiService.iconedText(
              Icons.straighten,
              onAccentColor,
              secondaryColor,
              '${mapService.bikeDistance(bike!).toStringAsFixed(3)} км',
              onSurfaceColor,
            ),
          ),
        ],
      ),
    );
  }

  // Форматируем дату и время:
  String formatDateTime(DateTime? dt) {
    if (dt == null) return '?';
    String d = dt.day.toString().padLeft(2, '0');
    String m = dt.month.toString().padLeft(2, '0');
    String y = dt.year.toString().substring(2); // Берем последние 2 цифры года
    String h = dt.hour.toString().padLeft(2, '0');
    String min = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.$y $h:$min';
  }

  String dates(Rental? rental) {
    if (rental == null) return '';
    String s1 = formatDateTime(rental.start);
    String s2 = formatDateTime(rental.finish);
    return s1 == '' ? '' : '$s1\n$s2';
  }

  // Описание бронирования/аренды:
  Widget rentalInfo() {
    bool booking = rental == null || rental!.booking;
    bool newRental = !booking && rental!.finish == null;
    String type = booking ? 'Бронь ' : 'Аренда ';
    String id = rental == null ? '' : rental!.id;
    return Hidden(
      show: rental != null,
      child: Container(
        decoration: BoxDecoration(
          color: newRental ? accentColor : rentalBackColor,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rental/Booking id:
            uiService.iconedText(
              booking ? Icons.bookmark_outline : Icons.key,
              accentColor,
              onAccentColor,
              type + id,
              newRental ? onAccentColor : onSurfaceColor,
            ),
            SizedBox(height: 8),
            // Rental/Booking time:
            uiService.iconedText(
              Icons.schedule_outlined,
              accentColor,
              onAccentColor,
              dates(rental),
              newRental ? onAccentColor : onSurfaceColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGestureDetector(
      onClicked: onClicked == null ? () {} : onClicked!,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            color: cardColor, // Border color
            width: 2.0, // Border thickness
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hidden(show: leftImage, child: bikeImage()),
            Hidden(show: leftImage, child: const SizedBox(width: 8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hidden(show: !leftImage, child: bikeImage()),
                  Hidden(show: !leftImage, child: const SizedBox(height: 8)),
                  bikeInfo(),
                  rentalInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
