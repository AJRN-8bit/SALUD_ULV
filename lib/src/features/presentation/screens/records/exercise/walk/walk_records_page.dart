import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:salud_ulv_app/src/core/models/exercise_samples.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/sensors_repo.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/get_all_exercise.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/get_recent_exercise.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/get_recent_samples.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/walk_dto.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_samples_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_state.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/main_wrapper.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/records/exercise/walk/walk_full_list_page.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/containers.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/data_tiles.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/graphs.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/listviews.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/map.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/progress_meter.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';

class WalkRecordsPage extends StatelessWidget {
  const WalkRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExerciseGetAllBLoc(
            allExerciseUseCase: GetAllExerciseUseCase(
              WalkRepo(),
              CurrentUserSession(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => ExerciseGetSamplesBLoc(
            getRecentSamplesUseCase: GetSamplesUseCase(WalkSamplesRepo()),
          ),
        ),
      ],

      child: const _WalkRecordsPage(),
    );
  }
}

class _WalkRecordsPage extends StatefulWidget {
  const _WalkRecordsPage();

  @override
  State<_WalkRecordsPage> createState() => _WalkRecordsPageState();
}

class _WalkRecordsPageState extends State<_WalkRecordsPage> {
  final _formKey = GlobalKey<FormState>();

  final MapController _mapController = MapController();

  // late List<Walk> records;
  // late List<LatLng> latPoints;
  String? _activityID;

  List<Walk> records = [];
  List<LatLng> points = [];

  late bool lenghtAvaliable = 0 > records.length - 1;

  late int _index = lenghtAvaliable ? 0 : records.length - 1;
  // bool _indexInitialized = false;
  bool _mapIsReady = false;

  bool get _hasPrevious => _index > 0;
  bool get _hasNext => _index < records.length - 1;
  Walk get _current => records[_index];

  void _goPrevious() {
    if (!_hasPrevious) return;
    setState(() => _index--);
    _updateMapForCurrentWalk();
  }

  void _goNext() {
    if (!_hasNext) return;
    setState(() => _index++);
    _updateMapForCurrentWalk();
  }

  void _updateMapForCurrentWalk() {
    // Si el mapa aún no se montó por primera vez, onMapReady se
    // encargará; si ya está montado, actualizamos directo aquí.
    if (_mapIsReady) {
      fitRouteToScreen(points, _mapController);
    }
  }

  void _requestSamplesForCurrent(String activityID) {
    debugPrint('in sample event: activityID');
    context.read<ExerciseGetSamplesBLoc>().add(
      ExerciseGetSamplesEvent(activityID)
    );
  }

