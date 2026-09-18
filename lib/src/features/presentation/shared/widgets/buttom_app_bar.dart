
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:salud_ulv_app/src/features/presentation/bloc/bottom_bar_bloc/bottom_bar_bloc.dart';
// import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';

// Widget _bottomAppBarItem(
//     BuildContext context, {
//     required IconData defaultIcon,
//     required int page,
//     required String label,
//     required IconData filledIcon,
//     required PageController pageController
//   }) {
//     final isSelected = context.watch<BottomBarBloc>().state == page;

//     return GestureDetector(
//       onTap: () {
//         BlocProvider.of<BottomBarBloc>(context).add(ChangeSelectedIndex(page));

//         pageController.animateToPage(
//           page,
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.fastLinearToSlowEaseIn,
//         );
//       },

//       child: Container(
//         color: context.colors.surface,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 10),
//             Icon(
//               isSelected ? filledIcon : defaultIcon,
//               color: isSelected ? context.colors.secondary : context.colors.primary,
//               size: 26,
//             ),
//             const SizedBox(height: 3),
//             Text(
//               label,
//               style: GoogleFonts.aBeeZee(
//                 color: isSelected ? context.colors.secondary : context.colors.primary,
//                 fontSize: 14,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }



//   BottomAppBar _mainWrapperBottomNavBar(BuildContext context, List<RoleTab> tabs, bool leftButton) {
//     return BottomAppBar(
//       color: context.colors.surface,
//       elevation: 0,
//       height: 64,
//       padding: EdgeInsets.zero,
//       child: SafeArea(
//         top: false,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             for (int i = 0; i < tabs.length; i++)
//               _bottomAppBarItem(
//                 context,
//                 defaultIcon: tabs[i].defaultIcon,
//                 page: i,
//                 label: tabs[i].label,
//                 filledIcon: tabs[i].filledIcon,
//               ),

//             if (leftButton) const SizedBox(width: 60),
//           ],
//         ),
//       ),
//     );
//   // ignore: strict_top_level_inference
//   }