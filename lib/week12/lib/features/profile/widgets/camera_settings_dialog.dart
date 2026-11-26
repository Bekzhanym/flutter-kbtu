import 'package:flutter/material.dart';

Future<bool> showCameraSettingsDialog(BuildContext context) async {
  final open = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.no_photography_outlined),
      title: const Text('Camera is turned off'),
      content: const Text(
        'You chose "Don\'t allow", so the system will not ask again. '
        'Open Settings and allow Camera for this app to take a photo. '
        'You can still choose a photo from the gallery.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Open settings'),
        ),
      ],
    ),
  );
  return open ?? false;
}
