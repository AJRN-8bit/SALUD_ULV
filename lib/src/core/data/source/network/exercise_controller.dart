

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/excercise_repo.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/walk_dto.dart';

class ExerciseController implements IExerciseExtRepo{

  @override
  Future<void> send(IPhysicalActivity? exercise) async {
    

    try {
      final baseUrl = dotenv.env['API_URL'];

      final result = switch(exercise) {
        Walk walk => WalkDTO.fromDomain(exercise).toMap(),

        null => null,
          _ => throw Exception('Unsupported activity type'),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/exercise/save'),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode(result),   
      )
      .timeout(Duration(seconds: 5));

      
      if (response.statusCode != 200) {
      debugPrint(response.statusCode.toString());
      throw Exception('Error al registrar antropometricos');
      }

      debugPrint("Sending item to API");
      
      
    } catch (e) {
      Exception("Could not send data");
    }
  }
}