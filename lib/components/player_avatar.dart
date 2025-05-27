import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const PlayerAvatar({
    required this.name,
    this.radius = 20,
    this.backgroundColor = Colors.deepPurple,
    this.textColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: radius * 0.9,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
