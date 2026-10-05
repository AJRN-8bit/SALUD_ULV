
import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

String? numberValidator(String? v, String mensaje) {
  if (v == null || v.trim().isEmpty) return mensaje;
  if (double.tryParse(v.trim()) == null) return 'Valor inválido';
  return null;
}

String? inputValidator(String? v, String mensaje) {
  if (v == null || v.trim().isEmpty) return mensaje;
  return null;
}



String? passwordValidator(String? v, String mensaje, {int minLength = 8}) {
  if (v == null || v.trim().isEmpty) return mensaje;

  final hasUppercase = RegExp(r'[A-Z]').hasMatch(v);
  // final hasLowercase = RegExp(r'[a-z]').hasMatch(v);
  final hasNumber = RegExp(r'[0-9]').hasMatch(v);
  final hasMinLength = v.length >= minLength;

  if (!hasMinLength || !hasUppercase || !hasNumber) {
    return 'Debe tener $minLength+ caracteres, mayúscula y número';
  }

  return null;
}




String? codeValidator(String? v, String mensaje, {int length = 6}) {
  if (v == null || v.trim().isEmpty) return mensaje;
  if (v.trim().length != length) return 'El código debe tener $length dígitos';
  if (int.tryParse(v.trim()) == null) return 'Solo se permiten números';
  return null;
}




class PasswordRequirementsChecklist extends StatelessWidget {
  const PasswordRequirementsChecklist({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final password = value.text;
        final requirements = <String, bool>{
          'Al menos 8 caracteres': password.length >= 8,
          'Una mayúscula': RegExp(r'[A-Z]').hasMatch(password),
          // 'Una minúscula': RegExp(r'[a-z]').hasMatch(password),
          'Un número': RegExp(r'[0-9]').hasMatch(password),
          // 'Un símbolo especial': RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(password),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: requirements.entries.map((e) {
            final met = e.value;
            return Padding(
              padding: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Icon(
                    met ? Icons.check_circle : Icons.circle_outlined,
                    size: 14,
                    color: met ? context.colors.success : context.colors.textPrimary,
                  ),
                  SizedBox(width: context.spacing.xs),
                  Text(
                    e.key,
                    style: TextStyle(
                      fontSize: context.fonts.details,
                      color: met ? context.colors.success : context.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}