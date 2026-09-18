
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:salud_ulv_app/src/core/models/member.dart';
// import 'package:salud_ulv_app/src/core/models/user.dart';
// import 'package:salud_ulv_app/src/core/usecase/auth/login_usecase.dart';
// import 'package:salud_ulv_app/src/core/usecase/auth/register_member_info.dart';
// import 'package:salud_ulv_app/src/core/usecase/auth/register_user_usecase.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/check_connection.dart';
// // import 'package:salud_ulv_app/src/features/data/source/local/services/current_user_session.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/token.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/services/token_storage.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/sqflite/member_repo.dart';
// import 'package:salud_ulv_app/src/features/data/source/local/sqflite/user_repo.dart';
// import 'package:salud_ulv_app/src/features/data/source/network/auth_controller.dart';
// import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_bloc.dart';
// import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_event.dart';
// import 'package:salud_ulv_app/src/features/presentation/bloc/auth_bloc/auth_state.dart';
// import 'package:salud_ulv_app/src/features/presentation/screens/auth/sign_up_page.dart';



// class RegistryInfoPage extends StatelessWidget {
//   final String userCode;
//   final String email;
//   final String password;

//   const RegistryInfoPage({
//     super.key,
//     required this.userCode,
//     required this.email,
//     required this.password,
//     });


//   @override
//   Widget build(BuildContext context){
//     return BlocProvider(
//       create: (context) => RegisterBloc(
//         registryUsecase: RegisterUserUsecase(
//           AuthHTTPController(), UserLocalRepo(), CheckConnection(), TokenStorage(), TokenHandler())
//       ),
      
//       child: _RegistryInfoPage(
//         userCode: userCode,
//         email: email,
//         password: password,
//       )
//     );
//   }
// }





// class _RegistryInfoPage extends StatefulWidget  {
//   // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   final String userCode;
//   final String email;
//   final String password;

//    const _RegistryInfoPage({
//     required this.userCode,
//     required this.email,
//     required this.password,
//   });

//    @override
//    State<_RegistryInfoPage> createState() => _RegistryInfoPageState();
// }




// class _RegistryInfoPageState extends State<_RegistryInfoPage> {
//   // Need of controller for a custom texform entry
//   final String genderSelected = '';
//   final _formKey = GlobalKey<FormState>();
//   final _firstnameController = TextEditingController();
//   final _surnameController = TextEditingController();
//   final _lastnameController = TextEditingController();

//   final _dateController = TextEditingController();
//   final _genderController = TextEditingController();
//   // final _occupationController = TextEditingController();

//   DateTime? _dateOfBirth;
//   String? _dobError;
//   int _currentStep = 0;



//   @override
//   void dispose() {
//     _firstnameController.dispose();
//     _surnameController.dispose();
//     _lastnameController.dispose();

//     _dateController.dispose();
//     _genderController.dispose();
//     // _occupationController.dispose();
//     super.dispose();
//   }




//   Future<void> _pickDateOfBirth() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(now.year - 26, now.month, now.day),
//       firstDate: DateTime(1900),
//       lastDate: now,
//       helpText: 'Select date of birth',
//     );
//     if (picked != null) {
//       setState(() {
//         _dateOfBirth = picked;
//         _dobError = null;
//       });
//     }
//   }

//   bool _validateStep(int step) {
//     switch (step) {
//       case 0:
//         return _firstnameController.text.isNotEmpty &&
//             _surnameController.text.isNotEmpty &&
//             _lastnameController.text.isNotEmpty;
//       case 1:
//         if (_dateOfBirth == null) {
//           setState(() => _dobError = 'Please select your date of birth');
//           return false;
//         }
//         return _genderController.text.isNotEmpty;
//       default:
//         return true;
//     }
//   }

//   void _onStepContinue() {
//     if (!_validateStep(_currentStep)) return;
//     if (_currentStep < 2) {
//       setState(() => _currentStep++);
//     } else {
//       _onFinalSubmit();
//     }
//   }

//   void _onStepCancel() {
//     if (_currentStep > 0) setState(() => _currentStep--);
//   }

//   void _onFinalSubmit() {
//     if (!_formKey.currentState!.validate() || _dateOfBirth == null) return;

