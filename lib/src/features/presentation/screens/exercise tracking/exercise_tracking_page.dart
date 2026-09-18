import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/walk/walk_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/location/get_current_position.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sensors/accelerometer_sensor.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sensors/geolocator_sensor.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/exercise_traker_widgets.dart';
import 'package:salud_ulv_app/src/features/services/location_permition.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_samples_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_state.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/location_bloc/location_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/location_bloc/location_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/location_bloc/location_state.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/map.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/snackbar.dart';

class ExerciseTrackerMainPage extends StatelessWidget {
  const ExerciseTrackerMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => ExerciseTrackingBloc(
        //     usecase: WalkActivityUsecase(
        //       WalkRepo(),
        //       WalkSamplesRepo(),
        //       CurrentUserSession(),
        //       AccelerometerSensor(),
        //       GeolocatorSensor(),
        //       LocationPermissionService(),
        //     ),
        //   ),
        // ),

        BlocProvider(
          create: (context) => GetCurrentLocationBloc(
            currentLocation: GetUserCurrentPosition(GeolocatorSensor()),
          ),
        ),
      ],

      child: _ExerciseTrackerMainPage(),
    );
  }
}

class _ExerciseTrackerMainPage extends StatefulWidget {
  const _ExerciseTrackerMainPage();

  @override
  State<_ExerciseTrackerMainPage> createState() =>
      _ExerciseTrackerMainPageState();
}

class _ExerciseTrackerMainPageState extends State<_ExerciseTrackerMainPage> {
  // String _formatDuration(Duration d) =>
  //     '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  final MapController _mapController = MapController();
  LatLng? startPoint;
  LatLng? endPoint;
  final points = <LatLng>[];
  bool _followUser = true;

