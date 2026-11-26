import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openUri(Uri uri) async {
  try {
    return await launchUrl(uri);
  } on PlatformException {
    return false;
  }
}
