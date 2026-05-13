import 'package:bike_rental_2/components/bike_card.dart';
import 'package:bike_rental_2/components/bottom_button.dart';
import 'package:bike_rental_2/components/dialog_service.dart';
import 'package:bike_rental_2/components/page_scaffold.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/booking_observer.dart';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:bike_rental_2/screens/bike_list_page.dart';
import 'package:bike_rental_2/screens/history_page.dart';
import 'package:flutter/material.dart';

enum ProfileStatus { empty, booking, rental }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileStatus _status = ProfileStatus.empty;

  @override
  void initState() {
    repository.setUserLastRental();
    bookingObserver.addListener(onFinishBooking); // Паттерн Обозреватель
    update();
    super.initState();
  }

  @override
  void dispose() {
    bookingObserver.removeListener(onFinishBooking); // Паттерн Обозреватель
    super.dispose();
  }

  void update() {
    if (repository.activeRental == null || repository.rentaledBike == null) {
      _status = ProfileStatus.empty;
    } else {
      _status = repository.activeRental!.booking
          ? ProfileStatus.booking
          : ProfileStatus.rental;
    }
  }

  // Кнопки навигации:
  Widget navigation() {
    return _status == ProfileStatus.rental
        ? Row(
            children: [
              bookingButton(false),
              const SizedBox(width: 2),
              cancelRentalButton(),
              const SizedBox(width: 2),
              historyButton(),
            ],
          )
        : _status == ProfileStatus.booking
        ? Row(
            children: [
              cancelBookingButton(),
              const SizedBox(width: 2),
              rentalButton(),
              const SizedBox(width: 2),
              historyButton(),
            ],
          )
        // _status == ProfileStatus.empty
        : Row(
            children: [
              bookingButton(true),
              const SizedBox(width: 2),
              rentalButton(),
              const SizedBox(width: 2),
              historyButton(),
            ],
          );
  }

  Widget rentalButton() {
    return Expanded(
      child: BottomButton(
        text: 'Арендовать\n',
        onClicked: onRentalClicked,
        color: primaryColor,
        icon: Icons.key,
      ),
    );
  }

  Widget bookingButton(bool enabled) {
    return Expanded(
      child: BottomButton(
        text: 'Брони-\nровать',
        onClicked: onBookingClicked,
        color: primaryColor,
        enabled: enabled,
        icon: Icons.bookmark_outline,
      ),
    );
  }

  Widget cancelRentalButton() {
    return Expanded(
      child: BottomButton(
        text: 'Завершить аренду',
        onClicked: onCancelRentalClicked,
        color: primaryColor,
        icon: Icons.close,
      ),
    );
  }

  Widget cancelBookingButton() {
    return Expanded(
      child: BottomButton(
        text: 'Отменить\nбронь',
        onClicked: onCancelBookingClicked,
        color: primaryColor,
        icon: Icons.close,
      ),
    );
  }

  Widget historyButton() {
    return Expanded(
      child: BottomButton(
        text: 'История\n',
        onClicked: onHistoryClicked,
        color: secondaryColor,
        icon: Icons.schedule_outlined,
      ),
    );
  }

  Future<void> finishRental() async {
    await repository.finishRental();
    setState(() {
      update();
    });
  }

  // Нажали Отменить Бронирование:
  void onCancelBookingClicked() {
    dialogService.showConfirmation(context, 'Отменить бронирование?', () async {
      await finishRental();
    }, () {});
  }

  // Нажали Отменить Аренду:
  void onCancelRentalClicked() {
    dialogService.showConfirmation(context, 'Завершить аренду?', () {
      int n = DateTime.now()
          .difference(repository.activeRental!.start!)
          .inMinutes;
      if (n > 0) {
        dialogService.showMessage(
          context,
          'Аренда завершена. Время в минутах: $n.\nНе забудьте оплатить',
          DialogType.success,
          () {},
        );
      }
      finishRental();
    }, () {});
  }

  // Нажали Бронирование:
  Future<void> onBookingClicked() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BikeListPage(booking: true)),
    );
    setState(() {
      update();
    });
  }

  // Нажали Аренда:
  Future<void> onRentalClicked() async {
    if (_status == ProfileStatus.booking) {
      dialogService.showConfirmation(
        context,
        'Арендовать велосипед?',
        () async {
          await repository.startRental(repository.rentaledBike, false);
          setState(() {
            update();
          });
        },
        () {},
      );
    } else if (_status == ProfileStatus.empty) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BikeListPage(booking: false)),
      );
      setState(() {
        update();
      });
    }
  }

  // Нажали История:
  void onHistoryClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    );
  }

  void onFinishBooking() {
    finishRental();
    dialogService.showMessage(
      context,
      'Время бронирования истекло',
      DialogType.warning,
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      context: context,
      title: 'Профиль',
      backColor: surfaceColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _status == ProfileStatus.empty
                    ? uiService.noData(
                        Icons.pedal_bike,
                        'Нет бронирования или аренды. Выберите велосипед',
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 56,
                          vertical: 4,
                        ),
                        child: BikeCard(
                          bike: repository.rentaledBike,
                          rental: repository.activeRental,
                          leftImage: false,
                        ),
                      ),
              ],
            ),
          ),
          Spacer(),
          Padding(padding: const EdgeInsets.all(4), child: navigation()),
        ],
      ),
    );
  }
}
