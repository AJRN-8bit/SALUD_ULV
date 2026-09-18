import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final void Function()? onTap;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onTap,
  });

  // Static helper that handles showDialog internally
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required void Function()? onTap,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        title: title,
        message: message,
        onTap: () {
          Navigator.of(dialogContext).pop();
          onTap?.call();
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text('Sí'),
        ),
      ],
      elevation: 20,
      backgroundColor: context.colors.background,
    );
  }
}