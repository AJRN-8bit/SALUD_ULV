import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/save_usecase.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/anthro_dto.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/anthro_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_state.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/home/home_member.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/main_wrapper.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/containers.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/input_fields.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';

class RegisterAnthroPage extends StatelessWidget {
  const RegisterAnthroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaveAnthroBloc(
        saveAnthroUsecase: SaveAnthroUsecase(
          AnthroLocalStorage(),
          CurrentUserSession(),
        ),
      ),

      child: const _RegisterAnthroPage(),
    );
  }
}

class _RegisterAnthroPage extends StatefulWidget {
  const _RegisterAnthroPage();

  @override
  State<_RegisterAnthroPage> createState() => _RegisterAnthroPageState();
}

class _RegisterAnthroPageState extends State<_RegisterAnthroPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _smmController = TextEditingController();
  final _fatMassController = TextEditingController();
  final _bodyFatPercentController = TextEditingController();
  final _bmiController = TextEditingController();
  final _whrController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _smmController.dispose();
    _fatMassController.dispose();
    _bodyFatPercentController.dispose();
    _bmiController.dispose();
    _whrController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SaveAnthroBloc>().add(
        SaveAnthroEvent(
          AnthropometricsDTO(
            height: double.tryParse(_heightController.text.trim()) ?? 0.0,
            weight: double.tryParse(_weightController.text.trim()) ?? 0.0,
            smm: double.tryParse(_smmController.text.trim()) ?? 0.0,
            fatMass: double.tryParse(_fatMassController.text.trim()) ?? 0.0,
            bodyFatPercentage:
                double.tryParse(_bodyFatPercentController.text.trim()) ?? 0.0,
            bmi: double.tryParse(_bmiController.text.trim()) ?? 0.0,
            whr: double.tryParse(_whrController.text.trim()) ?? 0.0,
          ).toDomain(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      // colors: [context.colors.background, context.colors.background, context.colors.tertiary],
      // stops: [0, 0.35, 1],

      child: Scaffold(
        appBar: AppBar(backgroundColor: context.colors.background, elevation: 0),
      
        backgroundColor: Colors.transparent,
        body: SafeArea(
          // top: true,
          bottom: true,
      
          child: BlocListener<SaveAnthroBloc, AnthroState>(
            listener: (context, state) {
              if (state is AnthroSaved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registro guardado')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainWrapper()),
                );
              }
              if (state is AnthroError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
      
            child: BlocBuilder<SaveAnthroBloc, AnthroState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(context.spacing.md),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
      
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          CustomTextWidget(
                            label: "Registro de datos antropométricos",
                            fontSize: context.fontsSize.display,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: context.spacing.md),
                          CustomTextWidget(
                            label:
                                'Ingresa tu datos corporales compartidos por Salud ULV o Nutrición ULV',
                            fontSize: context.fontsSize.caption,
                          ),
                          SizedBox(height: context.spacing.sm),
                          CustomTextWidget(
                            label:
                                'Si no conoces tus datos, acercate al departamento de Nutrición ULV para tu medición corporal',
                            fontSize: context.fontsSize.caption,
                          ),
      
                          SizedBox(height: context.spacing.xl),
      
                          BackgroundContainer(
                            // color: context.colors.secondary,

                            child: Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Altura (cm)',
                                  hintText: 'Ej: 175',
                                  keyboardType: TextInputType.number,
                                  controller: _heightController,
                                  validator: (v) =>
                                      numberValidator(v, 'Ingresa tu altura'),
                                ),
                                SizedBox(height: context.spacing.md),
      
                                CustomTextFormField(
                                  label: 'Peso (kg)',
                                  hintText: 'Ej: 68.5',
                                  keyboardType: TextInputType.number,
                                  controller: _weightController,
                                  validator: (v) =>
                                      numberValidator(v, 'Ingresa tu peso'),
                                ),
                                SizedBox(height: context.spacing.md),
      
                                CustomTextFormField(
                                  label: 'Masa Muscular Esquelética (MME)',
                                  hintText: 'Ej: 24',
                                  keyboardType: TextInputType.number,
                                  controller: _smmController,
                                  validator: (v) =>
                                      numberValidator(v, 'Ingresa tu MME'),
                                ),
                                SizedBox(height: context.spacing.md),
      
                                CustomTextFormField(
                                  label: 'Masa de Grasa (kg)',
                                  hintText: 'Ej: 20',
                                  keyboardType: TextInputType.number,
                                  controller: _fatMassController,
                                  validator: (v) =>
                                      numberValidator(v, 'Ingresa el dato'),
                                ),
                                SizedBox(height: context.spacing.md),
      
                                CustomTextFormField(
                                  label: 'Porcentaje de Grasa (%)',
                                  hintText: 'Ej: 20',
                                  keyboardType: TextInputType.number,
                                  controller: _bodyFatPercentController,
                                  validator: (v) => numberValidator(
                                    v,
                                    'Ingresa el porcentaje',
                                  ),
                                ),
                                SizedBox(height: context.spacing.md),
      
                                CustomTextFormField(
                                  label: 'Indice Masa Corporal (IMC)',
                                  hintText: 'Ej: 22',
                                  keyboardType: TextInputType.number,
                                  controller: _bmiController,
                                  validator: (v) =>
                                      numberValidator(v, 'Ingresa el dato'),
                                ),
                                SizedBox(height: context.spacing.md),
      
                                CustomTextFormField(
                                  label: 'Indice Cintura Cadera (ICC)',
                                  hintText: 'Ej: 0.85',
                                  keyboardType: TextInputType.number,
                                  controller: _whrController,
                                  validator: (v) =>
                                      numberValidator(v, 'Ingresa el dato'),
                                ),
                                SizedBox(height: context.spacing.md),
                              ],
                            ),
                          ),
      
                          SizedBox(height: context.spacing.lg),
                          SimpleButton(
                            label: 'Guardar',
                            color: context.colors.surface,
                            onPressed: () => _onSubmit(context),
                          ),
                          SizedBox(height: context.spacing.md),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}