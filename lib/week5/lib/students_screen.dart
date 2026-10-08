import 'package:flutter/material.dart';

import 'routes.dart';
import 'students.dart';
import 'widgets/student_list_tile.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late final List<Student> _students = List.of(students);

  Future<void> _open(int index) async {
    final updated = await Navigator.of(
      context,
    ).pushNamed<Student>(Routes.student, arguments: _students[index]);
    if (updated == null || !mounted) return;
    setState(() => _students[index] = updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Text('Students'),
    ),
    body: ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) =>
          StudentListTile(student: _students[index], onTap: () => _open(index)),
    ),
  );
}