//     final user = User(
//       userCode: widget.userCode,
//       firstname: _firstnameController.text.trim(), 
//       surname: _surnameController.text.trim(), 
//       lastname: _lastnameController.text.trim(), 
//       email: widget.email, 
//       // dateOfBirth: _dateOfBirth!, 
//       // gender: _genderController.text.trim()
//       );

//     context.read<RegisterBloc>().add(RegisterEvent(user: user, password: widget.password));
//   }




  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white.withAlpha(250),
//       body: BlocListener<RegisterBloc, AuthState>(
//         listener: (context, state) {
//           if(state is LoginAuthenticated){
//             switch (state.currentRole) {
//               case 'Member':
//                 Navigator.of(context).pushReplacementNamed('/home/user');
//                 break;
//               case 'C':
//                 Navigator.of(context).pushReplacementNamed('/home/coach');
//                 break;
//               case 'A':
//                 Navigator.of(context).pushReplacementNamed('/home/admin');
//                 break;
//               default:
//                 Navigator.of(context).pushReplacementNamed('/login');
//             }          
//           }

//           if(state is AuthError){
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }

        

//         },


//         child: BlocBuilder<RegisterBloc, AuthState>(
//           builder: (context, state) {
//             return Form(
//               key: _formKey,
//               child: Stepper(
//                 type: .horizontal,
//                 currentStep: _currentStep,
//                 onStepContinue: _onStepContinue,
//                 onStepCancel: _onStepCancel,
//                 controlsBuilder: (context, details) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Row(
//                       children: [
//                         state is AuthLoading
//                             ? const CircularProgressIndicator()
//                             : ElevatedButton(
//                                 onPressed: details.onStepContinue,
//                                 child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
//                               ),
//                         const SizedBox(width: 8),
//                         if (_currentStep > 0)
//                           TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
//                       ],
//                     ),
//                   );
//                 }, 
                
                
//                 steps: [
//                   Step(
//                     title: const Text('Personal Info'),
//                     isActive: _currentStep >= 0,
//                     state: _currentStep > 0 ? StepState.complete : StepState.indexed,
//                     content: Column(
//                       children: [
//                         TextFormField(
//                           controller: _firstnameController,
//                           decoration: const InputDecoration(labelText: 'Name'),
//                           validator: (v) => v!.isEmpty ? 'Enter your name' : null,
//                         ),
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           controller: _surnameController,
//                           decoration: const InputDecoration(labelText: 'Surname'),
//                           validator: (v) => v!.isEmpty ? 'Enter your surname' : null,
//                         ),
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           controller: _lastnameController,
//                           decoration: const InputDecoration(labelText: 'Last name'),
//                           validator: (v) => v!.isEmpty ? 'Enter your last name' : null,
//                         ),
//                       ],
//                     ),
//                   ),


//                   Step(
//                     title: const Text('Date of Birth & Gender'),
//                     isActive: _currentStep >= 1,
//                     state: _currentStep > 1 ? StepState.complete : StepState.indexed,
//                     content: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: _pickDateOfBirth,
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               labelText: 'Date of birth',
//                               errorText: _dobError,
//                               suffixIcon: const Icon(Icons.calendar_today),
//                             ),
//                             child: Text(_dateOfBirth == null
//                                 ? 'Select a date'
//                                 : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),


//                   Step(
//                     title: const Text('Gender'),
//                     isActive: _currentStep >= 2,
//                     state: StepState.indexed,
//                     content: Column(
//                       mainAxisAlignment: .center,

//                       children: [
//                         Text("Gender"),

//                         Row(
//                           mainAxisAlignment: .center,

//                           children: [
//                            RadioMenuButton(
//                             value: 'male', 
//                             groupValue: genderSelected, 
//                             onChanged: (selectedValue) {
//                               setState(() {
//                                 _genderController.text = selectedValue!;
//                               });
//                             }, 
//                             child: const Text('Male'),
//                             ),

//                             RadioMenuButton(
//                             value: 'female', 
//                             groupValue: genderSelected, 
//                             onChanged: (selectedValue) {
//                               setState(() {
//                                 _genderController.text = selectedValue!;
//                               });
//                             }, 
//                             child: const Text('Female'),
//                             ),

                            
//                           ],
//                         )
//                       ],
//                     )
//                   ),
//                 ],
//               ),
//             );
//           }
//         )
//       )
//     ); 
//   }
// }
