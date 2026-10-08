import 'package:flutter/material.dart';

class StudentAvatar extends StatelessWidget {
  const StudentAvatar({super.key, required this.name, this.radius = 40});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final letter = name.trim().isEmpty ? '?' : name.trim()[0];
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      child: Text(letter, style: TextStyle(fontSize: radius * 0.8)),
    );
  }
}
