import 'package:bike_rental_2/components/bike_card.dart';
import 'package:bike_rental_2/components/dialog_button.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:flutter/material.dart';

enum DialogType { error, warning, success, confirmation }

final DialogService dialogService = DialogService(); // Singleton

class DialogService {
  static final DialogService _instance = DialogService._internal();

  DialogService._internal();

  factory DialogService() {
    return _instance;
  }

  Icon _messageIcon(DialogType type) {
    switch (type) {
      case DialogType.error:
        return const Icon(Icons.error, size: 48, color: errorColor);
      case DialogType.warning:
        return const Icon(Icons.warning, size: 48, color: warningColor);
      case DialogType.success:
        return const Icon(Icons.check_circle, size: 48, color: successColor);
      case DialogType.confirmation:
        return const Icon(Icons.help, size: 48, color: warningColor);
    }
  }

  Future<T?> _showAnimatedDialog<T extends Object?>(
    BuildContext context,
    List<Widget> content,
    double width,
    double height,
  ) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: content,
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.7,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeIn)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  // Сообщение с кнопкой ОК:
  void showMessage(
    BuildContext context,
    String messageText,
    DialogType type,
    VoidCallback onOk,
  ) {
    _showAnimatedDialog(
      context,
      [
        _messageIcon(type),

        SizedBox(height: 8),

        Text(
          messageText,
          textAlign: TextAlign.center,
          style: uiService.messageTextStyle(),
        ),

        Spacer(),

        DialogButton(
          text: 'Продолжить',
          // width: defaultDialogButtonWidth, // Почему-то не работает!?
          onClicked: () {
            Navigator.pop(context);
            onOk();
          },
        ),
      ],
      defaultDialogWidth,
      defaultDialogHeight,
    );
  }

  // Сообщение Да/Нет:
  void showConfirmation(
    BuildContext context,
    String messageText,
    VoidCallback onYes,
    VoidCallback onNo,
  ) {
    _showAnimatedDialog(
      context,
      [
        _messageIcon(DialogType.confirmation),

        SizedBox(height: 8),

        Text(
          messageText,
          textAlign: TextAlign.center,
          style: uiService.messageTextStyle(),
        ),

        Spacer(),

        Row(
          children: [
            Expanded(
              child: DialogButton(
                text: 'Да',
                onClicked: () {
                  Navigator.pop(context);
                  onYes();
                },
              ),
            ),

            SizedBox(width: 4),

            Expanded(
              child: DialogButton(
                text: 'Нет',
                color: secondaryColor,
                onClicked: () {
                  Navigator.pop(context);
                  onNo();
                },
              ),
            ),
          ],
        ),
      ],
      defaultDialogWidth,
      defaultDialogHeight,
    );
  }

  // Сообщение Да/Нет:
  void showBikeConfirmation(
    BuildContext context,
    Bike bike,
    String messageText,
    VoidCallback onYes,
    VoidCallback onNo,
  ) {
    _showAnimatedDialog(
      context,
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
          child: BikeCard(bike: bike, leftImage: false),
        ),

        Spacer(),

        Text(
          messageText,
          textAlign: TextAlign.center,
          style: uiService.messageTextStyle(),
        ),

        Spacer(),

        Row(
          children: [
            Expanded(
              child: DialogButton(
                text: 'Да',
                onClicked: () {
                  Navigator.pop(context);
                  onYes();
                },
              ),
            ),

            SizedBox(width: 4),

            Expanded(
              child: DialogButton(
                text: 'Нет',
                color: secondaryColor,
                onClicked: () {
                  Navigator.pop(context);
                  onNo();
                },
              ),
            ),
          ],
        ),
      ],
      defaultDialogWidth,
      defaultDialogHeight * 2.2,
    );
  }
}
