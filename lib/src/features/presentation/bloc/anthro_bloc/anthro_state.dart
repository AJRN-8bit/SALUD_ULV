
import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';

abstract class AnthroState {}

class AnthroInitial extends AnthroState{}
class AnthroLoading extends AnthroState{}

class AnthroSaved extends AnthroState{}
class AnthroSyncPendingState extends AnthroState{}
class AnthroSent extends AnthroState{}




class AnthroRecentLoaded extends AnthroState{
  final Anthropometrics? data;
  AnthroRecentLoaded(this.data);
}


// Shared
class AnthroListLoaded extends AnthroState{
  final List<Anthropometrics>? data;
  AnthroListLoaded(this.data);
}



class AnthroFieldListLoaded extends AnthroState{
  final List<Map<String, dynamic>>? data;
  AnthroFieldListLoaded(this.data);
}


class AnthroError extends AnthroState{
  final String message;
  AnthroError(this.message);
}
