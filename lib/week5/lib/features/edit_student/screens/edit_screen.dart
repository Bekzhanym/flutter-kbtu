import 'package:flutter/material.dart';

import 'package:week5/core/models/student.dart';
import 'package:week5/features/edit_student/widgets/discard_changes_dialog.dart';
import 'package:week5/features/edit_student/widgets/edit_student_form.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.student});

  final Student student;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _name = TextEditingController(
    text: widget.student.name,
  );
  late final TextEditingController _group = TextEditingController(
    text: widget.student.group,
  );
  late final TextEditingController _email = TextEditingController(
    text: widget.student.email,
  );

  bool get _dirty =>
      _name.text != widget.student.name ||
      _group.text != widget.student.group ||
      _email.text != widget.student.email;

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _confirmPop(bool didPop, Object? result) async {
    if (didPop) return;
    final discard = await showDialog<bool>(
      context: context,
      builder: (_) => const DiscardChangesDialog(),
    );
    if (discard != true || !mounted) return;
    Navigator.of(context).pop();
  }

  void _save() {
    Navigator.of(context).pop(
      widget.student.copyWith(
        name: _name.text,
        group: _group.text,
        email: _email.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Text('Edit'),
    ),
    body: PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: _confirmPop,
      child: EditStudentForm(
        name: _name,
        group: _group,
        email: _email,
        onChanged: () => setState(() {}),
        onSave: _save,
      ),
    ),
  );
}