  void _onMapReady() {
    _mapIsReady = true;
    fitRouteToScreen(points, _mapController);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatDuration(Duration d) {
    return '${d.inMinutes.toString().padLeft(2, '0')}:'
        '${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    context.read<ExerciseGetAllBLoc>().add((ExerciseGetAllEvent()));
    // context.read<ExerciseGetSamplesBLoc>().add(
    //   (ExerciseSamplesEvent(_activityID)),
    // );
    // context.read<AnthroGetAllBloc>().add(AnthroGetAllEvent());
    // context.read<AnthroByFieldBloc>().add(AnthroGetByFieldEvent('weight'));
  }

  @override
  Widget build(BuildContext context) {
    // final walk = _current;
    // final startPoint = walk.routePoints.isNotEmpty
    //     ? walk.routePoints.first
    //     : null;
    // final endPoint = walk.routePoints.isNotEmpty ? walk.routePoints.last : null;

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
          'Caminatas',
          style: TextStyle(color: context.colors.textPrimary),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        top: true,
        bottom: true,

        child: MultiBlocListener(
          listeners: [
            BlocListener<ExerciseGetAllBLoc, ExerciseState>(
              listener: (context, state) {
                if (state is ExerciseError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),

            BlocListener<ExerciseGetSamplesBLoc, ExerciseState>(
              listener: (context, state) {
                if (state is ExerciseError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),

            // BlocListener<AnthroGetAllBloc, AnthroState>(
            //   listener: (context, state) {

            //     if(state is AnthroError){
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text(state.message)));
            //     }
            //   }
            // ),

            // BlocListener<AnthroByFieldBloc, AnthroState>(
            //   listener: (context, state) {
            //     if(state is AnthroError){
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text(state.message)));
            //     }
            //   }
            // ),
          ],

          child: SingleChildScrollView(
            key: _formKey,
            scrollDirection: .vertical,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // const SizedBox(height: 100,),
                    BlocBuilder<ExerciseGetAllBLoc, ExerciseState>(
                      builder: (context, state) {
                        debugPrint(state.toString());
                        if (state is ExerciseLoading) {
                          return const CircularProgressIndicator();
                        }

                        if (state is ExerciseListLoaded && state.data!.isEmpty != true) {
                          debugPrint(state.data.toString());
                          records = state.data!.cast<Walk>();
                          debugPrint(_index.toString());
                          _activityID = records[_index].activityID;
                          debugPrint('when loading list: $_activityID');

                          if (records.isNotEmpty) {
                            debugPrint('dentro de condicional');
                            // _index = records.length - 1;
                            // _indexInitialized = true;
                            _requestSamplesForCurrent(_activityID!);
                          }

                          debugPrint(state.data.toString());
                        

                          // return RecentAnthropometricListView(data: state.data);

                          // _activityID = current.activityID!;

                          return Column(
                            // mainAxisAlignment: .center,
                            // crossAxisAlignment: .center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: _hasPrevious
                                        ? _goPrevious
                                        : null,
                                    icon: Icon(
                                      Icons.chevron_left_rounded,
                                      color: _hasPrevious
                                          ? context.colors.textPrimary
                                          : context.colors.textSecondary
                                                .withValues(alpha: 0.3),
                                    ),
                                  ),

                                  

                                  Column(
                                    children: [
                                      CustomTextWidget(
                                        label: _formatDate(
                                          _current.registeredAt!,
                                        ),
                                        fontWeight: FontWeight.w700,
                                        fontSize: context.fontsSize.title,
                                      ),
                                      Text(
                                        'Registro ${_index + 1} de ${records.length}',
                                        style: TextStyle(
                                          color: context.colors.textSecondary,
                                          fontSize: context.fontsSize.body,
                                        ),
                                      ),
                                    ],
                                  ),

                                  IconButton(
                                    onPressed: _hasNext ? _goNext : null,
                                    icon: Icon(
                                      Icons.chevron_right_rounded,
                                      color: _hasNext
                                          ? context.colors.textPrimary
                                          : context.colors.textSecondary
                                                .withValues(alpha: 0.3),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   width: 250,
                              //   height: 250,
                              //   child: Stack(
                              //     fit: StackFit.expand,
                              //     children: [
                              //       CircularProgressIndicator(
                              //         value: stepProgress, // 70% of goal
                              //         strokeWidth: 20,
                              //         backgroundColor: Colors.grey.shade800,
                              //         valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                              //       ),
                              //       Center(
                              //         child: Column(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             Text(
                              //               '$steps / $stepGoal',
                              //               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              //             ),
                              //             const Text('Pasos', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              // CircularProgressMeter(
                              //   amount: walk.steps!,
                              //   goalAmount: 10000,
                              //   icon: Icons.directions_walk,
                              //   size: 250,
                              // ),
                              // TitleWidget(
                              //   title: "Haz logrado ${walk.steps} pasos",
                              // ),
                              const SizedBox(height: 40),

                              Center(
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: (_current.steps ?? 0).toDouble(),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return CircularProgressMeter(
                                      amount: value.round(),
                                      goalAmount: 10000,
                                      icon: FontAwesomeIcons.shoePrints,
                                      label: '',
                                      size: 220,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 50),

                              CustomListView(
                                widgets: [
                                  GridDataTile(
                                    icon: FontAwesomeIcons.ruler,
                                    label: "Distancia",
                                    data: _current.distance!.toStringAsFixed(2),
                                    sufix: 'm',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.stopwatch,
                                    label: "Duración",
                                    // data: '${walk.duration!.inHours}:${walk.duration!.inMinutes / 60}:${walk.duration!.inSeconds / 60}',
                                    data: _formatDuration(_current.duration!),
                                    // sufix: '',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.fireFlameCurved,
                                    label: "Calorias quemadas",
                                    data: _current.caloriesBurned!
                                        .toStringAsFixed(2),
                                    sufix: 'cal',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.mountain,
                                    label: "Elevación ganada",
                                    data: _current.elevationGain!
                                        .toStringAsFixed(2),
                                    sufix: 'm',
                                  ),

                                  GridDataTile(
                                    icon: FontAwesomeIcons.timeline,
                                    label: "Ritmo",
                                    data: _current.avgPace!.toStringAsFixed(2),
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
                                    data: _current.avgCadence!.toStringAsFixed(
                                      2,
                                    ),
                                    sufix: '',
                                  ),
                                ],
                              ),
                            ],
                          );
                        }


                            return Column(
                              children: [
                                // SizedBox(height: context.spacing.md),

                                CustomTextWidget(
                                  label:
                                      "Parece que no hay caminatas registradas",
                                  fontWeight: FontWeight.w700,
                                  fontSize: context.fontsSize.title,
                                ),
                                SizedBox(height: context.spacing.md),
                                CustomTextWidget(
                                  label:
                                      "Agregalas para visualizar tu progreso personal",
                                  fontSize: context.fontsSize.body,
                                ),
                                SizedBox(height: context.spacing.lg),

                                SimpleButton(
                                  label: "Agregar",
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
                      
                    ),

                    const SizedBox(height: 40),

                    BlocBuilder<ExerciseGetSamplesBLoc, ExerciseState>(
                      builder: (context, state) {
                        debugPrint(state.toString());

                        if (state is ExerciseLoading) {
                          return const CircularProgressIndicator();
                        }

                        if (state is ExerciseSamplesLoaded) {
                          final data = state.data!
                              .whereType<WalkActivitySample>()
                              .toList();

                          debugPrint(data.first.activityID.toString());

                          final coordinates = data.map(
                            (s) => Coordinates(
                              latitude: s.latitude ?? 0,
                              longitude: s.longitude ?? 0,
                            ),
                          );

                          points = coordinates
                              .map((c) => LatLng(c.latitude, c.longitude))
                              .toList();

                          return Column(
                            children: [
                              BackgroundContainer(
                                pHeight: 400,
                                child: Column(
                                  mainAxisSize: .min,
                                  children: [
                                    CustomTextWidget(
                                      label: "Ruta",
                                      fontSize: context.fontsSize.title,
                                    ),

                                    SizedBox(
                                      height: 300,
                                      width: 350,
                                      child: MapWidget(
                                        startPoint: points.first,
                                        endPoint: points.last,
                                        routePoints: points,
                                        // interactive: false,
                                        mapController: _mapController,
                                        mapReady: _onMapReady,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              BackgroundContainer(
                                child: CustomDataChart(
                                  title: 'Pasos',
                                  type: .line,
                                  values: data
                                      .map((s) => s.steps ?? 0)
                                      .toList(),
                                  times: data
                                      .map(
                                        (s) => s.timestampMs ?? Duration.zero,
                                      )
                                      .toList(),
                                ),
                              ),

                              BackgroundContainer(
                                child: CustomDataChart(
                                  title: 'Velocidad',
                                  type: .bar,
                                  values: data
                                      .map((s) => s.speed ?? 0)
                                      .toList(),
                                  times: data
                                      .map(
                                        (s) => s.timestampMs ?? Duration.zero,
                                      )
                                      .toList(),
                                ),
                              ),


                              BackgroundContainer(
                                child: CustomDataChart(
                                  title: 'Elevacion',
                                  type: .line,
                                  values: data
                                      .map((s) => s.elevation ?? 0)
                                      .toList(),
                                  times: data
                                      .map(
                                        (s) => s.timestampMs ?? Duration.zero,
                                      )
                                      .toList(),
                                ),
                              ),

                              BackgroundContainer(
                                // pHeight: 400,
                                child: CustomDataChart(
                                  title: 'Distancia',
                                  type: .line,
                                  values: data
                                      .map((s) => s.distance ?? 0)
                                      .toList(),
                                  times: data
                                      .map(
                                        (s) => s.timestampMs ?? Duration.zero,
                                      )
                                      .toList(),
                                ),
                              ),

                              // BackgroundContainer(
                              //   child: CustomDataChart(
                              //     title: 'Cadencia',
                              //     type: .line,
                              //     values: data
                              //         .map((s) => s.cadence ?? 0)
                              //         .toList(),
                              //     times: data
                              //         .map(
                              //           (s) => s.timestampMs ?? Duration.zero,
                              //         )
                              //         .toList(),
                              //   ),
                              // ),
                            ],
                          );
                        }

                        return SizedBox();
                      },
                    ),

                    const SizedBox(height: 40),

                    const SizedBox(height: 30),

                    // ElevatedButton(
                    //   onPressed: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => AllWalkRecordsPage(),
                    //     ),
                    //   ),
                    //   child: Text("Todos los records"),
                    // ),

                    // BlocBuilder<AnthroGetAllBloc, AnthroState>(
                    //   builder: (context, state) {
                    //     if(state is AnthroLoading){
                    //       return const CircularProgressIndicator();
                    //     }

                    //     if(state is AnthroListLoaded){
                    //       if(state.data == null || state.data!.isEmpty) {
                    //         return const SizedBox(child: Text("No data"),);

                    //       }
                    //       return  AnthropRecordsListView(data: state.data!);
                    //     }

                    //     return const SizedBox();
                    //   }),

                    // const SizedBox(height: 40,),

                    // SizedBox(
                    //   height: 50,
                    //   width: 300,
                    //   child:
                    //    ListView.builder(
                    //       itemCount: fields.length,
                    //       scrollDirection: .horizontal,
                    //       itemBuilder: (context, index){
                    //         final field = fields[index];
                    //         final fieldName = fieldsName[index];

                    //         return Padding(
                    //           // Adds spacing between the buttons
                    //           padding: const EdgeInsets.only(right: 8.0),
                    //           child: ElevatedButton(
                    //             onPressed: () {
                    //               context.read<AnthroByFieldBloc>().add(AnthroGetByFieldEvent(field));
                    //             },
                    //             child: Text(fieldName),
                    //           ),
                    //         );
                    //       })
                    //   ),

                    //   const SizedBox(height: 20,),

                    // BlocBuilder<AnthroByFieldBloc, AnthroState>(
                    //   builder: (context, state){
                    //     if(state is AnthroLoading){
                    //       return const CircularProgressIndicator();
                    //     }

                    //     if(state is AnthroFieldListLoaded){
                    //       if(state.data == null || state.data!.isEmpty) {
                    //         return const SizedBox(child: Text("No data"),);

                    //     }
                    //       return SizedBox(
                    //         height: 200,
                    //         width: 200,
                    //         child: Text(state.data.toString()));
                    //     }

                    //     return const SizedBox(height: 40,);

                    //   }),

                    // const SizedBox(height: 100,)
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
