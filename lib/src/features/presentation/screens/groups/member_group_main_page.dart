import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salud_ulv_app/src/core/models/group.dart';
import 'package:salud_ulv_app/src/core/usecase/group/check_membership_use_case.dart';
import 'package:salud_ulv_app/src/core/usecase/group/get_groups_list.dart';
import 'package:salud_ulv_app/src/core/usecase/group/get_member_group.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/containers.dart';
import 'package:salud_ulv_app/src/features/services/check_connection.dart';
import 'package:salud_ulv_app/src/core/data/source/token/current_user_service.dart';
import 'package:salud_ulv_app/src/core/data/source/local/sqflite/member_repo.dart';
import 'package:salud_ulv_app/src/core/data/source/network/group_controller.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/group_bloc/group_bloc.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/group_bloc/group_event.dart';
import 'package:salud_ulv_app/src/features/presentation/bloc/group_bloc/group_state.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/listviews.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/snackbar.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';

class MemberGroupPage extends StatelessWidget {
  const MemberGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetMemberGroupBLoc(
            getMemberGroupUseCase: GetMemberGroupUseCase(
              CurrentUserSession(),
              GroupController(),
              MemberLocalRepo(),
              CheckConnection(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => CheckGroupMembershipBLoc(
            checkGroupMembershipUseCase: CheckMembershipUseCase(
              MemberLocalRepo(),
              CurrentUserSession(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => GetGroupsListBLoc(
            getGroupsList: GetGroupsListUseCase(
              CheckConnection(),
              GroupController(),
              CurrentUserSession(),
              MemberLocalRepo(),
            ),
          ),
        ),
      ],
      child: _MemberGroupPage(),
    );
  }
}

class _MemberGroupPage extends StatefulWidget {
  const _MemberGroupPage();

  @override
  State<_MemberGroupPage> createState() => _MemberGroupPageState();
}

class _MemberGroupPageState extends State<_MemberGroupPage> {
  final _formKey = GlobalKey<FormState>();

  late List<Group> _groupList;

  @override
  void initState() {
    super.initState();
    // context.read<AnthroGetAllAdminBloc>().add(AnthroGetAllEvent());
    context.read<CheckGroupMembershipBLoc>().add(CheckGroupMembershipEvent());
    // context.read<GetMemberGroupBLoc>().add(LoadMemberGroupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,

      body: SafeArea(
        top: true,
        bottom: true,

        child: MultiBlocListener(
          listeners: [
            BlocListener<CheckGroupMembershipBLoc, GroupState>(
              listener: (context, state) {
                if (state is GroupError) {
                  CustomSnackBar.show(context, message: state.message);
                }
              },
            ),

            BlocListener<GetMemberGroupBLoc, GroupState>(
              listener: (context, state) {
                if (state is GroupError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),

            BlocListener<GetGroupsListBLoc, GroupState>(
              listener: (context, state) {
                if (state is GroupError) {
                  CustomSnackBar.showError(context, state.message);
                }
              },
            ),
          ],

          child: SingleChildScrollView(
            key: _formKey,
            scrollDirection: .vertical,

            child: Padding(
              padding: EdgeInsets.all(context.spacing.md),
              child: Column(
                mainAxisAlignment: .center,
                // crossAxisAlignment: .center,
                children: [
                  BlocBuilder<CheckGroupMembershipBLoc, GroupState>(
                    builder: (context, state) {
                      if (state is GroupMember) {
                        return BlocBuilder<GetMemberGroupBLoc, GroupState>(
                          builder: (context, state) {
                            if (state is GroupLoading) {
                              return Center(
                                child: const CircularProgressIndicator(),
                              );
                            }

                            if (state is GroupLoaded) {
                              final group = state.group;

                              return Padding(
                                padding: const EdgeInsets.all(20),

                                child: Column(
                                  // mainAxisAlignment: .center,
                                  crossAxisAlignment: .stretch,

                                  children: [
                                    Text(group.name!),
                                    Text(group.description!),
                                    // Text(group.building!),

                                    const SizedBox(height: 10),

                                    MembersList(members: group.members!),
                                  ],
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        );
                      }

                      if (state is GroupNotMember) {
                        return BlocBuilder<GetGroupsListBLoc, GroupState>(
                          builder: (context, state) {
                            if (state is ListGroupLoaded) {
                              _groupList = state.departments.cast<Group>();

                              return Column(
                                children: [
                                  CustomTextWidget(
                                    label: "Grupos disponibles",
                                    fontSize: context.fontsSize.headline,
                                  ),
                                  SizedBox(height: context.spacing.md),
                                  CustomTextWidget(
                                    label:
                                        "Unete al grupo de ULV que perteneces",
                                    fontSize: context.fontsSize.body,
                                  ),
                                  SizedBox(height: context.spacing.xl),

                                  BackgroundContainer(
                                    pHeight: 450,
                                    child: CustomListView(
                                      orientation: RowOrientation
                                          .vertical, // o horizontal, según necesites
                                      widgets: _groupList.map((group) {
                                        return Column(
                                          children: [
                                            CustomTextWidget(
                                              label: group.name!,
                                              fontSize: context.fontsSize.body,
                                            ),
                                            SizedBox(
                                              height: context.spacing.md,
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Center(
                              child: Column(
                                children: [
                                  SizedBox(height: context.spacing.xxl),
                                  CustomTextWidget(
                                    label:
                                        "Al parecer no perteneces a un grupo",
                                    fontSize: context.fonts.title,
                                  ),
                                  SizedBox(height: context.spacing.md),
                                  CustomTextWidget(
                                    label:
                                        "Unete a tu área de trabajo para sumar actividades fisicas en equipo",
                                    fontSize: context.fonts.caption,
                                  ),
                                  SizedBox(height: context.spacing.lg),

                                  SimpleButton(
                                    label: "Unirme",
                                    onPressed: () => context
                                        .read<GetGroupsListBLoc>()
                                        .add(LoadGroupsListEvent()),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
