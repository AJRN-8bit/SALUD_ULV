import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';
import 'package:salud_ulv_app/src/core/repositories/repos/anthro_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/services/current_user_session_repo.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';
import 'package:uuid/uuid.dart';

class SaveAnthroUsecase implements ISaveAnthroUseCase{
  final IAnthropometricLocalRepo anthropometricRepo;
  final ICurrentUserSession currentUserSession;

  const SaveAnthroUsecase(this.anthropometricRepo, this.currentUserSession);

  @override
  Future<void> execute(Anthropometrics data) async {
    // data validation

        // ----- Anthropometrics validation: The values can be added a toleration of 2.
    // Heihght range: 100 cm - 250 cm
    if(!(data.height >= 100 && data.height <= 250)){throw Exception("Altura entre 100 cm a 250 cm");}
    
    // Weight range: 30 - 300
    if(!(data.weight >= 30 && data.weight <= 300)){throw Exception("Peso entre 30 - 300");} //stndy

    // SMM range: 10 - 60 kg
    if(!(data.smm >= 10 && data.smm <= 60)){throw Exception("SMM entre 10 - 60 kg");}

    // Fat mass range: 3 - 80 kg
    if(!(data.fatMass >= 3 && data.fatMass <= 80)){throw Exception("Masa Grasa entre 3 - 80 kg");}

    // Body fat percentage range: 3 - 60%
    if(!(data.bodyFatPercentage >= 3 && data.bodyFatPercentage <= 60)){throw Exception("% Grasa entre 3 - 60");}

    // BMI range: 10 - 60
    if(!(data.bmi >= 10 && data.bmi <= 60)){throw Exception("IMC entre 10 - 60");}

    // Waist hip ratio range: 0.5 - 1.3
    if(!(data.whr >= 0.50 && data.whr <= 1.30)){throw Exception("ICC entre 0.5 - 1.3");}


    // Insertion of identifiers
    data.anthropometricID = Uuid().v4().toUpperCase();
    data.userUUID = await currentUserSession.getCurrentUserUUID();
    data.registeredAt = DateTime.now();
    

    await anthropometricRepo.save(data);
  }
}