  void _userCurrentLocation(BuildContext context) {
    final state = context.read<GetCurrentLocationBloc>().state;

    if (state is CurrentLocationLoaded) {
      final location = LatLng(
        state.currentLocation.latitude,
        state.currentLocation.longitude,
      );

      _mapController.move(location, 18);
    } else {
      CustomSnackBar.showError(context, "Ubicación actual no disponible");
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<GetCurrentLocationBloc>().add(GetCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    String formatDuration(Duration d) {
      return '${d.inMinutes.toString().padLeft(2, '0')}:'
          '${(d.inSeconds % 60).toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: context.colors.background,

      body: MultiBlocProvider(
        providers: [
          BlocListener<ExerciseTrackingBloc, ExerciseTrackingState>(
            listener: (context, state) {
                debugPrint('Puntos recorridos: $points');

              if (state is TrackingExercise &&
                  state.startLocation != null &&
                  startPoint == null) {
                debugPrint(
                  'Error in start point ${state.startLocation!.latitude}, ${state.startLocation!.longitude}',
                );

                startPoint = LatLng(
                  state.startLocation!.latitude,
                  state.startLocation!.longitude,
                );

                // );

                if (state.currentLocation != null) {
                  final newPoint = LatLng(
                    state.currentLocation!.latitude,
                    state.currentLocation!.longitude,
                  );

                  final isNewPoint =
                      points.isEmpty ||
                      points.last.latitude != newPoint.latitude ||
                      points.last.longitude != newPoint.longitude;

                  if (isNewPoint) {
                    points.add(newPoint);
                  }
                }

                setState(() {});
              }

              if (state is ExerciseSaved && state.endLocation != null) {
                setState(() {
                  endPoint = LatLng(
                    state.endLocation.latitude,
                    state.endLocation.longitude,
                  );

                  points.add(endPoint!);
                });
              }

              if (state is ExerciseDiscarded || state is ExerciseInitial) {
                setState(() {
                  startPoint = null;
                  endPoint = null;
                });
              }

              if (state is ExerciseSaved) {
                CustomSnackBar.show(context, message: "Actividad guardada");
              }

              if (state is ExerciseDiscarded) {
                CustomSnackBar.show(context, message: "Actividad descartada");
              }

              if (state is ExerciseError) {
                CustomSnackBar.showError(context, state.message);
              }

            },

            
          ),
        ],

        child: Stack(
          children: [
            BlocListener<GetCurrentLocationBloc, LocationState>(
              listener: (context, state) {

                if (state is CurrentLocationLoaded) {
                  final location = LatLng(
                    state.currentLocation.latitude,
                    state.currentLocation.longitude,
                  );

                  if (_followUser) {
                    _mapController.move(location, 18);
                  }

                  _mapController.move(location, 18);
                }

                if (state is LocationError) {
                  CustomSnackBar.showError(context, state.message);
                }
              },
              child: MapWidget(
                startPoint: startPoint,
                routePoints: points,
                endPoint: endPoint,
                mapController: _mapController,
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              child: BlocBuilder<ExerciseTrackingBloc, ExerciseTrackingState>(
                builder: (context, state) {
                  debugPrint('listado de puntos: $points');

                  final hasData = state is ActiveExerciseState;

                  final stats = hasData
                      ? [
                          ExerciseStat(
                            icon: Icons.directions_walk_rounded,
                            label: 'Pasos',
                            value: state.steps != null
                                ? '${state.steps}'
                                : '--',
                          ),
                          ExerciseStat(
                            icon: Icons.straighten_rounded,
                            label: 'Distancia',
                            value: state.distance != null && state.distance! > 0
                                ? '${(state.distance! / 1000).toStringAsFixed(1)} km'
                                : '--',
                          ),
                        ]
                      : const <ExerciseStat>[];

                  return exerciseInfoCard(
                    context,
                    title: 'Caminata',
                    icon: Icons.directions_walk_rounded,
                    statusLabel: state is ExercisePaused
                        ? 'Pausado'
                        : state is TrackingExercise
                        ? 'En progreso'
                        : 'Listo para comenzar',
                    isTracking: state is TrackingExercise,
                    time: hasData ? formatDuration(state.timeElapsed) : '--:--',
                    stats: stats,
                  );
                },
              ),
            ),

            // BOTTOM CONTROLS
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              child: BlocBuilder<ExerciseTrackingBloc, ExerciseTrackingState>(
                builder: (context, state) {
                  return exerciseControls(
                    context,
                    mode: state is ExerciseInitial
                        ? ExerciseControlsMode.initial
                        : state is TrackingExercise
                        ? ExerciseControlsMode.tracking
                        : ExerciseControlsMode.paused,
                    onStart: () => context.read<ExerciseTrackingBloc>().add(
                      StartExerciseEvent(),
                    ),
                    onPause: () => context.read<ExerciseTrackingBloc>().add(
                      PauseExerciseEvent(),
                    ),
                    onResume: () => context.read<ExerciseTrackingBloc>().add(
                      ResumeExerciseEvent(),
                    ),
                    onDiscard: () => context.read<ExerciseTrackingBloc>().add(
                      DiscardExerciseEvent(),
                    ),

                    onSave: () => context.read<ExerciseTrackingBloc>().add(
                      SaveExerciseEvent(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: .endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          // FloatingActionButton(
          //   heroTag: 'followUserButton',
          //   mini: true,
          //   backgroundColor: _followUser
          //       ? context.colors.onPrimary
          //       : context.colors.surface,
          //   onPressed: () {
          //     setState(() {
          //       _followUser = !_followUser;
          //     });

          //     if (_followUser) {
          //       CustomSnackBar.show(context, message: "Siguiendo recorrido");
          //       _userCurrentLocation(context);
          //     } else {
          //       CustomSnackBar.show(context, message: "Sin seguimiento");
          //     }
          //   },
          //   child: Icon(
          //     Icons.track_changes,
          //     color: _followUser
          //         ? context.colors.onSecondary
          //         : context.colors.onPrimary,
          //   ),
          // ),

          SizedBox(height: context.spacing.md),

          FloatingActionButton(
            onPressed: () => _userCurrentLocation(context),
            mini: true,
            backgroundColor: context.colors.surface,
            child: Icon(Icons.my_location, color: context.colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
