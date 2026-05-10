import 'package:bike_rental_2/components/hidden.dart';
import 'package:bike_rental_2/map/map_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/rental.dart';
import 'package:flutter/material.dart';

const double _smallImageSize = 128;
const double _borderRadius = 24;

// Карточка велосипеда и бронирования/аренды:
class BikeCard extends StatefulWidget {
  const BikeCard({
    super.key,
    required this.bike,
    this.rental,
    required this.smallImage,
  });

  final Bike? bike;
  final Rental? rental;
  final bool smallImage; // В списке или отдельно

  @override
  State<BikeCard> createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  // Картинка:
  Widget bikeImage() {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_borderRadius)),
        child: widget.smallImage
            ? Image.asset(
                widget.bike!.image,
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
                widget.bike!.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(defaultImage, fit: BoxFit.cover);
                },
              ),
      ),
    );
  }

  Widget iconedText(
    IconData? icon,
    Color iconColor,
    String text,
    Color textColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 24, color: iconColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  // Описание велосипеда:
  Widget bikeInfo() {
    final bool showCharge = widget.bike!.electro;
    final bool showDistance = widget.rental == null || !widget.smallImage;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bike id:
          iconedText(
            Icons.pedal_bike,
            accentColor,
            widget.bike!.id,
            onSurfaceColor,
          ),
          SizedBox(height: 2),
          // Bike name:
          Text(
            widget.bike!.name,
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
            child: iconedText(
              Icons.battery_charging_full,
              accentColor,
              widget.bike!.charge.toString(),
              onSurfaceColor,
            ),
          ),
          Hidden(show: showDistance, child: const SizedBox(height: 2)),
          // Distance:
          Hidden(
            show: showDistance,
            child: iconedText(
              Icons.straighten,
              accentColor,
              '${mapService.bikeDistance(widget.bike!).toStringAsFixed(3)} км',
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
    return "$d.$m.$y $h:$min";
  }

  String dates(Rental? rental) {
    if (rental == null) return '';
    String s1 = formatDateTime(rental.start);
    String s2 = formatDateTime(rental.finish);
    return s1 == '' ? '' : '$s1\n$s2';
  }

  // Описание бронирования/аренды:
  Widget rentalInfo() {
    String type = widget.rental == null || widget.rental!.booking
        ? 'Бронь '
        : 'Аренда ';
    String id = widget.rental == null ? '' : widget.rental!.id;
    return Hidden(
      show: widget.rental != null,
      // Rental/Booking:
      child: Container(
        decoration: BoxDecoration(
          color: widget.rental == null || widget.rental!.booking
              ? bookingCardBackColor
              : rentalCardBackColor,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rental/Booking id:
            iconedText(
              widget.rental == null || widget.rental!.booking
                  ? Icons.bookmark_outline
                  : Icons.key,
              accentColor,
              type + id,
              onSurfaceColor,
            ),
            SizedBox(height: 8),
            // Rental/Booking time:
            iconedText(
              Icons.schedule_outlined,
              accentColor,
              dates(widget.rental),
              onSurfaceColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Hidden(show: widget.smallImage, child: bikeImage()),
          Hidden(show: widget.smallImage, child: const SizedBox(width: 8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hidden(show: !widget.smallImage, child: bikeImage()),
                Hidden(
                  show: !widget.smallImage,
                  child: const SizedBox(height: 8),
                ),
                bikeInfo(),
                rentalInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
