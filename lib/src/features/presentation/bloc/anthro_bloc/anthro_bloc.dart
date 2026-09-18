import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/anthropometric_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/get_bycode_admin_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/get_byfield_usecase.dart';
import 'package:salud_ulv_app/src/core/usecase/anthropometrics/getall_admin_usecase.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/anthro_bloc/anthro_state.dart';

class SaveAnthroBloc extends Bloc<AnthroEvent, AnthroState> {
  final ISaveAnthroUseCase saveAnthroUsecase;

  SaveAnthroBloc({required this.saveAnthroUsecase}) : super(AnthroInitial()) {
    on<SaveAnthroEvent>((event, emit) async {
      try {
        emit(AnthroLoading());
        await saveAnthroUsecase.execute(event.data);
        emit(AnthroSaved());
      } catch (e) {
        emit(AnthroError("Couldn't save data"));
      }
    });
  }
}

class GetAnthroRecentBloc extends Bloc<AnthroEvent, AnthroState> {
  final IGetRecentAnthroUseCase getRecentAnthroUsecase;

  GetAnthroRecentBloc({required this.getRecentAnthroUsecase})
    : super(AnthroInitial()) {
    on<AnthroGetRecentEvent>(_getRecent);
  }

  Future<void> _getRecent(
    AnthroGetRecentEvent event,
    Emitter<AnthroState> emit,
  ) async {
    try {
      emit(AnthroLoading());
      final data = await getRecentAnthroUsecase.execute();
      emit(AnthroRecentLoaded(data));
    } catch (e) {
      emit(AnthroError("Couldn't get recent data"));
    }
  }
}

class GetAnthroAllBloc extends Bloc<AnthroEvent, AnthroState> {
  final IGetAllAnthroUseCase getallAnthroUsecase;

  GetAnthroAllBloc({required this.getallAnthroUsecase})
    : super(AnthroInitial()) {
    on<AnthroGetAllEvent>(_getAll);
  }

  Future<void> _getAll(
    AnthroGetAllEvent event,
    Emitter<AnthroState> emit,
  ) async {
    try {
      emit(AnthroLoading());
      final data = await getallAnthroUsecase.execute();
      emit(AnthroListLoaded(data));
    } catch (e) {
      emit(AnthroError("Couldn't get data"));
    }
  }
}

class GetAnthroByFieldBloc extends Bloc<AnthroEvent, AnthroState> {
  final GetByfieldAnthroUsecase getByfieldAnthroUsecase;

  GetAnthroByFieldBloc({required this.getByfieldAnthroUsecase})
    : super(AnthroInitial()) {
    on<AnthroGetByFieldEvent>(_getByField);
  }

  Future<void> _getByField(
    AnthroGetByFieldEvent event,
    Emitter<AnthroState> emit,
  ) async {
    try {
      emit(AnthroLoading());
      final data = await getByfieldAnthroUsecase.execute(event.field);
      emit(AnthroFieldListLoaded(data));
    } catch (e) {
      emit(AnthroError("Couldn't get recent data"));
    }
  }
}

class SendAnhroBloc extends Bloc<AnthroEvent, AnthroState> {
  // Checks if there is unsynced data with the API
  final ISendAnthroUseCase sendAnthroUsecase;

  SendAnhroBloc({required this.sendAnthroUsecase}) : super(AnthroInitial()) {
    on<AnthroSyncPending>(_send);
  }

  Future<void> _send(AnthroSyncPending event, Emitter<AnthroState> emit) async {
    try {
      emit(AnthroSyncPendingState());
      final sent = await sendAnthroUsecase.execute();

      if (sent) {
        emit(AnthroSent());
      }
    } catch (e) {
      emit(AnthroError("Couldn't send data"));
    }
  }
}

// Admin
class AnthroGetAllAdminBloc extends Bloc<AnthroEvent, AnthroState> {
  final GetallAnthroAdminUsecase getallAnthroUsecase;

  AnthroGetAllAdminBloc({required this.getallAnthroUsecase})
    : super(AnthroInitial()) {
    on<AnthroGetAllEvent>(_getAll);
  }

  Future<void> _getAll(
    AnthroGetAllEvent event,
    Emitter<AnthroState> emit,
  ) async {
    try {
      emit(AnthroLoading());
      final data = await getallAnthroUsecase.execute();
      emit(AnthroListLoaded(data));
    } catch (e) {
      emit(AnthroError("Couldn't get data"));
    }
  }
}

class AnthroGetByUserCodeBloc extends Bloc<AnthroEvent, AnthroState> {
  final IGetByUserCodeAdminUseCase getByUserCodeUsecase;

  AnthroGetByUserCodeBloc({required this.getByUserCodeUsecase})
    : super(AnthroInitial()) {
    on<AnthroGetByUserCodeEvent>(_getByCode);
  }

  Future<void> _getByCode(
    AnthroGetByUserCodeEvent event,
    Emitter<AnthroState> emit,
  ) async {
    try {
      emit(AnthroLoading());
      final data = await getByUserCodeUsecase.execute(event.userCode);
      emit(AnthroListLoaded(data));
    } catch (e) {
      emit(AnthroError("Couldn't get data"));
    }
  }
}

class AnthroGetDataAdminBloc extends Bloc<AnthroEvent, AnthroState> {
  final GetallAnthroAdminUsecase getallAnthroUsecase;
  final GetByUserCodeUsecase getByUserCodeUsecase;

  AnthroGetDataAdminBloc({
    required this.getByUserCodeUsecase,
    required this.getallAnthroUsecase,
  }) : super(AnthroInitial()) {
    on<AnthroGetAllEvent>((event, emit) async {
      try {
        emit(AnthroLoading());
        final data = await getallAnthroUsecase.execute();
        emit(AnthroListLoaded(data));
      } catch (e) {
        emit(AnthroError("Couldn't get data"));
      }
    });

    on<AnthroGetByUserCodeEvent>((event, emit) async {
      try {
        emit(AnthroLoading());
        final data = await getByUserCodeUsecase.execute(event.userCode);
        emit(AnthroListLoaded(data));
      } catch (e) {
        emit(AnthroError("Couldn't get data"));
      }
    });
  }
}
