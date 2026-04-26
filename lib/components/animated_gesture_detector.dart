import 'package:flutter/material.dart';

// Анимация при нажатии:
class AnimatedGestureDetector extends StatefulWidget {
  const AnimatedGestureDetector({
    super.key,
    required this.onClicked,
    this.enabled = true,
    required this.child,
  });
  final Widget child;
  final VoidCallback onClicked;
  final bool enabled;

  @override
  State<AnimatedGestureDetector> createState() =>
      _AnimatedGestureDetectorState();
}

class _AnimatedGestureDetectorState extends State<AnimatedGestureDetector> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.enabled ? setState(() => _scale = 0.9) : () {},
      onTapUp: (_) => widget.enabled
          ? {
              setState(() {
                _scale = 1;
                widget.onClicked();
              }),
            }
          : () {},
      onTapCancel: () => widget.enabled ? setState(() => _scale = 1) : () {},
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
