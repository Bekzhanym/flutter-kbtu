import 'package:flutter/material.dart';

class StudentInfoTile extends StatelessWidget {
  const StudentInfoTile({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) =>
      ListTile(leading: Icon(icon), title: Text(text));
}
