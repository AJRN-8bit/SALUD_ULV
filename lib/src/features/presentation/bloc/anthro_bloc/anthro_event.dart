
import 'package:salud_ulv_app/src/core/models/anthropometrics.dart';

abstract class AnthroEvent {}

class SaveAnthroEvent extends AnthroEvent{
  final Anthropometrics data;
  SaveAnthroEvent(this.data);
}

class AnthroGetRecentEvent extends AnthroEvent{}
class AnthroGetAllEvent extends AnthroEvent{}

class AnthroGetByFieldEvent extends AnthroEvent{
  final String field;
  AnthroGetByFieldEvent(this.field);
}

class AnthroSyncPending extends AnthroEvent{}



// Admin
class AnthroGetByUserCodeEvent extends AnthroEvent{
  final String userCode;
  AnthroGetByUserCodeEvent(this.userCode);
}