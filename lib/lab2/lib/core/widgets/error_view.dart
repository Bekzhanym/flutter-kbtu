import 'package:flutter/material.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/core/api/api_exception_message.dart';
import 'package:trip_planner/core/widgets/message_view.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final ApiException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (icon, title) = switch (error) {
      NoConnectionException() => (Icons.wifi_off, 'No connection'),
      UnauthorizedException() => (Icons.lock_outline, 'Not signed in'),
      NotFoundException() => (Icons.search_off, 'Not found'),
      ClientErrorException(:final status) => (
        Icons.block,
        'Request refused ($status)',
      ),
      ServerException(:final status) => (
        Icons.dns_outlined,
        'Server error ($status)',
      ),
      BadResponseException() => (
        Icons.bug_report_outlined,
        'Unreadable answer',
      ),
    };
    return MessageView(
      icon: icon,
      title: title,
      message: error.message,
      actionLabel: 'Retry',
      onAction: onRetry,
      isError: true,
    );
  }
}
