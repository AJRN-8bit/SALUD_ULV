


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/get_bycode_admin_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/getall_admin_usecase.dart';
import 'package:salud_ulv_app/src/features/services/check_connection.dart';
import 'package:salud_ulv_app/src/core/data/source/network/anthro_controller.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_state.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/listviews.dart';

class GetAnthroAdminPage extends StatelessWidget{
  const GetAnthroAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (context) => AnthroGetAllAdminBloc(
        //   getallAnthroUsecase: GetallAnthroAdminUsecase(AnthroHTTPController(), CheckConnection()))),

        // BlocProvider(create: (context) => AnthroGetByUserCodeBloc(
        //   getByUserCodeUsecase: GetByUserCodeUsecase(AnthroHTTPController(), CheckConnection()))),

        BlocProvider(create: (context) => AnthroGetDataAdminBloc(
          getByUserCodeUsecase: GetByUserCodeUsecase(AnthroController(), CheckConnection()), 
          getallAnthroUsecase: GetallAnthroAdminUsecase(AnthroController(), CheckConnection())
          )),
      ], 
      child: _GetAnthroAdminPage()
      );
  }
}


class _GetAnthroAdminPage extends StatefulWidget{
  const _GetAnthroAdminPage();

  @override
  State<_GetAnthroAdminPage> createState() => _GetAnthroAdminPageState();
}


class _GetAnthroAdminPageState extends State<_GetAnthroAdminPage>{
   final _formKey = GlobalKey<FormState>();
   final _userCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // context.read<AnthroGetAllAdminBloc>().add(AnthroGetAllEvent());
    context.read<AnthroGetDataAdminBloc>().add(AnthroGetAllEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _userCodeController.dispose();
  }


   void _onSearch() {
    final value = _userCodeController.text.trim();
    if (value.isEmpty) {
      context.read<AnthroGetDataAdminBloc>().add(AnthroGetAllEvent());
    } else {
      context.read<AnthroGetDataAdminBloc>().add(AnthroGetByUserCodeEvent(value));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(250),
      body: MultiBlocListener(
        listeners: [

          // BlocListener<AnthroGetAllAdminBloc, AnthroState>(
          //   listener: (context, state) {

          //     if(state is AnthroError){
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text(state.message)));
          //     }
          //   }      
          // ),

          BlocListener<AnthroGetDataAdminBloc, AnthroState>(
            listener: (context, state){

              if(state is AnthroError){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)));
              }
            })
        ],



        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextField(
              controller: _userCodeController,
              textInputAction: .done,
              keyboardType: const TextInputType.numberWithOptions() ,
              onSubmitted: (_) => _onSearch(),
            ),

            SizedBox(height: 20,),

            SingleChildScrollView(
              key: _formKey,
              scrollDirection: .vertical,
              child: Column(
                children: [
            
                  BlocBuilder<AnthroGetDataAdminBloc, AnthroState>(
                    builder: (context, state) {
                      if(state is AnthroLoading){
                        return const CircularProgressIndicator();
                      }
              
                      if(state is AnthroListLoaded){
                        if(state.data == null || state.data!.isEmpty){
                          return const SizedBox(child: Text("No data"));
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
          ],
        ),
      ),
    );
  }
}