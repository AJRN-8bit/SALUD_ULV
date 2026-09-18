

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/models/exercises.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/get_all_exercise.dart';
import 'package:salud_ulv_app/src/core/usecase/exercises/get_recent_exercise.dart';
import 'package:salud_ulv_app/src/core/data/DTOs/walk_dto.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/walk_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/exercise_bloc/exercise_state.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/listviews.dart';

class AllWalkRecordsPage extends StatelessWidget{
  const AllWalkRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseGetAllBLoc(allExerciseUseCase: GetAllExerciseUseCase(WalkRepo(), CurrentUserSession())
      ),

      child: const _AllWalkRecordsPage()
    );
  }
}


class _AllWalkRecordsPage extends StatefulWidget{
  const _AllWalkRecordsPage();

  @override
  State<_AllWalkRecordsPage> createState() => _AllWalkRecordsPageState();
}



class _AllWalkRecordsPageState extends State<_AllWalkRecordsPage>{
   final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    context.read<ExerciseGetAllBLoc>().add(ExerciseGetAllEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(250),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ExerciseGetAllBLoc, ExerciseState>(
            listener: (context, state) {

              if(state is ExerciseError){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)));
              }
            }      
          ),
        ],



        child: SafeArea(
          child: SingleChildScrollView(
            key: _formKey,
            scrollDirection: .vertical,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 100,),
                      
          
                  BlocBuilder<ExerciseGetAllBLoc, ExerciseState>(
                    builder: (context, state) {
                      if(state is ExerciseLoading){
                        return const CircularProgressIndicator();
                      }
              
                      if(state is ExerciseListLoaded){
                          
                        final walk = state.data!.cast<Walk>();
                        debugPrint(' Walk list ${walk.toString()}');
                        debugPrint(' Walk list ${walk.length.toString()}');

                        
                        }     
                        return const SizedBox();                  
                      }                     
                    ),
                    const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}