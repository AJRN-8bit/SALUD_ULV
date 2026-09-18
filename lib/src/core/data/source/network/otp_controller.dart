
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:salud_ulv_app/src/core/repositories/repos/otp_repo.dart';



class OtpServices implements IOtpRepo{
  final baseUrl = dotenv.env['OTP_URL'];
  final otpEmail = dotenv.env['OTP_EMAIL'];
  final otpPwd = dotenv.env['OTP_PASSWORD'];


  //tienes que autenticarte para que te de un token valido lo puedes hacer al iniciar la app y
  //almacenar el token en un variable share preferecense, o flutter secure
  @override
  Future<String?> loginOTP() async {
    try {

      debugPrint("$otpEmail, $otpPwd ////////////////////");

      final response = await http.post(
      Uri.parse('$baseUrl/api/v1/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
          {"email": "$otpEmail", "password": "$otpPwd"}),
    ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Servidor OTP no disponible1');
        }
      );


      if (response.statusCode != 200) {
        debugPrint(response.statusCode.toString());
        throw Exception('Error al iniciar OTP');
      }

      final responseData = json.decode(response.body);
      final String token = responseData['token'];
      debugPrint(token);

      return token;

      
    } catch (e) {
      debugPrint(' $e');
      rethrow;
    }
  }



  //lanzas esta opcion cuando vayas a crear un proceso que requiere el otp, por ejeplo
  //crear la cuenta de tu app y requires que verifiques que el usuario registrado sea el
  //correcto lemanda un otp para que verifique que es el y no otra persona
  @override
  Future<void> launchOTP(String email, String token) async {
    try {

      debugPrint('Token in otp to send: $token //////////////////////');

      final response = await http.post(
      Uri.parse('$baseUrl/api/v1/otp_app'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "User-Agent": "Thunder Client (https://www.thunderclient.com)",
        "x-access-token": token, // Usamos el token recuperado
      },
      body: json.encode({
        "email": email,
        "subject": "Verificacion de Email",
        "message": "Verifica tu email con el codigo de abajo",
        "duration": 1
      }),
    ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Servidor OTP no disponible2');
        }
      );



    if (response.statusCode != 200) {
        debugPrint(response.statusCode.toString());
        throw Exception('Error al enviar código OTP');
      }
      
    } catch (e) {
      debugPrint(' $e');
      rethrow;
    }
  }


  //este endpoint lo usas para validar que el otp introducido es valido una
  //vez que le mandastes la funcion anterior, con ese verifica ese otp
  @override
  Future<bool?> verificationOTP(String otp, String email) async {
    try {
      debugPrint('In otp: $otp, $email');

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/email_verification/verifyOTP'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Servidor OTP no disponible3');
        }
      );

      if (response.statusCode == 200) {
        debugPrint('otp verified ///////////////////////////////');
        return true;
      }

      debugPrint(response.statusCode.toString());
      return false;
      
    } catch (e) {
      debugPrint(' $e');
      rethrow;
    }
  }
}

// hola jona buenos dias, perdon ando en todo menos en lo que debo, jajaja, pero te mando los end points de otp en forma de clase:

// import 'package:flutter_application_unipass/config/config_url.dart';
// import 'package:flutter_application_unipass/utils/imports.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// /*
// // Servicios para autenticación OTP vía Syswork:

// // - loginOTP(): Inicia sesión y guarda token OTP.
// // - launchOTP(correo): Envía OTP por correo.
// // - verificationOTP(otp, correo): Verifica OTP ingresado.
// // - forgotOTP(correo): OTP para recuperación de contraseña.
// // - resetPassword(...): Restablecer contraseña con OTP.
// */

