import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading users…'),
      ],
    ),
  );
}

class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onRetry case final retry?) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Offline extends StatelessWidget {
  const Offline({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
    icon: Icons.wifi_off,
    title: 'No connection',
    message: 'The server did not answer. Check the network and try again.',
    onRetry: onRetry,
  );
}

class ServerError extends StatelessWidget {
  const ServerError(this.status, {super.key, required this.onRetry});

  final int status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
    icon: Icons.dns_outlined,
    title: 'Server error ($status)',
    message: 'Their server is having trouble. Try again in a moment.',
    onRetry: onRetry,
  );
}

class NotAvailable extends StatelessWidget {
  const NotAvailable({super.key});

  @override
  Widget build(BuildContext context) => const MessageView(
    icon: Icons.block,
    title: 'Not available',
    message: 'This list was not found or you are not allowed to see it.',
  );
}

class GenericError extends StatelessWidget {
  const GenericError({super.key});

  @override
  Widget build(BuildContext context) => const MessageView(
    icon: Icons.bug_report_outlined,
    title: 'Something went wrong',
    message: 'The server answered with data we could not read.',
  );
}
