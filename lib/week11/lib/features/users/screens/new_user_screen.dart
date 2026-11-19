import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week11/core/errors/api_exception.dart';
import 'package:week11/core/errors/api_exception_message.dart';
import 'package:week11/core/utils/validators.dart';
import 'package:week11/features/users/models/user_model.dart';
import 'package:week11/features/users/providers/users_provider.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final draft = User.draft(
      name: _name.text.trim(),
      username: _username.text.trim(),
      email: _email.text.trim(),
    );
    try {
      final user = await context.read<UsersProvider>().create(draft);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Created ${user.name} (#${user.id})')),
      );
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  InputDecoration _field(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New user')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              enabled: !_saving,
              decoration: _field('Name'),
              textInputAction: TextInputAction.next,
              validator: validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _username,
              enabled: !_saving,
              decoration: _field('Username'),
              textInputAction: TextInputAction.next,
              validator: validateUsername,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              enabled: !_saving,
              decoration: _field('Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: validateEmail,
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
