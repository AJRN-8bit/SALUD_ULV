import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/member_repo.dart';
import 'package:salud_ulv_app/src/core/models/user.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/check_credentials_eval_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/login_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/register_member_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/send_otp.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/verify_otp_usecase.dart';
import 'package:salud_ulv_app/src/core/data/source/network/otp_controller.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/main_wrapper.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/input_fields.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/snackbar.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/stepper.dart';
import 'package:salud_ulv_app/src/features/services/check_connection.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token_storage.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/user_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/network/auth_controller.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/auth/login_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/auth/registry_info_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/home/home_member.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/containers.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';
import 'package:salud_ulv_app/src/testers/auth_repo_tester.dart';
import 'package:salud_ulv_app/src/testers/check_connection_tester.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterUserBloc(
            registryUsecase: RegisterUserUsecase(
              AuthHTTPController(),
              UserLocalRepo(),
              CheckConnection(),
              TokenStorage(),
              TokenHandler(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => RegisterCredentialsBloc(
            signUpCredentialsUseCase: SignUpCredentialsUsecase(
              AuthHTTPController(),
              CheckConnection(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => SendOTPBloc(
            sendOTPUseCase: SendOtpUsecase(
              CheckConnection(),
              OtpServices(),
              TokenStorage(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => CheckOTPBloc(
            verifyOTPUseCase: VerifyOtpUsecase(
              CheckConnection(),
              OtpServices(),
              TokenStorage(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => LoginBloc(
            loginUsecase: LoginUsecase(
              AuthHTTPController(),
              TokenHandler(),
              TokenStorage(),
              CheckConnection(),
              UserLocalRepo(),
              MemberLocalRepo(),
            ),
          ),
        ),
      ],

      child: const _SignUpPage(),
    );
  }
}

class _SignUpPage extends StatefulWidget {
  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  const _SignUpPage();

  @override
  State<_SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<_SignUpPage> {
  // Need of controller for a custom texform entry
  // final _formKey = GlobalKey<FormState>();
  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());

  // final isLoading = false;

  final _userCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  final _otpController = TextEditingController();

  final _firstnameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _lastnameController = TextEditingController();

  //   DateTime? _dateOfBirth;
  // String? _dobError;
  int _typeID = 1;
  int _currentStep = 0;

  @override
  void dispose() {
    _userCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwdController.dispose();

    _otpController.dispose();

    _firstnameController.dispose();
    _surnameController.dispose();
    _lastnameController.dispose();

    super.dispose();
  }

  bool get isLoading {
    switch (_currentStep) {
      case 0:
        return context.watch<RegisterCredentialsBloc>().state is AuthLoading;

      case 1:
        return context.watch<CheckOTPBloc>().state is AuthLoading;

      case 2:
        return context.watch<RegisterUserBloc>().state is AuthLoading;

      default:
        return false;
    }
  }

  void _onStepContinue() {
    final isValid = _formKeys[_currentStep].currentState!.validate();
    if (!isValid) return;

    if (_currentStep == 0) {
      context.read<RegisterCredentialsBloc>().add(
        RegisterCredentialsEvent(
          userCode: _userCodeController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          confirmedPw: _confirmPwdController.text.trim(),
        ),
      );
      context.read<SendOTPBloc>().add(
        SendOTPEvent(_emailController.text.trim()),
      );
    } else if (_currentStep == 1) {
      debugPrint('${_otpController.text}, ${_emailController.text}');
      context.read<CheckOTPBloc>().add(
        CheckOPTEvent(_otpController.text.trim(), _emailController.text.trim()),
      );
    } else {
      _onFinalSubmit();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _onFinalSubmit() async {
    // if (!_formKey.currentState!.validate()) return;

    final user = User(
      userCode: _userCodeController.text.trim(),
      firstname: _firstnameController.text.trim(),
      surname: _surnameController.text.trim(),
      lastname: _lastnameController.text.trim(),
      email: _emailController.text.trim(),
      // dateOfBirth: _dateOfBirth!,
      // gender: _genderController.text.trim()
    );

    final password = _passwordController.text.trim();

    context.read<RegisterUserBloc>().add(
      RegisterEvent(user: user, password: password, typeID: _typeID),
    );

    await Future.delayed(const Duration(seconds: 1));

    // ignore: use_build_context_synchronously
    context.read<LoginBloc>().add(LoginEvent(input: _emailController.text.trim(), password: password));
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      // colors: [
      //   context.colors.onSecondary,
      //   context.colors.secondary,
      //   context.colors.primary,
      // ],
      // stops: [0 , 0.5, 1],

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: true,
          bottom: true,

          child: MultiBlocListener(
            listeners: [
              BlocListener<RegisterUserBloc, AuthState>(
                listener: (context, state) {

                  if (state is AuthError) {
                    CustomSnackBar.showError(context, state.message);
                  }
                },
              ),


              BlocListener<LoginBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainWrapper()),
                      (route) => false,
                    );
                  }

                  if (state is AuthError) {
                    CustomSnackBar.showError(context, state.message);
                  }
                },
              ),


              BlocListener<RegisterCredentialsBloc, AuthState>(
                listener: (context, state) {
                  if (state is ContinueAuth) {
                    if (state.isCorrect) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please check your credentials'),
                        ),
                      );
                    }
                  }

                  if (state is AuthError) {
                    CustomSnackBar.showError(context, state.message);
                  }
                },
              ),

              BlocListener<SendOTPBloc, AuthState>(
                listener: (context, state) {
                  if (state is OtpSent) {
                    CustomSnackBar.showSuccess(
                      context,
                      "Código de verificación enviado",
                    );
                  }

                  if (state is AuthError) {
                    CustomSnackBar.showError(context, state.message);
                  }
                },
              ),

              BlocListener<CheckOTPBloc, AuthState>(
                listener: (context, state) {
                  if (state is ContinueAuth) {
                    if (state.isCorrect) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      CustomSnackBar.showError(
                        context,
                        "Corrobore su código o genere uno nuevo",
                      );
                    }
                  }

                  if (state is AuthError) {
                    CustomSnackBar.showError(context, state.message);
                  }
                },
              ),
            ],

            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(context.spacing.sm),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      label: "Crea una cuenta",
                      fontSize: context.fontsSize.display,
                      fontWeight: FontWeight.w900,
                    ),

                    SizedBox(height: context.spacing.md),

                    BackgroundContainer(
                      pHeight: 600,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomStepper(
                            currentStep: _currentStep,
                            stepTitles: [
                              'Credenciales',
                              'Verficar correo',
                              'Información personal',
                            ],

                            isLoading: isLoading,

                            onContinue: _onStepContinue,
                            onCancel: _onStepCancel,

                            stepContent: switch (_currentStep)
                            // ─────────────────────────────
                            // STEP 0 - CREDENCIALES
                            // ─────────────────────────────
                            {
                              0 => Form(
                                key: _formKeys[0],
                                child: BlocBuilder<RegisterCredentialsBloc, AuthState>(
                                  builder: (context, state) {
                                    String? userCodeError;
                                    String? emailError;

                                    if (state is AuthError) {
                                      emailError = state.message;
                                    }

                                    return Column(
                                      children: [
                                        CustomTextFormField(
                                          label: "Matrícula",
                                          controller: _userCodeController,
                                          keyboardType: TextInputType.number,
                                          prefixIcon: FontAwesomeIcons.hashtag,
                                          validator: (v) => inputValidator(
                                            v,
                                            "Porfavor ingresa tu matrícula ULV",
                                          ),
                                          // errorText: userCodeError,
                                        ),

                                        SizedBox(height: context.spacing.md),

                                        CustomTextFormField(
                                          label: "Correo electrónico",
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          prefixIcon: FontAwesomeIcons.envelope,
                                          validator: (v) => inputValidator(
                                            v,
                                            "Porfavor ingresa un correo electrónico",
                                          ),
                                          // errorText: emailError,
                                        ),

                                        SizedBox(height: context.spacing.md),

                                        CustomPasswordField(
                                          label: "Contraseña",
                                          controller: _passwordController,
                                          validator: (v) => inputValidator(
                                            v,
                                            "Ingresa una contraseña",
                                          ),
                                        ),

                                        SizedBox(height: context.spacing.md),

                                        CustomPasswordField(
                                          label: "Confirmar contraseña",
                                          controller: _confirmPwdController,
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Porfavor confirma tu contraseña';
                                            }

                                            if (v != _passwordController.text) {
                                              return 'Las contraseñas no son iguales';
                                            }

                                            return null;
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              // ─────────────────────────────
                              // STEP 1 - VERIFICAR CORREO
                              // ─────────────────────────────
                              1 => Form(
                                key: _formKeys[1],
                                child: BlocBuilder<CheckOTPBloc, AuthState>(
                                  builder: (context, state) {
                                    String? otpError;

                                    if (state is AuthError) {
                                      otpError = state.message;
                                    }

                                    return Column(
                                      children: [
                                        CustomTextWidget(
                                          label:
                                              "Ingresa el código de verificación enviado al correo ${_emailController.text}.",
                                          fontSize: context.fontsSize.body,
                                        ),

                                        SizedBox(height: context.spacing.md),

                                        CustomTextWidget(
                                          label:
                                              "Si no encuentra el código, revise la sección de Spam",
                                          fontSize: context.fontsSize.caption,
                                        ),

                                        SizedBox(height: context.spacing.lg),

                                        CustomTextFormField(
                                          label: 'Código',
                                          controller: _otpController,
                                          prefixIcon: FontAwesomeIcons.key,
                                          keyboardType: TextInputType.number,
                                          validator: (v) => inputValidator(
                                            v,
                                            'Ingresa el código enviado',
                                          ),
                                          // errorText: otpError,
                                        ),

                                        SizedBox(height: context.spacing.md),

                                        GestureDetector(
                                          onTap: () {
                                            context.read<SendOTPBloc>().add(
                                              SendOTPEvent(
                                                _emailController.text.trim(),
                                              ),
                                            );
                                          },
                                          child: CustomTextWidget(
                                            label: "Reenviar código",
                                            fontSize: context.fontsSize.caption,
                                            color: context.colors.onSecondary,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              // ─────────────────────────────
                              // STEP 2 - INFORMACIÓN PERSONAL
                              // ─────────────────────────────
                              2 => Form(
                                key: _formKeys[2],
                                child: BlocBuilder<RegisterUserBloc, AuthState>(
                                  builder: (context, state) {
                                    String? firstnameError;
                                    String? surnameError;
                                    String? lastnameError;

                                    if (state is AuthError) {
                                      firstnameError = state.message;
                                    }

                                    return Column(
                                      children: [
                                        CustomTextFormField(
                                          label: "Nombre",
                                          controller: _firstnameController,
                                          prefixIcon: FontAwesomeIcons.user,
                                          validator: (v) => inputValidator(
                                            v,
                                            "Porfavor ingresa tu nombre",
                                          ),
                                          // errorText: firstnameError,
                                        ),

                                        SizedBox(height: context.spacing.md),

                                        CustomTextFormField(
                                          label: "Apellido paterno",
                                          controller: _surnameController,
                                          prefixIcon: FontAwesomeIcons.user,
                                          validator: (v) => inputValidator(
                                            v,
                                            "Porfavor ingresa tu primer apellido",
                                          ),
                                          // errorText: surnameError,
                                        ),

                                        SizedBox(height: context.spacing.md),

                                        CustomTextFormField(
                                          label: "Apellido materno",
                                          controller: _lastnameController,
                                          prefixIcon: FontAwesomeIcons.user,
                                          validator: (v) => inputValidator(
                                            v,
                                            "Ingresa tu segundo apellido",
                                          ),
                                          // errorText: lastnameError,
                                        ),

                                        SizedBox(height: context.spacing.xxl),

                                        CustomTextWidget(
                                          label: "Ingresa tu ocupación en ULV",
                                          fontSize: context.fontsSize.body,
                                          // fontWeight: FontWeight.w700,
                                        ),
                                        SizedBox(height: context.spacing.md),
                                        CustomTextWidget(
                                          label:
                                              "Después de enviar no podrás cambiar tu elección",
                                          fontSize: context.fontsSize.caption,
                                        ),
                                        SizedBox(height: context.spacing.lg),

                                        RadioGroup<int>(
                                          groupValue: _typeID,
                                          onChanged: (int? value) =>
                                              setState(() => _typeID = value!),

                                          child: Row(
                                            mainAxisAlignment: .center,
                                            children: const [
                                              Radio<int>(value: 1),
                                              CustomTextWidget(
                                                label: "Empleado",
                                                fontSize: 16,
                                              ),

                                              Radio<int>(value: 2),
                                              CustomTextWidget(
                                                label: "Estudiante",
                                                fontSize: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              _ => const SizedBox.shrink(),
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.spacing.xl),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextWidget(
                          label: "¿Ya tienes una cuenta?",
                          fontSize: context.fontsSize.caption,
                        ),

                        SizedBox(width: context.spacing.xs),

                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          ),
                          child: CustomTextWidget(
                            label: "Inicia sesión",
                            fontSize: context.fontsSize.caption,
                            color: context.colors.success,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.spacing.md),
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

// class MinimalStepper extends StatefulWidget {
//   const MinimalStepper({
//     super.key,
//     required this.steps,
//     required this.onFinish,
//   });

//   final List<StepData> steps;
//   final VoidCallback onFinish;

//   @override
//   State<MinimalStepper> createState() => _MinimalStepperState();
// }

// class StepData {
//   StepData({required this.formKey, required this.content});
//   final GlobalKey<FormState> formKey;
//   final Widget content;
// }

// class _MinimalStepperState extends State<MinimalStepper> {
//   int _currentStep = 0;

//   bool get _isLastStep => _currentStep == widget.steps.length - 1;

//   void _handleNext() {
//     final isValid = widget.steps[_currentStep].formKey.currentState!.validate();
//     if (!isValid) return; // errors already show on the fields

//     if (_isLastStep) {
//       widget.onFinish();
//     } else {
//       setState(() => _currentStep += 1);
//     }
//   }

//   void _handleBack() {
//     if (_currentStep > 0) setState(() => _currentStep -= 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//     final spacing = context.spacing;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // --- progress bars ---
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md),
//           child: Row(
//             children: List.generate(widget.steps.length, (i) {
//               final isActive = i <= _currentStep;
//               return Expanded(
//                 child: Container(
//                   height: 3,
//                   margin: EdgeInsets.symmetric(horizontal: spacing.xxs),
//                   decoration: BoxDecoration(
//                     color: isActive ? colors.primary : colors.border,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),

//         // --- current step content ---
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: spacing.lg),
//             child: Form(
//               key: widget.steps[_currentStep].formKey,
//               child: widget.steps[_currentStep].content,
//             ),
//           ),
//         ),

//         // --- footer controls ---
//         Padding(
//           padding: EdgeInsets.all(spacing.lg),
//           child: Center(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (_currentStep > 0) ...[
//                   TextButton(
//                     onPressed: _handleBack,
//                     child: Text(
//                       'Back',
//                       style: TextStyle(color: colors.textSecondary),
//                     ),
//                   ),
//                   SizedBox(width: spacing.md),
//                 ],
//                 AppButton(
//                   label: _isLastStep ? 'Finish' : 'Next',
//                   onPressed: _handleNext,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// BlocBuilder<RegisterBloc, AuthState>(
//           builder: (context, state) {
//             return Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _formKey,

//                     child: Column(
//                       mainAxisAlignment: .center,
//                       children: [
//                       const Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 32),

//                        TextFormField(
//                         controller: _userCodeController,
//                         decoration: const InputDecoration(labelText: 'User code'),
//                         keyboardType: TextInputType.numberWithOptions(),
//                         validator: (v) => v!.isEmpty ? 'Enter your first name' : null,
//                       ),
//                       const SizedBox(height: 12),

//                       // TextFormField(
//                       //   controller: _firstnameController,
//                       //   decoration: const InputDecoration(labelText: 'First Name'),
//                       //   validator: (v) => v!.isEmpty ? 'Enter your first name' : null,
//                       // ),
//                       // const SizedBox(height: 12),

//                       // TextFormField(
//                       //   controller: _surnameController,
//                       //   decoration: const InputDecoration(labelText: 'Surname'),
//                       //   validator: (v) => v!.isEmpty ? 'Enter your surname' : null,
//                       // ),
//                       // const SizedBox(height: 12),

//                       // TextFormField(
//                       //   controller: _lastnameController,
//                       //   decoration: const InputDecoration(labelText: 'Last Name'),
//                       //   validator: (v) => v!.isEmpty ? 'Enter your last name' : null,
//                       // ),
//                       // const SizedBox(height: 12),

//                       TextFormField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(labelText: 'Email'),
//                         validator: (v) => v!.isEmpty ? 'Enter your email' : null,
//                       ),
//                       const SizedBox(height: 12),

//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: const InputDecoration(labelText: 'Password'),
//                         obscureText: true,
//                         validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
//                         onChanged: (_) {
//                           if (_confirmPwdController.text.isNotEmpty) {
//                             _formKey.currentState?.validate();
//                           }
//                         },
//                       ),
//                       const SizedBox(height: 12),

//                       TextFormField(
//                         controller: _confirmPwdController,
//                         decoration: const InputDecoration(labelText: 'Confirm password'),
//                         obscureText: true,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) return 'Please confirm your password';
//                           if (v != _passwordController.text) return 'Passwords do not match';
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 32),

//                       state is AuthLoading
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                               onPressed: () => _onSubmit(context),
//                               child: const Text('Create Account'),
//                             ),

//                        Row(
//                           mainAxisAlignment: .center,
//                           children:[
//                             Text("¿Tienes una cuenta?", style: TextStyle(fontFamily: "Lato", fontSize: 12, color: Colors.black)),
//                             const SizedBox(width: 5),

//                             GestureDetector(
//                               onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage())),
//                               child: Text("Inicia sesión", style: TextStyle(fontFamily: "Lato", fontSize: 12, fontWeight: FontWeight.bold, color: Colors.cyan.shade400))),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//           },
//         ),
