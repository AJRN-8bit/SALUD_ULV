import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
// import 'package:salud_ulv_app/src/features/presentation/themes/fonts.dart';
// import 'package:salud_ulv_app/src/features/presentation/themes/dark_theme.dart';
// // import 'package:salud_ulv_app/src/features/presentation/themes/themes.dart';

class SelectFieldButton extends StatelessWidget {
  final List<String> fieldsName;
  final List<String> fields;
  final void Function()? onTap;
  // final Function action;

  const SelectFieldButton({super.key, required this.fieldsName, required this.fields, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // const cornerValue = WidgetCircleRadius.buttonRadius;

    return ListView.builder(
      itemCount: fields.length,
      itemBuilder: (context, index){
        final field = fields[index];
        final fieldName = fieldsName[index];

        return ListTile(
          title: Text(fieldName),
          onTap: onTap,
        );
      });
  }
}




class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  // final Color? ;


  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.spacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),

          decoration: BoxDecoration(
            color: color ?? colors.primary,
            borderRadius: BorderRadius.circular(context.spacing.radiusLg),
            border: Border.all(
              color: colors.border,
            ),

            boxShadow: context.shadows.boxShadow
          ),
          
          child: Text(
            label,
            style: TextStyle(
              color: textColor ?? colors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}






class IconTextTile extends StatelessWidget {
  const IconTextTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    // this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
    // final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final fontSize = context.fonts;
    final iconSize = context.iconSize;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(spacing.radiusMd),

        child: Container(
          width: .maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),

          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(spacing.radiusMd),
            border: Border.all(
              color: colors.border,
            ),
          ),
          
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize.sm,
                color: colors.onSecondary,
              ),
              SizedBox(width: spacing.sm),
              Text(
                label,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: fontSize.caption,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class GridActionTile extends StatelessWidget {
  const GridActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final FaIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final shadows = context.shadows;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        boxShadow: shadows.boxShadow,
      ),
      child: Material(
        color: colors.primary,
        borderRadius: BorderRadius.circular(spacing.radiusLg),

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(spacing.radiusLg),
          child: Stack(
            children: [
              // background icon, oversized and faded
              Positioned(
                right: -30,
                bottom: -30,
                child: FaIcon(
                  icon,
                  size: 150,
                  color: colors.onPrimary.withValues(alpha: 0.2),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FaIcon(icon, color: colors.onPrimary, size: 40),
                    SizedBox(height: spacing.sm),
                    Text(
                      label,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        )
      )
    );
  }
}


// class SelectProgressTypeButton extends StatelessWidget {
//   final String title;
//   final Color bgColor;
//   final Widget page;

//   const SelectProgressTypeButton({super.key, required this.title, required this.bgColor, required this.page});

//   @override
//   Widget build(BuildContext context) {
//     final edgeValue = WidgetCircleRadius.bigButtonRadius;
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => page));
//       },
//       child: Container(
//         height: 150,
//         width: screenWidth,
//         decoration: BoxDecoration(
//           shape: .rectangle,
//           borderRadius: BorderRadius.circular(edgeValue),
//           color: bgColor,
//         ),

//         child: Padding(
//           padding: EdgeInsets.all(2),
//           child: Column(
//             mainAxisAlignment: .center,
//             children: [
//               Text(title, style: SizedFonts.largeFont,)
//             ],
//           ),
//         ),
//       ));
//   }
// }
