import 'package:flutter/material.dart';

class StudentTextField extends StatelessWidget {
  const StudentTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.onChanged,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    onChanged: (_) => onChanged(),
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(),
    ),
  );
}
