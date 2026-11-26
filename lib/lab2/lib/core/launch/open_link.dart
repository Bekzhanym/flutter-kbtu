import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openLink(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return false;
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on PlatformException {
    return false;
  }
}
