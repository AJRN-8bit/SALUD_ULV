// import 'package:salud_ulv_app/src/core/models/user.dart';
// import 'package:uuid/uuid.dart';
// // import 'package:uuid/v4.dart';
// import 'package:salud_ulv_app/src/core/models/member.dart';
// import 'package:salud_ulv_app/src/core/repositories/repos/auth_repo.dart';
// import 'package:salud_ulv_app/src/core/repositories/repos/user_repo.dart';
// import 'package:salud_ulv_app/src/core/repositories/services/check_connection_repo.dart';
// // import 'package:salud_ulv_app/src/core/repositories/services/current_user_session.dart';
// import 'package:salud_ulv_app/src/core/repositories/services/token_repo.dart';
// import 'package:salud_ulv_app/src/core/repositories/services/token_storage_repo.dart';
// import 'package:salud_ulv_app/src/core/repositories/use-cases/auth_usecase.dart';

// class RegisterMemberUseCase implements IRegisterMemberUseCase{
//   // final ICurrentUserSession currentUserSession;
//   // final IMemberLocalRepo memberLocalRepo;
//   final IAuthExtRepo authExtRepo;

//   final ITokenRepo tokenRepo;
//   final ITokenStorageRepo tokenStorageRepo;
//   final ICheckConnectionRepo checkConnectionRepo;

//   final IMemberLocalRepo memberLocalRepo;
//   final IUserLocalRepo userLocalRepo;

//   const RegisterMemberUseCase(
//     this.authExtRepo,
//     this.tokenRepo,
//     this.tokenStorageRepo,
//     this.checkConnectionRepo,
//     this.memberLocalRepo, 
//     this.userLocalRepo
//     );


//   @override
//   Future<String?> execute(Member memberInfo) async {
//     final hasConnection = await checkConnectionRepo.hasConnection();
//     if(!hasConnection) throw Exception("No internet");


//     // Age calculation
//     final dateOfBirth = memberInfo.dateOfBirth;
    
//     final today = DateTime.now();
//     int age = today.year - dateOfBirth!.year;

//   // Subtract 1 if the birthday hasn't happened yet this year
//     final hasHadBirthdayThisYear = (today.month > dateOfBirth.month) ||
//       (today.month == dateOfBirth.month && today.day >= dateOfBirth.day);

//     if (!hasHadBirthdayThisYear) {
//       age--;
//     }



//     final member = Member(
//       userUUID: Uuid().v4().toUpperCase(),
//       userCode: memberInfo.userCode,
//       firstname: memberInfo.firstname,
//       surname: memberInfo.surname,
//       lastname: memberInfo.lastname,
//       email: memberInfo.email,
//       createdAt: DateTime.now().toUtc(),
//       dateOfBirth: memberInfo.dateOfBirth,
//       gender: memberInfo.gender,
//       age: age
//       );


//     // final token = await authExtRepo.registerMember(memberInfo, password);
//     // if(token == null) throw Exception("Failed to register member info");

//     // await tokenStorageRepo.saveToken(token);





//     final user = User(
//       userUUID: member.userUUID,
//       userCode: member.userCode,
//       firstname: member.firstname,
//       surname: member.surname,
//       lastname: member.lastname,
//       email: member.email,
//       currentRole: "Member",
//       roles: member.roles,
//       createdAt: member.createdAt
//     );

//     final memberInfoLocal = MemberInfo(
//       userUUID: member.userUUID, 
//       dateOfBirth: dateOfBirth, 
//       age: age, 
//       gender: member.gender
//       );


//     await userLocalRepo.save(user);
//     await memberLocalRepo.saveInfo(memberInfoLocal);

//     return 'Member';
//   }
// }