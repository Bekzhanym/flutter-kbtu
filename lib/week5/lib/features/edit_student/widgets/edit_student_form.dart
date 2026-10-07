import 'package:flutter/material.dart';

import 'package:week5/features/edit_student/widgets/student_text_field.dart';

class EditStudentForm extends StatelessWidget {
  const EditStudentForm({
    super.key,
    required this.name,
    required this.group,
    required this.email,
    required this.onChanged,
    required this.onSave,
  });

  final TextEditingController name;
  final TextEditingController group;
  final TextEditingController email;
  final VoidCallback onChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StudentTextField(controller: name, label: 'Name', onChanged: onChanged),
        const SizedBox(height: 16),
        StudentTextField(
          controller: group,
          label: 'Group',
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
        StudentTextField(
          controller: email,
          label: 'Email',
          onChanged: onChanged,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        FilledButton(onPressed: onSave, child: const Text('Save')),
      ],
    ),
  );
}
