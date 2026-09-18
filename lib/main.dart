import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:salud_ulv_app/src/core/usecase/auth/check_auth_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/walk/walk_usecase.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sensors/accelerometer_sensor.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sensors/geolocator_sensor.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_samples_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_tracking_bloc/exercise_tracking_bloc.dart';
import 'package:salud_ulv_app/src/features/services/background_service.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token.dart';
import 'package:salud_ulv_app/src/core/data/source/token/token_storage.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/user_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/auth/splash_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/main_wrapper.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:salud_ulv_app/src/features/services/location_permition.dart';

import 'src/features/presentation/shared/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeService();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  runApp(
    MultiBlocProvider(providers: [    
      
      BlocProvider(
      create: (_) => CheckAuthBloc(
        checkAuthUseCase: CheckAuthUsecase(
          TokenStorage(),
          TokenHandler(),
          CurrentUserSession(),
          UserLocalRepo(),
        ),
      )..add(CheckAuthEvent())),       
      
       BlocProvider(
          create: (context) => ExerciseTrackingBloc(
            usecase: WalkActivityUsecase(
              WalkRepo(),
              WalkSamplesRepo(),
              CurrentUserSession(),
              AccelerometerSensor(),
              GeolocatorSensor(),
              LocationPermissionService(),
            ),
          ),
        ),
        ], 
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salud ULV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      home: BlocConsumer<CheckAuthBloc, AuthState>(
        builder: (context, state) {
          return switch (state) {
            Authenticated() => const MainWrapper(),
            Unauthenticated() => const SplashPage(),
            AuthInitial() => const SizedBox.shrink(), 
            // TODO: Handle this case;
            AuthState() => throw UnimplementedError(),
          };
        },

        listener: (context, state) {
          if(state is! AuthInitial) {
            FlutterNativeSplash.remove();
          }
        },
      ),

      // initialRoute: '/splash',
      // routes: {
      //   '/splash': (context) => const SplashPage(),
      //   '/register': (context) => const SignUpPage(),
      //   '/login': (context) => const SignInPage(),
      //   '/mainWrapper': (context) => const MainWrapper(),
      //   // '/home/member': (context) => const MemberHomePage(),
      //   // '/home/coach': (context) => const CoachHomePage(),
      //   // '/home/admin': (context) => const AdminHomePage(),
      // },

      // onUnknownRoute: (settings) =>
      //     MaterialPageRoute(builder: (_) => const MemberHomePage()),
    );
  }
}