import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/models/admin.dart';
import 'package:salud_ulv_app/src/core/models/member.dart';
import 'package:salud_ulv_app/src/core/models/user.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/logout_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/profile/can_change_roles_verifier.dart';
import 'package:salud_ulv_app/src/core/usecase/profile/select_role_usecase.dart';
// import 'package:salud_ulv_app/src/core/models/user.dart';
import 'package:salud_ulv_app/src/core/usecase/profile/get_profile_info_usecase.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token_storage.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/member_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/user_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/anthropometrics/register_anthro_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/auth/splash_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/profile/select_role_page.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/dialogs.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/snackbar.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';

class ProfileMainPage extends StatelessWidget {
  const ProfileMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetProfileInfoBloc(
            getUserInfoUsecase: GetProfileInfoUsecase(
              UserLocalRepo(),
              CurrentUserSession(),
              MemberLocalRepo(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) =>
              LogoutBloc(logoutUseCase: LogoutUsecase(TokenStorage())),
        ),

        BlocProvider(
          create: (context) => CanChangeRoleBloc(
            canChangeRolesVerifier: CanChangeRolesVerifier(
              CurrentUserSession(),
              UserLocalRepo(),
            ),
          ),
        ),
      ],

      child: _ProfileMainPage(),
    );
  }
}

class _ProfileMainPage extends StatefulWidget {
  const _ProfileMainPage();

  @override
  State<_ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<_ProfileMainPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetProfileInfoBloc>().add(GetProfileEvent());
    context.read<CanChangeRoleBloc>().add(CanChangeRoleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,

      appBar: AppBar(
        backgroundColor: context.colors.background,
        // toolbarHeight: 80,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios_new, color: context.colors.primary),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          'Perfil',
          style: TextStyle(color: context.colors.textPrimary),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        top: true,
        bottom: true,

        child: MultiBlocListener(
          listeners: [
            BlocListener<GetProfileInfoBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),

            BlocListener<LogoutBloc, AuthState>(
              listener: (context, state) {
                if (state is Unauthenticated) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashPage()));
                }
                if (state is AuthError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),

            // BlocListener<CanChangeRoleBloc, ProfileState>(
            //   listener: (context, state) {
            //     if (state is CanChangeRole) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text('Rol seleccionado: ${state.role}')),
            //       );
            //     }
            //   }),
          ],

          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .stretch,
                  children: [
                    // const SizedBox(height: 20),

                    Image.asset(
                      'assets/logos/logoV2.png',
                      width: 100,
                      height: 100,
                    ),

                    const SizedBox(height: 20),

                    BlocBuilder<GetProfileInfoBloc, ProfileState>(
                      builder: (context, state) {
                        // final spacing = context.spacing;

                        if (state is ProfileLoaded) {
                          debugPrint(
                            'IU profile user type: ${(state.user is User)}',
                          );
                          if (state.user is User) {
                            final member = state.user as User;
                            debugPrint('In the UI profile: $member');

                            return Column(
                              mainAxisAlignment: .center,
                              children: [
                                TextTile(
                                  label:
                                      '${member.firstname} ${member.surname} ${member.lastname}',
                                ),
                                TextTile(
                                  label: member.userCode!,
                                  sideTitle: 'Matricula:',
                                ),
                                TextTile(
                                  label: member.email!,
                                  sideTitle: 'Correo:',
                                ),
                                // TextTile(label: member.userUUID!, sideTitle: 'Matricula:',),
                                // Text('ID: ${member.userUUID} '),
                                // Text('Matricula: ${member.userCode} '),
                                // Text('${member.firstname} ${member.surname} ${member.lastname}'),
                                // Text('Correo: ${member.email} '),
                                // Text('Fecha de nacimiento: ${member.dateOfBirth} '),
                                // Text('Edad: ${member.age} '),
                                // Text('Género: ${member.gender} '),
                                // Text('Perfil: ${member.currentRole} '),
                              ],
                            );
                          } else if (state.user is Admin) {
                            final user = state.user as User;

                            return Column(
                              mainAxisAlignment: .center,
                              children: [
                                TextTile(label: user.userCode!),
                                Text('ID: ${user.userUUID} '),
                                Text('Matricula: ${user.userCode} '),
                                Text(
                                  '${user.firstname} ${user.surname} ${user.lastname}',
                                ),
                                Text('Correo: ${user.email} '),
                                Text('Perfil: ${user.currentRole} '),
                              ],
                            );
                          }

                          // else {
                          //   final user = state.user as User;

                          //   return Column(
                          //     mainAxisAlignment: .center,
                          //     children: [
                          //       TextTile(label: user.userCode!,),
                          //       Text('ID: ${user.userUUID} '),
                          //       Text('Matricula: ${user.userCode} '),
                          //       Text('${user.firstname} ${user.surname} ${user.lastname}'),
                          //       Text('Correo: ${user.email} '),
                          //       Text('Perfil: ${user.currentRole} '),
                          //     ],
                          //   );
                          // }
                        }

                        return const SizedBox();
                      },
                    ),

                    SizedBox(height: context.spacing.md),

                    // // SectionTitle(title: 'Datos personales'), // Section
                    // const SizedBox(height: 10),

                    // IconTextTile(
                    //   icon: Icons.person,
                    //   label: "Antopometricos",
                    //   onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => RegisterAnthroPage(),
                    //     ),
                    //   ),
                    // ),

                    // IconTextTile(
                    //   icon: Icons.person,
                    //   label: "Datos personales",
                    //   onTap: () =>
                    //       CustomSnackBar.show(context, message: "Proximamente"),
                    // ),
                    // const SizedBox(height: 20),

                    // SectionTitle(title: 'Cuenta'), // Section
                    // SizedBox(height: context.spacing.md),

                    // IconTextTile(
                    //   icon: Icons.password,
                    //   label: "Cambiar contraseña",
                    //   onTap: () =>
                    //       CustomSnackBar.show(context, message: "Proximamente"),
                    // ),

                    // BlocBuilder<CanChangeRoleBloc, ProfileState>(
                    //   builder: (context, state) {
                    //     if (state is CanChangeRole) {
                    //       if (state.canChange == true) {
                    //         debugPrint(
                    //           'In UI can change roles: ${state.canChange}',
                    //         );

                    //         return IconTextTile(
                    //           icon: Icons.person_2,
                    //           label: "Cambiar rol",
                    //           onTap: () => Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => SelectRolePage(),
                    //             ),
                    //           ),
                    //         );
                    //       } else {
                    //         return const SizedBox();
                    //       }
                    //     }
                    //     return const SizedBox();
                    //   },
                    // ),

                    IconTextTile(
                      icon: Icons.logout,
                      label: "Cerrar sesión",
                      onTap: () => CustomAlertDialog.show(
                        context,
                        title: "Cerrar sesión",
                        message: "¿Quieres cerrar sesión?",
                        onTap: () =>
                            context.read<LogoutBloc>().add(LogoutEvent()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
