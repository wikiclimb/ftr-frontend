import 'package:flutter/material.dart';

/// Standard decorated app input field.
class DecoratedIconInput extends StatelessWidget {
  const DecoratedIconInput({
    Key? key,
    this.fillColor = Colors.white,
    required this.hintText,
    required this.prefixIcon,
  }) : super(key: key);

  final Color fillColor;
  final String hintText;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        border: const OutlineInputBorder(),
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }
}
