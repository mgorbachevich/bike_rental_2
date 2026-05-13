import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:flutter/material.dart';

// Кнопка простая без анимации для диалогов:
class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.text,
    required this.onClicked,
    this.color = primaryColor,
    this.enabled = true,
    this.height = defaultButtonHeight,
  });

  final String text;
  final Color color;
  final VoidCallback onClicked;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: onClicked,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: enabled ? color : disabledColor,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [uiService.buttonShadow()],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: uiService.buttonTextStyle(),
            ),
          ),
        ),
      ),
    );
  }
}
