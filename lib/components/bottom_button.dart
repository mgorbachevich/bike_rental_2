import 'package:bike_rental_2/components/animated_gesture_detector.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:flutter/material.dart';

// Кнопка навигации:
class BottomButton extends StatefulWidget {
  const BottomButton({
    super.key,
    required this.text,
    required this.onClicked,
    this.color = primaryColor,
    this.enabled = true,
    this.height = bottomButtonHeight,
    required this.icon,
  });

  final String text;
  final Color color;
  final VoidCallback onClicked;
  final bool enabled;
  final double height;
  final IconData icon;

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AnimatedGestureDetector(
        onClicked: widget.onClicked,
        enabled: widget.enabled,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.enabled ? widget.color : disabledColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: onAccentColor),
              const SizedBox(height: 8),
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: buttonTextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
