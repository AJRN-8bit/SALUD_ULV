
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/repositories/use-cases/group_usecases.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/group_bloc/group_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/group_bloc/group_state.dart';



class GetGroupsListBLoc extends Bloc<GroupEvent, GroupState>{
  final IGetGroupListUseCase getGroupsList;

  GetGroupsListBLoc({required this.getGroupsList}) : super(GroupInitial()) {
    on<LoadGroupsListEvent>((event, emit) async {
      try {
        emit(GroupLoading());
        final groupsList = await getGroupsList.execute();
        // debugPrint(departments.toString());
        emit(ListGroupLoaded(groupsList!));
      } catch (e) {
        debugPrint(e.toString());
        emit(GroupError('Could not load groups'));
      }
    });
  }
}



class JoinGroupBloc extends Bloc<GroupEvent, GroupState>{
  final IJoinGroupUseCase joinGroupUseCase;

  JoinGroupBloc({required this.joinGroupUseCase}) : super(GroupInitial()) {
    on<JoinGroupEvent>((event, emit) async {
      try {
        emit(GroupLoading());
        await joinGroupUseCase.execute(event.groupID);
        emit(GroupMember());
      } catch (e) {
        emit(GroupError('Could not join group'));
      }
    });
  }
}



class GetMemberGroupBLoc extends Bloc<GroupEvent, GroupState>{
  final IGetMemberGroupUseCase getMemberGroupUseCase;

  GetMemberGroupBLoc({required this.getMemberGroupUseCase}) : super(GroupInitial()) {
    on<LoadMemberGroupEvent>((event, emit) async {
      try {
        emit(GroupLoading());
        final group = await getMemberGroupUseCase.execute();
        emit(GroupLoaded(group!));
      } catch (e) {
        debugPrint(e.toString());
        emit(GroupError('Could not load group'));
      }
    });
  }
}


class CheckGroupMembershipBLoc extends Bloc<GroupEvent, GroupState>{
  final ICheckGroupMembershipUseCase checkGroupMembershipUseCase;

  CheckGroupMembershipBLoc({required this.checkGroupMembershipUseCase}) : super(GroupInitial()) {
    on<CheckGroupMembershipEvent>((event, emit) async {
      try {
        emit(GroupLoading());
        final hasGroup = await checkGroupMembershipUseCase.execute();

        if(!hasGroup) {
          emit(GroupNotMember());
        } else {
          emit(GroupMember());
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(GroupError('Could not load group'));
      }
    });
  }
}

