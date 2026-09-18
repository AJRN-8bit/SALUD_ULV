import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/get_recent_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/send_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/logout_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/get_recent_exercise.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/send_exercise.dart';
import 'package:salud_ulv_app/src/core/usecase/profile/get_profile_info_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/profile/get_user_name.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/main_wrapper.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/containers.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/data_tiles.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/listviews.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/progress_meter.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/snackbar.dart';
import 'package:salud_ulv_app/src/features/services/check_connection.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token_storage.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/member_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/user_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/network/anthro_controller.dart';
import 'package:salud_ulv_app/src/core/data/source/network/exercise_controller.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_state.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_state.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/anthropometrics/register_anthro_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/exercise%20tracking/exercise_tracking_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/profile/profile_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/records/main_records_page.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';

class MemberHomePage extends StatelessWidget {
  const MemberHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Logout
        BlocProvider(
          create: (context) => SendAnhroBloc(
            sendAnthroUsecase: SendAnthroUsecase(
              AnthroLocalStorage(),
              AnthroController(),
              CurrentUserSession(),
              CheckConnection(),
            ),
          ),
        ),

        // BlocProvider(
        //   create: (context) => SendExerciseBloc(
        //     sendExerciseUseCase: SendExerciseUseCase(ExerciseRepo(), ExerciseController(), CheckConnection()))
        //   ),
        BlocProvider(
          create: (context) => GetUserNameBloc(
            getUserName: GetUserNameUseCase(
              currentUserSession: CurrentUserSession(),
              userLocalRepo: UserLocalRepo(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) =>
              LogoutBloc(logoutUseCase: LogoutUsecase(TokenStorage())),
        ),

        BlocProvider(
          create: (context) => GetProfileInfoBloc(
            getUserInfoUsecase: GetProfileInfoUsecase(
              UserLocalRepo(),
              CurrentUserSession(),
              MemberLocalRepo(),
            ),
          ),
        ), // Send anthro data

        BlocProvider(
          create: (context) => ExerciseGetRecentBloc(
            recentExerciseUseCase: GetRecentExerciseUseCase(
              WalkRepo(),
              CurrentUserSession(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => GetAnthroRecentBloc(
            getRecentAnthroUsecase: GetRecentAnthroUsecase(
              AnthroLocalStorage(),
              CurrentUserSession(),
            ),
          ),
        ),
      ],
      child: const _MemberHomePage(),
    );
  }
}

class _MemberHomePage extends StatefulWidget {
  const _MemberHomePage();

  @override
  State<_MemberHomePage> createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<_MemberHomePage> {

    String _formatDuration(Duration d) {
    return '${d.inMinutes.toString().padLeft(2, '0')}:'
        '${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }


  @override
  void initState() {
    super.initState();

    context.read<GetUserNameBloc>().add(GetUserNameEvent());
    context.read<ExerciseGetRecentBloc>().add((ExerciseGetRecentEvent()));
    context.read<GetAnthroRecentBloc>().add(AnthroGetRecentEvent());
    context.read<SendAnhroBloc>().add(AnthroSyncPending());
    //context.read<SendExerciseBloc>().add(ExerciseSyncPending());
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      // colors: [context.colors.onPrimary, context.colors.background],
      // stops: [0, 0.3],

      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SafeArea(
          top: true,
          bottom: true,

          child: MultiBlocListener(
            listeners: [
              BlocListener<ExerciseGetRecentBloc, ExerciseState>(
                listener: (context, state) {
                  if (state is ExerciseError) {
                    CustomSnackBar.showError(context, state.message);
                  }
                },
              ),

              BlocListener<SendAnhroBloc, AnthroState>(
                listener: (context, state) {
                  if (state is AnthroSent) {
                    CustomSnackBar.showSuccess(
                      context,
                      "Datos antropométricos compartidos con Salud ULV",
                    );
                  }
                },
              ),

              BlocListener<GetAnthroRecentBloc, AnthroState>(
                listener: (context, state) {
                  if (state is AnthroError) {
                    CustomSnackBar.showError(context, state.message);
                  }
                },
              ),

              // BlocListener<GetUserNameBloc, ProfileState>(
              //   listener: (context, state) {
              //     if(state is ){
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           behavior: .floating,
              //           backgroundColor: context.colors.success  ,
              //           content: Text('Datos antropométricos compartidos con Salud ULV'))
              //         );
              //     }
              //   }
              // ),

              //BlocListener<SendExerciseBloc, ExerciseState>(
              //  listener: (context, state) {
              //    if(state is ExerciseSent){
              //      ScaffoldMessenger.of(context).showSnackBar(
              //        SnackBar(content: Text('Actividad física compartida con Salud ULV')));
              //    }
              //  }
              //),
            ],

            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(context.spacing.md),

                child: Column(
                  // mainAxisAlignment: .center,
                  // crossAxisAlignment: .stretch,
                  children: [
                    BlocBuilder<GetUserNameBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is UserNameLoaded) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomTextWidget(
                                  label: "Hola, ${state.name[0]}",
                                  fontSize: context.fontsSize.headline,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileMainPage(),
                                    ),
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 22,
                                  child: Icon(Icons.person),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),



                    SizedBox(height: context.spacing.xxl),



                    BlocBuilder<ExerciseGetRecentBloc, ExerciseState>(
                      builder: (context, state) {
                        if (state is ExerciseLoading) {
                          return const CircularProgressIndicator();
                        }
                        debugPrint(state.toString());

                        if (state is ExerciseRecentLoaded) {
                          if (state.data == null) {
                            return Column(
                              children: [
                                // SizedBox(height: context.spacing.md),

                                CustomTextWidget(
                                  label: "¿Quieres ver tu caminata reciente?",
                                  fontSize: context.fontsSize.body,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(height: context.spacing.md),
                                // CustomTextWidget(
                                //   label:
                                //       "Agrega una caminata visualizar tu progreso personal",
                                //   fontSize: context.fontsSize.body,
                                // ),
                                // SizedBox(height: context.spacing.lg),

                                SimpleButton(
                                  
                                  label: "Agregar caminata",
                                  color: context.colors.surface,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainWrapper(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          // return RecentAnthropometricListView(data: state.data);

                          final walk = state.data! as Walk;
                          debugPrint('act in ui ${walk.activityID}');

                          return Column(
                            // mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              CustomTextWidget(
                                label: "Caminata reciente",
                                fontSize: context.fontsSize.title,
                                fontWeight: FontWeight.w700,
                              ),

                              SizedBox(height: context.spacing.md),

                              CustomListView(
                                orientation: .horizontal,
                                scrollable: true,
                                widgets: [
                                  GridDataTile(
                                    icon: FontAwesomeIcons.ruler,
                                    label: "Distancia",
                                    data: walk.distance!.toStringAsFixed(2),
                                    sufix: 'm',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.stopwatch,
                                    label: "Duración",
                                    // data: '${walk.duration!.inHours}:${walk.duration!.inMinutes / 60}:${walk.duration!.inSeconds / 60}',
                                    data: _formatDuration(walk.duration!),
                                    sufix: '',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.fireFlameCurved,
                                    label: "Calorias quemadas",
                                    data: walk.caloriesBurned!.toStringAsFixed(
                                      2,
                                    ),
                                    sufix: 'cal',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.mountain,
                                    label: "Elevación ganada",
                                    data: walk.elevationGain!.toStringAsFixed(
                                      2,
                                    ),
                                    sufix: 'm',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.timeline,
                                    label: "Ritmo",
                                    data: walk.avgPace!.toStringAsFixed(2),
                                    sufix: 'min/km',
                                  ),

                                  // GridDataTile(
                                  //   icon: FontAwesomeIcons.shoePrints,
                                  //   label: "Pasos por minuto",
                                  //   data: walk.avgSteps!.toStringAsFixed(1),
                                  //   sufix: 'min/km'
                                  // ),
                                  GridDataTile(
                                    icon: FontAwesomeIcons.personWalking,
                                    label: "Pasos por minuto",
                                    data: walk.avgCadence!.toStringAsFixed(2),
                                    sufix: '',
                                  ),
                                ],
                              ),
                              //
                            ],
                          );
                        }

                        return const SizedBox();
                      },
                    ),

                    SizedBox(height: context.spacing.lg),

                    BlocBuilder<GetAnthroRecentBloc, AnthroState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        }

                        if (state is AnthroRecentLoaded) {
                          if (state.data == null) {
                            return Column(
                              children: [
                                // SizedBox(height: context.spacing.md),

                                CustomTextWidget(
                                  label: "¿Quieres ver tus antropométricos recientes?",
                                  fontSize: context.fontsSize.body,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(height: context.spacing.md),
                                // CustomTextWidget(
                                //   label:
                                //       "Agrega una caminata visualizar tu progreso personal",
                                //   fontSize: context.fontsSize.body,
                                // ),
                                // SizedBox(height: context.spacing.lg),

                                SimpleButton(
                                  
                                  label: "Agregar antropométricos",
                                  
                                  color: context.colors.surface,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterAnthroPage(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            crossAxisAlignment: .start,

                            children: [
                              CustomTextWidget(
                                label: "Antropométricos recientes",
                                fontSize: context.fontsSize.title,
                                fontWeight: FontWeight.w700,
                              ),

                              SizedBox(height: context.spacing.md),

                              CustomListView(
                                widgets: [
                                  GridDataTile(
                                    icon: FontAwesomeIcons.person,
                                    iconColor: context.colors.onTertiary,
                                    label: "Altura",
                                    data: "${(state.data!.height) / 100}",
                                    sufix: 'm',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.weightScale,
                                    iconColor: context.colors.onTertiary,
                                    label: "Peso",
                                    // data: '${walk.duration!.inHours}:${walk.duration!.inMinutes / 60}:${walk.duration!.inSeconds / 60}',
                                    data: state.data!.weight.toString(),
                                    sufix: 'kg',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.dumbbell,
                                    iconColor: context.colors.onTertiary,
                                    label: "SMM",
                                    data: state.data!.smm.toString(),
                                    sufix: 'kg',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.weightHanging,
                                    iconColor: context.colors.onTertiary,
                                    label: "Masa de grasa",
                                    data: state.data!.fatMass.toString(),
                                    sufix: 'kg',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.percent,
                                    iconColor: context.colors.onTertiary,
                                    label: "Grasa corporal",
                                    data: state.data!.bodyFatPercentage
                                        .toString(),
                                    sufix: '%',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.weightScale,
                                    iconColor: context.colors.onTertiary,
                                    label: "IMC",
                                    data: state.data!.bmi.toString(),
                                    sufix: 'kg/m²',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.rulerHorizontal,
                                    iconColor: context.colors.onTertiary,
                                    label: "ICC",
                                    data: state.data!.whr.toString(),
                                    // sufix: '',
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        return const SizedBox();
                      },
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
