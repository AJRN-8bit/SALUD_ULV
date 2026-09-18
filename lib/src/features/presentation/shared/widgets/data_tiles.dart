
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

// class GridDataTile extends StatelessWidget {
//   const GridDataTile({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.amount,
//     required this.sufix,
//   });

//   final FaIconData icon;
//   final String label;
//   final String sufix;
//   final double amount;

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//     final spacing = context.spacing;

//     return Material(
//       color: colors.surface,
//       borderRadius: BorderRadius.circular(spacing.radiusLg),
//       child: Padding(
//             padding: EdgeInsets.all(spacing.md),

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,

//               children: [
//                 Row(
//                   children: [
//                     FaIcon(icon, color: colors.primary, size: 20),
//                     SizedBox(width: spacing.sm),
//                     Text(
//                       label,
//                       style: TextStyle(
//                         color: colors.textPrimary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),

//                 Text(
//                   '${amount.toStringAsFixed(2)} $sufix',
//                   style: TextStyle(
//                     color: colors.textPrimary,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                   ),
//                 ),

//               ],
//             ),
//           ),
//     );
//   }
// }


// class GridDataTile extends StatelessWidget {
//   const GridDataTile({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.data,
//     required this.sufix,
//   });

//   final FaIconData icon; 
//   final String label;
//   final String sufix;
//   final String data;

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//     final spacing = context.spacing;

//     return Material(
//       color: colors.surface,
//       borderRadius: BorderRadius.circular(spacing.radiusLg),
//       child: Padding(
//         padding: EdgeInsets.all(spacing.md),
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           // mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Row(
//               children: [
//                 FaIcon(icon, color: colors.primary, size: 20),
//                 SizedBox(width: spacing.sm),
//                 Expanded(
//                   child: Text(
//                     label,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       color: colors.textPrimary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 4),

//             FittedBox(
//               fit: BoxFit.scaleDown,
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '$data $sufix',
//                 maxLines: 2,
//                 style: TextStyle(
//                   color: colors.textPrimary,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class GridDataTile extends StatelessWidget {

  const GridDataTile({
    super.key,
    required this.icon,
    required this.label,
    required this.data,
    this.sufix = '',
    this.color,
    this.iconColor,
    this.width = 150,
    this.height = 90,
  });

  final FaIconData icon;
  final Color? color;
  final Color? iconColor;
  final String label;
  final String sufix;
  final String data;

  /// Tamaño propio del tile. Al declararlo aquí (en vez de esperar
  /// que el padre acote las restricciones), GridDataTile funciona
  /// igual dentro de un GridView, un Row/Column normal, un Wrap,
  /// o un CustomListView horizontal/vertical con scroll.
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(spacing.radiusLg),
        boxShadow: context.shadows.smBoxShadow
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 👉 Ícono grande a la izquierda.
          FaIcon(
            icon,
            color: iconColor ?? colors.onPrimary,
            size: context.iconSize.sm,
          ),

          SizedBox(width: spacing.md),

          // 👉 Label + dato apilados en columna, alineados a la derecha.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: context.fontsSize.caption,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: spacing.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$data $sufix',
                    maxLines: 1,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: context.fontsSize.caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}