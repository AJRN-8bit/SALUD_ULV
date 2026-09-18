// // navigator_shell.dart

// // --- Role & tab config -----------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:salud_ulv_app/src/core/usecase/auth/check_auth_usecase.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/current_user_service.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/token.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/token_storage.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/sqflite/user_repo.dart';
// import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_bloc.dart';
// import 'package:salud_ulv_app/src/features/presentation/bloc/profile_bloc/profile_bloc.dart';
// import 'package:salud_ulv_app/src/features/presentation/screens/exercise%20tracking/walk_tracking_page.dart';
// import 'package:salud_ulv_app/src/features/presentation/screens/home/home_admin.dart';
// import 'package:salud_ulv_app/src/features/presentation/screens/home/home_member.dart';
// import 'package:salud_ulv_app/src/features/presentation/screens/profile/profile_page.dart';
// import 'package:salud_ulv_app/src/features/presentation/screens/records/main_records_page.dart';

// // enum UserRole { member, trainer, admin }

// class TabConfig {
//   const TabConfig({
//     required this.icon,
//     required this.label,
//     required this.pageBuilder,
//   });

//   final IconData icon;
//   final String label;
//   final WidgetBuilder pageBuilder;
// }


// class TabRegistry {
//   static List<TabConfig> forRole(UserRole role) {
//     switch (role) {
//       case UserRole.member:
//         return [
//           TabConfig(icon: Icons.person, label: 'Perfil', pageBuilder: (_) => const ProfileMainPage()),
//           TabConfig(icon: Icons.home, label: 'Inicio', pageBuilder: (_) => const MemberHomePage()),
//           TabConfig(icon: Icons.directions_walk, label: 'Ejercicios', pageBuilder: (_) => const WalkExerciseMainPage()),
//           TabConfig(icon: Icons.bar_chart, label: 'Progreso', pageBuilder: (_) => const MainProgressPage()),
//         ];
//       // case UserRole.trainer:
//       //   return [
//       //     TabConfig(icon: Icons.person, label: 'Perfil', pageBuilder: (_) => const ProfileMainPage()),
//       //     TabConfig(icon: Icons.home, label: 'Inicio', pageBuilder: (_) => const HomeTab()),
//       //     TabConfig(icon: Icons.directions_walk, label: 'Ejercicios', pageBuilder: (_) => const WalkExerciseMainPage()),
//       //   ];
//       case UserRole.admin:
//         return [
//           TabConfig(icon: Icons.person, label: 'Perfil', pageBuilder: (_) => const ProfileMainPage()),
//           TabConfig(icon: Icons.admin_panel_settings, label: 'Admin', pageBuilder: (_) => const AdminHomePage()),
//         ];
//     }
//   }
// }




// // --- The shell ----------------------------------------------------------

// class NavigatorShell extends StatelessWidget {
//   const NavigatorShell({super.key});


//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CheckAuthBloc(
//         checkAuthUseCase: CheckAuthUsecase(TokenStorage(), TokenHandler(), CurrentUserSession(), UserLocalRepo())),
//       child: const _NavigatorShellBody(),
//     );
//   }
// }


// class _NavigatorShellBody extends StatefulWidget {
//   const _NavigatorShellBody();

//   @override
//   State<_NavigatorShellBody> createState() => _NavigatorShellBodyState();
// }



// class _NavigatorShellBodyState extends State<_NavigatorShellBody> {
//   int _currentIndex = 0;
//   List<TabConfig> _tabs = [];
//   List<GlobalKey<NavigatorState>> _navigatorKeys = [];

//   void _setupTabs(UserRole role) {
//     if (_tabs.isNotEmpty) return; // resolve once
//     _tabs = TabRegistry.forRole(role);
//     _navigatorKeys = List.generate(_tabs.length, (_) => GlobalKey<NavigatorState>());
//   }

//   void _onTabTapped(int index) {
//     if (index == _currentIndex) {
//       _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
//     } else {
//       setState(() => _currentIndex = index);
//     }
//   }

//   @override
// Widget build(BuildContext context) {
//   return BlocBuilder<RoleBloc, RoleState>(
//     builder: (context, state) {
//       if (state is RoleLoading) {
//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//       }
//       if (state is RoleError) {
//         return Scaffold(body: Center(child: Text(state.message)));
//       }

//       _setupTabs((state as RoleLoaded).role);
//       final safeIndex = _currentIndex.clamp(0, _tabs.length - 1);

//       return PopScope(
//         canPop: false, // we always intercept first, and decide manually
//         onPopInvokedWithResult: (didPop, result) async {
//           if (didPop) return; // system already popped (shouldn't happen since canPop is false, but guard anyway)

//           final navigator = _navigatorKeys[safeIndex].currentState;
//           final tabPopped = await navigator?.maybePop() ?? false;

//           if (!tabPopped) {
//             // tab was already at its root — now actually let the app pop (e.g. close/minimize)
//             if (context.mounted) {
//               Navigator.of(context).maybePop();
//             }
//           }
//         },
//         child: Scaffold(
//           body: IndexedStack(
//             index: safeIndex,
//             children: List.generate(_tabs.length, (index) {
//               return Navigator(
//                 key: _navigatorKeys[index],
//                 onGenerateRoute: (settings) {
//                   return MaterialPageRoute(
//                     builder: _tabs[index].pageBuilder,
//                     settings: settings,
//                   );
//                 },
//               );
//             }),
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: safeIndex,
//             onTap: _onTabTapped,
//             type: BottomNavigationBarType.fixed,
//             items: _tabs
//                 .map((t) => BottomNavigationBarItem(icon: Icon(t.icon), label: t.label))
//                 .toList(),
//           ),
//         ),
//       );
//     },
//   );
// }
// }