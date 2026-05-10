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
                ? noData('Нет данных')
                : ListView(children: items),
          ),
        ],
      ),
    );
  }

  // Картинка когда список пуст:
  Widget noData(String text) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Icon(Icons.warning, size: 48, color: warningColor),
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
}
