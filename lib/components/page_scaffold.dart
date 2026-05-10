import 'package:flutter/material.dart';
import 'package:bike_rental_2/constants.dart';

class PageScaffold extends StatefulWidget {
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
  State<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backColor,
      appBar: AppBar(
        backgroundColor: widget.backColor,
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: globalMaxWidth),
          child: widget.child,
        ),
      ),
      floatingActionButton: widget.floatingButtons,
    );
  }
}
