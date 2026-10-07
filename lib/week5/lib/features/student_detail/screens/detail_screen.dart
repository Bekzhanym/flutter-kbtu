import 'package:flutter/material.dart';

import 'package:week5/core/models/student.dart';
import 'package:week5/core/routing/routes.dart';
import 'package:week5/features/student_detail/widgets/student_avatar.dart';
import 'package:week5/features/student_detail/widgets/student_info_tile.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.student});

  final Student student;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Student _student = widget.student;

  Future<void> _edit() async {
    final updated = await Navigator.of(
      context,
    ).pushNamed<Student>(Routes.edit, arguments: _student);
    if (updated == null || !mounted) return;
    setState(() => _student = updated);
  }

  void _leave(bool didPop, Object? result) {
    if (didPop) return;
    Navigator.of(context).pop(_student);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: _leave,
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(_student.name),
        actions: [IconButton(onPressed: _edit, icon: const Icon(Icons.edit))],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Center(child: StudentAvatar(name: _student.name)),
          const SizedBox(height: 16),
          StudentInfoTile(icon: Icons.badge, text: _student.name),
          StudentInfoTile(icon: Icons.school, text: _student.group),
          StudentInfoTile(icon: Icons.mail, text: _student.email),
        ],
      ),
    ),
  );
}
