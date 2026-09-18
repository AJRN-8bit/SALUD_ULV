
import 'package:flutter_bloc/flutter_bloc.dart';

// class BottomBarBloc extends Cubit<int>{
//   BottomBarBloc() : super(0);

//   changeSelectedIndex(newIndex) => emit(newIndex);
// }



// --- Events ---
abstract class BottomBarEvent {}

class ChangeSelectedIndex extends BottomBarEvent {
  ChangeSelectedIndex(this.newIndex);
  final int newIndex;
}

// --- Bloc ---
class BottomBarBloc extends Bloc<BottomBarEvent, int> {
  BottomBarBloc({int initialIndex = 0}) : super(initialIndex) {
    on<ChangeSelectedIndex>((event, emit) {
      emit(event.newIndex);
    });
  }
}