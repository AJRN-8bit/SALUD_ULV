import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

class TextTile extends StatelessWidget {
  final String label;
  final String? sideTitle;

  const TextTile({
    super.key,
    required this.label,
    this.sideTitle
  });


  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),

      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(spacing.radiusMd),
        // border: Border.all(color: colors.border),
      ),

      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: sideTitle == null ? '' : '$sideTitle ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        style: TextStyle(color: colors.textPrimary), // shared/base style
      ),
    );
  }
}


class CustomTextWidget extends StatelessWidget{

  final String label;
  final double fontSize;
  final Color? color;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const CustomTextWidget({
    super.key,
    required this.label,
    required this.fontSize,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.w500,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Text(
      label,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: textAlign, 
      style: TextStyle(
        color: color ?? colors.textPrimary,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}




class GradientText extends StatelessWidget {
  const GradientText({
    super.key,
    required this.text,
    required this.colors,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final List<Color> colors;
  final double fontSize;
  final FontWeight fontWeight;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white, // necesario para que el shader se aplique bien
        ),
      ),
    );
  }
}