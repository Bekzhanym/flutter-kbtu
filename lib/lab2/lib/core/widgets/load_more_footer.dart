import 'package:flutter/material.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/core/api/api_exception_message.dart';

class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    super.key,
    required this.loading,
    required this.error,
    required this.onRetry,
  });

  final bool loading;
  final ApiException? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final e = error;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: e != null
            ? TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('${e.message} Retry'),
              )
            : loading
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const SizedBox(height: 24),
      ),
    );
  }
}
