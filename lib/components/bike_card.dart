import 'package:bike_rental_2/components/hidden.dart';
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
    required this.inList,
  });

  final Bike? bike;
  final Rental? rental;
  final bool inList; // В списке или отдельно

  @override
  State<BikeCard> createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  // Картинка:
  Widget bikeImage() {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_borderRadius)),
        child: widget.inList
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

  // Описание велосипеда:
  Widget bikeInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bike id:
          Row(
            children: [
              Icon(Icons.pedal_bike, size: 24, color: accentColor),
              const SizedBox(width: 8),
              Text(
                widget.bike!.id,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: onSurfaceColor,
                ),
              ),
            ],
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
          Hidden(show: widget.bike!.electro, child: const SizedBox(height: 2)),
          Hidden(
            show: widget.bike!.electro,
            // Bike charge:
            child: Row(
              children: [
                const Icon(
                  Icons.battery_charging_full,
                  size: 24,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.bike!.charge.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: onSurfaceColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Форматируем дату и время:
  String formatDteTime(DateTime? dt) {
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
    String s1 = formatDteTime(rental.start);
    String s2 = formatDteTime(rental.finish);
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
            Row(
              children: [
                Icon(
                  widget.rental == null || widget.rental!.booking
                      ? Icons.bookmark_outline
                      : Icons.key,
                  size: 24,
                  color: accentColor,
                ),

                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    type + id,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: onSurfaceColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            // Rental/Booking time:
            Row(
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  size: 24,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  dates(widget.rental),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        widget.rental == null || widget.rental!.finish == null
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color:
                        widget.rental == null || widget.rental!.finish == null
                        ? accentColor
                        : onSurfaceColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.inList
          ? const EdgeInsets.all(4)
          : const EdgeInsets.symmetric(vertical: 4, horizontal: 64),

      // Фон карточки:
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
            Hidden(show: widget.inList, child: bikeImage()),
            Hidden(show: widget.inList, child: const SizedBox(width: 8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hidden(show: !widget.inList, child: bikeImage()),
                  Hidden(
                    show: !widget.inList,
                    child: const SizedBox(height: 8),
                  ),
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
