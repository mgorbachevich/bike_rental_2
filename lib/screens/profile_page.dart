import 'package:bike_rental_2/components/bike_card.dart';
import 'package:bike_rental_2/components/bottom_button.dart';
import 'package:bike_rental_2/components/dialog_service.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
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

  void setStatus() {
    if (repository.activeRental == null || repository.rentaledBike == null) {
      _status = ProfileStatus.empty;
    } else {
      _status = repository.activeRental!.booking
          ? ProfileStatus.booking
          : ProfileStatus.rental;
    }
  }

  // Кнопки навигации:
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

  // Нажали Отменить Бронирование:
  Future<void> onCancelBookingClicked() async {
    dialogService.showConfirmation(context, 'Отменить бронирование?', () async {
      await repository.finishRental();
      setState(() {
        setStatus();
      });
    }, () {});
  }

  // Нажали Отменить Аренду:
  Future<void> onCancelRentalClicked() async {
    dialogService.showConfirmation(context, 'Завершить аренду?', () async {
      await repository.finishRental();
      setState(() {
        setStatus();
      });
    }, () {});
  }

  // Нажали Бронирование:
  Future<void> onBookingClicked() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BikeListPage(booking: true)),
    );
    setState(() {
      setStatus();
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
            setStatus();
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
        setStatus();
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

  @override
  void initState() {
    repository.setUserLastRental();
    setStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return constrainedScaffold(
      context,
      'Профиль',
      surfaceColor,
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _status == ProfileStatus.empty
                    ? noData('Нет бронирования или аренды. Выберите велосипед')
                    : BikeCard(
                        bike: repository.rentaledBike,
                        rental: repository.activeRental,
                        inList: false,
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
