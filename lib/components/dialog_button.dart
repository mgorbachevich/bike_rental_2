import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:flutter/material.dart';

// Кнопка простая без анимации для диалогов:
class DialogButton extends StatefulWidget {
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
  State<DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<DialogButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: widget.onClicked,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.enabled ? widget.color : disabledColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: buttonTextStyle(),
            ),
          ),
        ),
      ),
    );
  }
}
