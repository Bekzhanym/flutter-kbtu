import 'package:flutter/material.dart';
import 'package:trip_planner/core/widgets/message_view.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      actionIcon: actionIcon,
      onAction: onAction,
    );
  }
}
