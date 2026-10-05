import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrls(String url) async {
  try {
    final Uri uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      debugPrint('No se pudo abrir el link: $url');
    }
  } catch (e) {
    debugPrint('Error al abrir el link: $e');
  }
}