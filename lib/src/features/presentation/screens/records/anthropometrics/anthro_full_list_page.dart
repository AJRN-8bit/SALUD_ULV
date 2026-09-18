import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/getall_usecase.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/anthro_repo.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_state.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/listviews.dart';

class AllAnthroRecordsPage extends StatelessWidget{
  const AllAnthroRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetAnthroAllBloc(getallAnthroUsecase: GetallAnthroUsecase(AnthroLocalStorage(), CurrentUserSession())
      ),
      
      child: const _AllAnthroRecordsPage()
    );
  }
}


class _AllAnthroRecordsPage extends StatefulWidget{
  const _AllAnthroRecordsPage();

  @override
  State<_AllAnthroRecordsPage> createState() => _AllAnthroRecordsPageState();
}



class _AllAnthroRecordsPageState extends State<_AllAnthroRecordsPage>{
   final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    context.read<GetAnthroAllBloc>().add(AnthroGetAllEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(250),
      body: BlocListener<GetAnthroAllBloc, AnthroState>(
            listener: (context, state) {

              if(state is AnthroError){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)));
              }
            },

          child: SafeArea(
            child: SingleChildScrollView(
              key: _formKey,
              scrollDirection: .vertical,
              child: Center(
                child: Column(
                  children: [                       
                          
                    BlocBuilder<GetAnthroAllBloc, AnthroState>(
                      builder: (context, state) {
                        if(state is AnthroLoading){
                          return const CircularProgressIndicator();
                        }
                
                        if(state is AnthroListLoaded){
                          if(state.data == null || state.data!.isEmpty) {
                            return const SizedBox(child: Text("No data"),);
                            
                          }
                          // return AnthropRecordsListView(data: state.data!);
                          return SizedBox();
                        }
                
                        return const SizedBox();
                      }),
                          
                      const SizedBox(height: 40,),
            
                  ],
                ),
              ),
            ),
          ),
        )
      );
  }
}