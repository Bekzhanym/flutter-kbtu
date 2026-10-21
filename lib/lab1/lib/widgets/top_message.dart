import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showTopMessage(
  BuildContext context, {
  required String text,
  required Color background,
  required Color foreground,
}) {
  showTopSnackBar(
    Overlay.of(context),
    TopMessage(text: text, background: background, foreground: foreground),
    displayDuration: const Duration(seconds: 2),
  );
}

class TopMessage extends StatelessWidget {
  const TopMessage({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Material(
    color: background,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: foreground),
      ),
    ),
  );
}
