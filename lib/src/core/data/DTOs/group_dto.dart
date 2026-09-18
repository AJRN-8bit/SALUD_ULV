import 'package:salud_ulv_app/src/core/models/group.dart';
import 'user_dto.dart';


class GroupDTO {
  final int? groupID;
  final String? name;
  final String? description;
  // final String? building;
  final List<UserDTO> members;

  GroupDTO({
    required this.groupID,
    required this.name,
    required this.description,
    // required this.building,
    required this.members,
  });

  // ─── JSON → DTO ──────────────────────────────────
  factory GroupDTO.fromJson(Map<String, dynamic> json) {
    return GroupDTO(
      groupID: json['groupID'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // building: json['building'] ?? '',
      members: (json['members'] as List<dynamic>? ?? [])
          .map(
            (user) => UserDTO.fromGroupJson(
              user as Map<String, dynamic>,
            ),
          )
          .toList(),
      // members: []
    );
  }

  // ─── DTO → Domain ─────────────────────────────────
  Group toDomain() {
    return Group(
      groupID: groupID,
      name: name,
      description: description,
      // building: building,
      members: members
          .map((user) => user.toDomain())
          .toList(),
    );
  }

  // ─── DTO → JSON ──────────────────────────────────
  // Map<String, dynamic> toJson() {
  //   return {
  //     'groupID': groupID,
  //     'name': name,
  //     'description': description,
  //     'building': building,
  //     'members': members
  //         .map((user) => user.toJson())
  //         .toList(),
  //   };
  // }
}
