import 'package:flutter/material.dart';
import 'package:bike_rental_2/constants.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.context,
    required this.title,
    required this.backColor,
    this.floatingButtons,
    required this.child,
  });

  final BuildContext context;
  final String title;
  final Color backColor;
  final Widget? floatingButtons;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(backgroundColor: backColor, title: Text(title)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: globalMaxWidth),
          child: child,
        ),
      ),
      floatingActionButton: floatingButtons,
    );
  }
}
