import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/get_byfield_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/get_recent_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/getall_usecase.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
// import 'package:salud_ulv_app/src/core/usecase/anthropometrics/getall_usecase.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/anthro_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_state.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/anthropometrics/register_anthro_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/records/anthropometrics/anthro_full_list_page.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/containers.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/data_tiles.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/graphs.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/listviews.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';

class AnthroRecordsPage extends StatelessWidget {
  const AnthroRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (create) => GetAnthroAllBloc(
            getallAnthroUsecase: GetallAnthroUsecase(
              AnthroLocalStorage(),
              CurrentUserSession(),
            ),
          ),
        ),

        // BlocProvider(
        //   create: (context) => AnthroGetAllBloc(getallAnthroUsecase: GetallAnthroUsecase(AnthroLocalStorage()))),
        BlocProvider(
          create: (context) => GetAnthroByFieldBloc(
            getByfieldAnthroUsecase: GetByfieldAnthroUsecase(
              AnthroLocalStorage(),
              CurrentUserSession(),
            ),
          ),
        ),
      ],

      child: const _AnthroRecordsPage(),
    );
  }
}

class _AnthroRecordsPage extends StatefulWidget {
  const _AnthroRecordsPage();

  @override
  State<_AnthroRecordsPage> createState() => _AnthroRecordsPageState();
}

class _AnthroRecordsPageState extends State<_AnthroRecordsPage> {
  final _formKey = GlobalKey<FormState>();

  AnthroField _selectedField = AnthroField.height;

  late List<Anthropometrics> records;

  late int _index = records.length - 1;

  bool get _hasPrevious => _index > 0;
  bool get _hasNext => _index < records.length - 1;

  void _goPrevious() {
    if (!_hasPrevious) return;
    setState(() => _index--);
  }

  void _goNext() {
    if (!_hasNext) return;
    setState(() => _index++);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _selectField(AnthroField field) {
    setState(() {
      _selectedField = field;
    });
  }

  @override
  void initState() {
    super.initState();
    // context.read<GetAnthroRecentBloc>().add(AnthroGetRecentEvent());
    context.read<GetAnthroAllBloc>().add(AnthroGetAllEvent());
    // context.read<GetAnthroAllBloc>().add(A);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      // colors: [context.colors.background, context.colors.background, context.colors.tertiary],
      // stops: [0, 0.35, 1],

      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: context.colors.background,
          // toolbarHeight: 80,
          elevation: 0,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios_new, color: context.colors.primary),
          //   onPressed: () => Navigator.pop(context),
          // ),
          title: Text(
            'Antropométricos',
            style: TextStyle(color: context.colors.textPrimary),
          ),
          centerTitle: true,
        ),

