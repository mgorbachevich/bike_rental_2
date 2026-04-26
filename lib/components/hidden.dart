import 'package:flutter/material.dart';

// Настройка видимости:
class Hidden extends StatelessWidget {
  final bool show;
  final Widget child;

  const Hidden({super.key, required this.show, required this.child});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: show,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: false,
      child: child,
    );
  }
}
