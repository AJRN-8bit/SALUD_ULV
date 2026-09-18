

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FaIconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final fontSize = context.fonts;
    final iconSize = context.iconSize;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        boxShadow: context.shadows.boxShadow,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        enabled: enabled,
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: fontSize.caption,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: TextStyle(
            color: colors.textPrimary,
            fontSize: fontSize.caption,
          ),
          hintStyle: TextStyle(
            color: colors.textPrimary,
            fontSize: fontSize.caption,
          ),
          prefixIcon: prefixIcon != null
              ? Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: FaIcon(
                    prefixIcon,
                    size: iconSize.xs,
                    color: colors.onSecondary,
                  ),
                )
              : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: colors.background,
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            borderSide: BorderSide(color: colors.border, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            borderSide: BorderSide(color: colors.danger, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            borderSide: BorderSide(color: colors.danger, width: 1.5),
          ),
        ),
      ),
    );
  }
}

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
  final hasLowercase = RegExp(r'[a-z]').hasMatch(v);
  final hasNumber = RegExp(r'[0-9]').hasMatch(v);
  final hasMinLength = v.length >= minLength;

  if (!hasMinLength || !hasUppercase || !hasLowercase || !hasNumber) {
    return 'Debe tener $minLength+ caracteres, mayúscula, minúscula y número';
  }

  return null;
}




String? codeValidator(String? v, String mensaje, {int length = 6}) {
  if (v == null || v.trim().isEmpty) return mensaje;
  if (v.trim().length != length) return 'El código debe tener $length dígitos';
  if (int.tryParse(v.trim()) == null) return 'Solo se permiten números';
  return null;
}




class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconSize = context.iconSize;

    return CustomTextFormField(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      obscureText: _obscureText, // 👈 controlado por el estado interno
      prefixIcon: FontAwesomeIcons.lock,
      suffixIcon: IconButton(
        icon: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: FaIcon(
            _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
            size: iconSize.xs,
            color: colors.onSecondary,
          ),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText; // 👈 aquí cambia al picar
          });
        },
      ),
    );
  }
}