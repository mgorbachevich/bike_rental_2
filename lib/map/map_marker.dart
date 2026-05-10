import 'package:bike_rental_2/components/animated_gesture_detector.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:flutter/material.dart';

class MapMarker extends StatefulWidget {
  const MapMarker({
    super.key,
    required this.onClicked,
    required this.color,
    required this.icon,
  });

  final Color color;
  final VoidCallback onClicked;
  final IconData icon;

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AnimatedGestureDetector(
        onClicked: widget.onClicked,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          child: Icon(widget.icon, color: onAccentColor),
        ),
      ),
    );
  }
}
