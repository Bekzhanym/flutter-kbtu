import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:week12/features/profile/providers/profile_provider.dart';
import 'package:week12/features/profile/widgets/camera_settings_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final profile = context.read<ProfileProvider>();
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;
      await profile.setPhoto(file.path);
    } on PlatformException catch (e) {
      if (!mounted) return;
      _say(
        e.code == 'no_available_camera'
            ? 'This device has no camera.'
            : 'Could not open the picker.',
      );
    }
  }

  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        await _pick(ImageSource.camera);
      case PermissionStatus.denied:
        _say('No camera access. You can ask again or choose from the gallery.');
      case PermissionStatus.permanentlyDenied:
        final open = await showCameraSettingsDialog(context);
        if (open) await openAppSettings();
      case PermissionStatus.restricted:
        _say('The camera is restricted on this device.');
    }
  }

  void _say(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final path = context.watch<ProfileProvider>().avatarPath;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 64,
              backgroundImage: path == null ? null : FileImage(File(path)),
              child: path == null
                  ? const Text('Me', style: TextStyle(fontSize: 32))
                  : null,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _takePhoto,
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Take photo'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _pick(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choose photo'),
          ),
        ],
      ),
    );
  }
}
