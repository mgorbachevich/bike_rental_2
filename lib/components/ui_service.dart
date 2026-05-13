import 'package:bike_rental_2/components/animated_gesture_detector.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:flutter/material.dart';

final UIService uiService = UIService(); // Singleton

class UIService {
  static final UIService _instance = UIService._internal();

  UIService._internal();

  factory UIService() {
    return _instance;
  }

  // Стили текста:
  TextStyle onSurfaceTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: onSurfaceColor,
    );
  }

  TextStyle onSurfaceHelpTextStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: onSurfaceColor,
    );
  }

  TextStyle messageTextStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: onSurfaceColor,
    );
  }

  TextStyle buttonTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: onAccentColor,
    );
  }

  // Список карточек:
  Widget listPageBody(List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: items.isEmpty
                ? noData(Icons.warning, 'Нет данных')
                : ListView(children: items),
          ),
        ],
      ),
    );
  }

  // Картинка когда список пуст:
  Widget noData(IconData icon, String text) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Icon(icon, size: 48, color: warningColor),
        const SizedBox(height: 8),
        Text(text, textAlign: TextAlign.center, style: messageTextStyle()),
      ],
    );
  }

  // Анимация появления с изменением прозрачности:
  Widget opacityAnimation(bool condition, Widget child) {
    return AnimatedOpacity(
      opacity: condition ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
        scale: condition ? 1.0 : 0.2,
        child: child,
      ),
    );
  }

  BoxShadow buttonShadow() {
    return BoxShadow(
      color: Colors.black26,
      blurRadius: 4,
      offset: Offset(0, 2),
    );
  }

  Widget circledIcon(IconData? icon, Color iconColor, Color backColor) {
    return CircleAvatar(
      radius: 18, // Радиус круга
      backgroundColor: backColor, // Цвет фона
      child: Icon(icon, size: 24, color: iconColor),
    );
  }

  Widget iconedText(
    IconData? icon,
    Color iconColor,
    Color iconBackColor,
    String text,
    Color textColor,
  ) {
    return Row(
      children: [
        circledIcon(icon, iconColor, iconBackColor),
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

  Widget mapMarker(
    final VoidCallback onClicked,
    final Color color,
    final IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AnimatedGestureDetector(
        onClicked: onClicked,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [uiService.buttonShadow()],
          ),
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          child: Icon(icon, color: onAccentColor),
        ),
      ),
    );
  }
}