        body: SafeArea(
          top: true,
          bottom: true,

          child: MultiBlocListener(
            listeners: [
              BlocListener<GetAnthroAllBloc, AnthroState>(
                listener: (context, state) {
                  if (state is AnthroError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
              BlocListener<GetAnthroByFieldBloc, AnthroState>(
                listener: (context, state) {
                  if (state is AnthroError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
            ],

            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  key: _formKey,
                  scrollDirection: .vertical,

                  child: Column(
                    // mainAxisSize: .min,
                    children: [
                      BlocBuilder<GetAnthroAllBloc, AnthroState>(
                        builder: (context, state) {
                          if (state is AnthroLoading) {
                            return const CircularProgressIndicator();
                          }

                          if (state is AnthroListLoaded) {
                            if (state.data == null) {
                              return Column(
                                children: [
                                  // SizedBox(height: context.spacing.md),

                                  CustomTextWidget(
                                    label:
                                        "Parece que no hay datos antropométicos",
                                    fontWeight: FontWeight.w700,
                                    fontSize: context.fontsSize.title,
                                  ),
                                  SizedBox(height: context.spacing.md),
                                  CustomTextWidget(
                                    label:
                                        "Agregalos para visualizar tu progreso personal",
                                    fontSize: context.fontsSize.body,
                                  ),
                                  SizedBox(height: context.spacing.lg),

                                  SimpleButton(
                                    label: "Agregar",
                                    color: context.colors.surface,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterAnthroPage(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            

                            records = state.data!;
                            final current = records[_index];

                            return Padding(
                              padding: EdgeInsets.all(context.spacing.md),
                              child: Column(
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
                                              current.registeredAt!,
                                            ),
                                            fontWeight: FontWeight.w700,
                                            fontSize: context.fontsSize.title,
                                          ),
                                          Text(
                                            'Registro ${_index + 1} de ${records.length}',
                                            style: TextStyle(
                                              color:
                                                  context.colors.textSecondary,
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

                                  SizedBox(height: context.spacing.sm),

                                  // --- Recientes
                                  // Align(
                                  //   alignment: .centerLeft,
                                  //   child: CustomTextWidget(
                                  //     label: "Datos recientes",
                                  //     fontSize: context.fontsSize.title,
                                  //   ),
                                  // ),
                                  SizedBox(height: context.spacing.md),

                                  BackgroundContainer(
                                    child: Column(
                                      children: [
                                        CustomListView(
                                          addContentPadding: true,
                                          lines: 2,
                                          widgets: [
                                            GridDataTile(
                                              icon: FontAwesomeIcons.person,
                                              iconColor:
                                                  context.colors.onTertiary,
                                              label: "Altura",
                                              data: "${(current.height) / 100}",
                                              sufix: 'm',
                                            ),

                                            GridDataTile(
                                              icon:
                                                  FontAwesomeIcons.weightScale,
                                              iconColor:
                                                  context.colors.onTertiary,
                                              label: "Peso",
                                              // data: '${walk.duration!.inHours}:${walk.duration!.inMinutes / 60}:${walk.duration!.inSeconds / 60}',
                                              data: current.weight.toString(),
                                              sufix: 'kg',
                                            ),

                                            GridDataTile(
                                              icon: FontAwesomeIcons.dumbbell,
                                              iconColor:
                                                  context.colors.onTertiary,
                                              label: "SMM",
                                              data: current.smm.toString(),
                                              sufix: 'kg',
                                            ),

                                            GridDataTile(
                                              icon: FontAwesomeIcons
                                                  .weightHanging,
                                              iconColor:
                                                  context.colors.onTertiary,
                                              label: "Masa de grasa",
                                              data: current.fatMass
                                                  .toString(),
                                              sufix: 'kg',
                                            ),

                                            GridDataTile(
                                              icon: FontAwesomeIcons.percent,
                                              iconColor:
                                                  context.colors.onTertiary,
                                              label: "Grasa corporal",
                                              data: current.bodyFatPercentage.toString(),
                                              sufix: '%',
                                            ),

                                            GridDataTile(
                                              icon:
                                                  FontAwesomeIcons.weightScale,
                                              iconColor:
                                                  context.colors.onTertiary,
                                              label: "IMC",
                                              data: current.bmi.toString(),
                                              sufix: 'kg/m²',
                                            ),

                                            GridDataTile(
                                              icon: FontAwesomeIcons
                                                  .rulerHorizontal,
                                              iconColor:
                                                  context.colors.onTertiary,
                                              label: "ICC",
                                              data: current.whr.toString(),
                                              // sufix: '',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: context.spacing.lg),

                                  // --- Otros datos
                                  // Align(
                                  //   alignment: .centerLeft,
                                  //   child: CustomTextWidget(
                                  //     label: "Estadísticas",
                                  //     fontSize: context.fontsSize.title,
                                  //   ),
                                  // ),
                                  // SizedBox(height: context.spacing.sm),

                                  // BackgroundContainer(
                                  //   child: Column(children: [Text('hola')]),
                                  // ),
                                  // SizedBox(height: context.spacing.lg),

                                  // --- Graficas
                                  Align(
                                    alignment: .centerLeft,
                                    child: CustomTextWidget(
                                      label: "Progreso",
                                      fontSize: context.fontsSize.title,
                                    ),
                                  ),
                                  SizedBox(height: context.spacing.sm),

                                  BlocBuilder<GetAnthroAllBloc, AnthroState>(
                                    builder: (context, state) {
                                      if (state is AnthroListLoaded) {
                                        final data = state.data!;
                                        final buttonColor = context.colors.surface;

                                        return BackgroundContainer(
                                          child: Column(
                                            children: [
                                              CustomListView(
                                                addContentPadding: true,
                                                spacing: context.spacing.sm,
                                                widgets: [
                                                  SimpleButton(
                                                    label: "Altura",
                                                    color: buttonColor,
                                                    onPressed: () =>
                                                        _selectField(
                                                          AnthroField.height,
                                                        ),
                                                  ),
                                                  SimpleButton(
                                                    label: "Peso",
                                                    color: buttonColor,
                                                    onPressed: () =>
                                                        _selectField(
                                                          AnthroField.weight,
                                                        ),
                                                  ),
                                                  SimpleButton(
                                                    label: "SMM",
                                                    color: buttonColor,
                                                    onPressed: () =>
                                                        _selectField(
                                                          AnthroField.smm,
                                                        ),
                                                  ),
                                                  SimpleButton(
                                                    label: "M.Grasa",
                                                    color: buttonColor,
                                                    onPressed: () =>
                                                        _selectField(
                                                          AnthroField.fatMass,
                                                        ),
                                                  ),
                                                  SimpleButton(
                                                    label: "% Grasa",
                                                    color: buttonColor,
                                                    onPressed: () =>
                                                        _selectField(
                                                          AnthroField
                                                              .bodyFatPercentage,
                                                        ),
                                                  ),
                                                  SimpleButton(
                                                    label: "IMC",
                                                    color: buttonColor,
                                                    onPressed: () =>
                                                        _selectField(
                                                          AnthroField.bmi,
                                                        ),
                                                  ),
                                                  SimpleButton(
                                                    label: "ICC",
                                                    color: buttonColor,
                                                    onPressed: () =>
                                                        _selectField(
                                                          AnthroField.whr,
                                                        ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: context.spacing.lg,
                                              ),

                                              CustomDataChart(
                                                type: ChartType.bar,
                                                title: titleForSelectedField(
                                                  _selectedField,
                                                ),

                                                times: data
                                                    .map((s) => s.registeredAt)
                                                    .toList(),

                                                values: valuesForSelectedField(
                                                  data,
                                                  _selectedField,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return SizedBox();
                                    },
                                  ),

                                  SizedBox(height: context.spacing.lg),

                                  // const SizedBox(height: 20),

                                  // BlocBuilder<GetAnthroByFieldBloc, AnthroState>(
                                  //   builder: (context, state) {
                                  //     if (state is AnthroLoading) {
                                  //       return const CircularProgressIndicator();
                                  //     }

                                  //     if (state is AnthroFieldListLoaded) {
                                  //       if (state.data == null ||
                                  //           state.data!.isEmpty) {
                                  //         return const SizedBox(
                                  //           child: Text("No data"),
                                  //         );
                                  //       }
                                  //       return SizedBox(
                                  //         height: 200,
                                  //         width: 200,
                                  //         child: Text(state.data.toString()),
                                  //       );
                                  //     }

                                  //     return const SizedBox(height: 40);
                                  //   },
                                  // ),

                                  // const SizedBox(height: 30),
                                  // ElevatedButton(
                                  //   onPressed: () => Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           AllAnthroRecordsPage(),
                                  //     ),
                                  //   ),
                                  //   child: Text("Todos los records"),
                                  // ),
                                ],
                              ),
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
      ),
    );
  }
}

enum AnthroField { height, weight, smm, fatMass, bodyFatPercentage, bmi, whr }

// Devuelve los valores correspondientes al campo seleccionado.
List<num> valuesForSelectedField(
  List<Anthropometrics> data,
  AnthroField field,
) {
  switch (field) {
    case AnthroField.height:
      return data.map((s) => s.height).toList();
    case AnthroField.weight:
      return data.map((s) => s.weight).toList();
    case AnthroField.smm:
      return data.map((s) => s.smm).toList();
    case AnthroField.fatMass:
      return data.map((s) => s.fatMass).toList();
    case AnthroField.bodyFatPercentage:
      return data.map((s) => s.bodyFatPercentage).toList();
    case AnthroField.bmi:
      return data.map((s) => s.bmi).toList();
    case AnthroField.whr:
      return data.map((s) => s.whr).toList();
  }
}

// Título opcional para mostrar arriba de la gráfica.
String titleForSelectedField(AnthroField field) {
  switch (field) {
    case AnthroField.height:
      return 'Altura';
    case AnthroField.weight:
      return 'Peso';
    case AnthroField.smm:
      return 'SMM';
    case AnthroField.fatMass:
      return 'Masa de Grasa';
    case AnthroField.bodyFatPercentage:
      return '% de Grasa';
    case AnthroField.bmi:
      return 'IMC';
    case AnthroField.whr:
      return 'ICC';
  }
}