// class OtpServices {
//   //tienes que autenticarte para que te de un token valido lo puedes hacer al iniciar la app y
//   //almacenar el token en un variable share preferecense, o flutter secure
//   Future<void> loginOTP() async {
//     final response = await http.post(
//       Uri.parse('https://api-otp.app.syswork.online/api/v1/user/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(
//           {'email': "irving.patricio@ulv.edu.mx", 'password': "irya0904 "}),
//     );
//     if (response.statusCode == 200) {
//       // Decodificar la respuesta JSON
//       final responseData = json.decode(response.body);

//       // Extraer el token de la respuesta
//       final String token = responseData['token'];
//       print(token);

//       // Guardar el token en SharedPreferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('auth_token', token);

//       print("Logueado con éxito y token guardado.");
//     } else {
//       throw Exception('Failed to authenticate user');
//     }
//   }

//   //lanzas esta opcion cuando vayas a crear unproceso que requiere el otp, por ejeplo
//   //crear la cuenta de tu app y requires que verifiques que el usuario registrado sea el
//   //correcto lemanda un otp para que verifique que es el y no otra persona
//   Future<void> launchOTP(String correo) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token =
//         prefs.getString('auth_token'); // Recupera el token almacenado

//     if (token == null) {
//       throw Exception('Token no disponible');
//     }

//     final response = await http.post(
//       Uri.parse('https://api-otp.app.syswork.online/api/v1/otp_app'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': '*/*',
//         'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
//         'x-access-token': token, // Usamos el token recuperado
//       },
//       body: json.encode({
//         'email': correo,
//         'subject': 'Verificacion de Email',
//         'message': 'Verifica tu email con el codigo de abajo',
//         'duration': 1
//       }),
//     );

//     if (response.statusCode == 200) {
//       print("OTP enviado con éxito");
//     } else {
//       throw Exception('Failed to send OTP');
//     }
//   }

//   //este endpoint lo usas para validar que el otp introducido es valido una
//   //vez que le mandastes la funcion anterior, con ese verifica ese otp
//   Future<bool?> verificationOTP(String otp, String correo) async {
//     final response = await http.post(
//       Uri.parse('$otpUrl/api/v1/email_verification/verifyOTP'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': correo, 'otp': otp}),
//     );

//     if (response.statusCode == 200) {
//       print("OTP verificado con éxito");
//       return true;
//     } else {
//       print('Failed to verify OTP');
//       return false;
//     }
//   }

//   // para el proceso de recuperar contraseña puedes omitir este y usar las funciones anteriores.
//   Future<void> forgotOTP(String correo) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token =
//         prefs.getString('auth_token'); // Recupera el token almacenado

//     if (token == null) {
//       throw Exception('Token no disponible');
//     }
//     final response =
//         await http.post(Uri.parse('$otpUrl/api/v1/forgot_password_app/'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': '*/*',
//               'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
//               'x-access-token': token, // Usamos el token recuperado
//             },
//             body: json.encode({'email': correo}));
//     if (response.statusCode == 200) {
//       print("OTP de recuperació enviado");
//     } else {
//       throw Exception('Failed to send OTP of forgot password');
//     }
//   }

//   //para recuperar password, puedes omitir esto y usar las funciones anteriores.
//   Future<bool> resetPassword(
//       String correo, String otp, String newpassword) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token =
//         prefs.getString('auth_token'); // Recupera el token almacenado

//     if (token == null) {
//       throw Exception('Token no disponible');
//     }
//     final response = await http.post(
//         Uri.parse('$otpUrl/api/v1/forgot_password_app/reset'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': '*/*',
//           'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
//           'x-access-token': token, // Usamos el token recuperado
//         },
//         body: json
//             .encode({'email': correo, 'otp': otp, 'newPassword': newpassword}));
//     if (response.statusCode == 200) {
//       print('OTP para cambio de contraseña valido');
//       return true;
//       //Regresar el password reset en el return de esta funcion para su porterio almacenamiento cuando la base datos unipasss este encryptada la contraseña.
//     } else {
//       print('Codigo OTP invalido');
//       return false;
//     }
//   }
// }