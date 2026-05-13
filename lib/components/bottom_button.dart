import 'package:bike_rental_2/components/animated_gesture_detector.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:flutter/material.dart';

// Кнопка навигации:
class BottomButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Color backColor = enabled ? color : disabledColor;
    Color iconColor = enabled ? onSurfaceColor : disabledColor;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AnimatedGestureDetector(
        onClicked: onClicked,
        enabled: enabled,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [uiService.buttonShadow()],
          ),
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              uiService.circledIcon(icon, iconColor, cardColor),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: uiService.buttonTextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
