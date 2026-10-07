import 'package:flutter/material.dart';

import 'package:week5/core/models/student.dart';

class StudentListTile extends StatelessWidget {
  const StudentListTile({
    super.key,
    required this.student,
    required this.onTap,
  });

  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(child: Text(student.name[0])),
    title: Text(student.name),
    subtitle: Text(student.group),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
