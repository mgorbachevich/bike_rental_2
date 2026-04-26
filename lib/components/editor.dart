import 'package:bike_rental_2/components/hidden.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:flutter/material.dart';

const double _borderRadius = 8;

// Ввод текста:
class Editor extends StatefulWidget {
  const Editor({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.autofocus = false,
    this.icon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool autofocus;
  final IconData? icon;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hidden(
            show: widget.icon != null,
            child: Icon(widget.icon, color: primaryColor),
          ),

          Hidden(show: widget.icon != null, child: const SizedBox(width: 16)),

          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: onSurfaceColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                TextFormField(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: onSurfaceColor,
                  ),
                  autofocus: widget.autofocus,
                  controller: widget.controller,
                  //validator:
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardColor,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(_borderRadius),
                      ),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(_borderRadius),
                      ),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: disabledColor,
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: onSurfaceColor,
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: errorColor,
                    ),
                    //labelText: label,
                    hintText: widget.hint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
