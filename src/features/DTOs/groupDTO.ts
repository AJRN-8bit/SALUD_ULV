import { Group, type IGroup } from "../../core/models/groups.ts";
import { UserDTO } from "./userDTO.ts";


export class GroupDTO {
    groupID: number | undefined;
    name: string;
    description: string;
    // building: string;
    members: UserDTO[];

    constructor(data: GroupDTO) {
        this.groupID = data.groupID;
        this.name = data.name;
        this.description = data.description;
        // this.building = data.building;
        this.members = data.members;
    }

    // ─── Domain (GroupModel) → DTO ───────────────────
    static fromDomain(group: IGroup): GroupDTO {
        return new GroupDTO({
            groupID: group.groupID,
            name: group.name!,
            description: group.description!,
            // building: group.building!,
            members: group.members?.map(user =>
                UserDTO.fromDomain(user)
            ) ?? [],
        } as GroupDTO);
    }

    // ─── Database row → DTO ─────────────────────────
    // Only converts group fields.
    static fromMap(row: Record<string, any>): GroupDTO {
        return new GroupDTO({
            groupID: row["GroupID"],
            name: row["Name"],
            description: row["Description"],
            // building: row["Building"],
        } as GroupDTO);
    }

    // ─── JSON → DTO ─────────────────────────────────
    // Converts the users from JSON into UserDTOs.
    static fromJson(json: Record<string, any>): GroupDTO {
        return new GroupDTO({
            groupID: json["groupID"],
            name: json["name"],
            description: json["description"],
            // building: json["building"],
            members: json["members"]?.map((user: any) =>
                UserDTO.fromJson(user)
            ) ?? [],
        } as GroupDTO);
    }

    // ─── DTO → Domain (GroupModel) ──────────────────
    // Converts UserDTOs into domain Users.
    toDomain(): Group {
        return new Group(
            this.name,
            this.description,
            // this.building,
            this.members,
            this.groupID
        );
    }

    // ─── DTO → JSON (API response) ──────────────────
    // Converts UserDTOs into JSON.
    toJson(): Record<string, any> {
        return {
            groupID: this.groupID,
            name: this.name,
            description: this.description,
            // building: this.building,
            members: this.members.map(user =>
                user.toJson()
            ),
        };
    }
}


// export class GroupDTO {
//     groupID: number;
//     name: string;
//     description: string;
//     building: string;

//     constructor(data: GroupDTO) {
//         this.groupID = data.groupID;
//         this.name = data.name;
//         this.description = data.description;
//         this.building = data.building;
//     }

//     // ─── Domain (GroupModel) → DTO ───────────────────
//     static fromDomain(group: Group): GroupDTO {
//         return new GroupDTO({
//             groupID: group.groupID,
//             name: group.name!,
//             description: group.description!,
//             building: group.building!,
//         } as GroupDTO);
//     }

//     // ─── Database row → DTO ─────────────────────────
//     static fromMap(row: Record<string, any>): GroupDTO {
//         return new GroupDTO({
//             groupID: Number(row["GroupID"]),
//             name: row["Name"],
//             description: row["Description"],
//             building: row["Building"],
//         } as GroupDTO);
//     }

//     // ─── JSON → DTO ─────────────────────────────────
//     static fromJson(json: Record<string, any>): GroupDTO {
//         return new GroupDTO({
//             groupID: json["groupID"],
//             name: json["name"],
//             description: json["description"],
//             building: json["building"],
//         } as GroupDTO);
//     }

//     // ─── DTO → Domain (GroupModel) ──────────────────
//     // Members are added separately.
//     toDomain(): Group {
//         return new Group(
//             this.name,
//             this.description,
//             this.building
//         );
//     }

//     // ─── DTO → JSON (API response) ──────────────────
//     toJson(): Record<string, any> {
//         return {
//             groupID: this.groupID,
//             name: this.name,
//             description: this.description,
//             building: this.building,
//         };
//     }
// }

