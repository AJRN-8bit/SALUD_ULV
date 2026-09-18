import { Group, type IGroup } from "../../core/models/groups.ts";
import { UserDTO } from "./userDTO.ts";
export declare class GroupDTO {
    groupID: number | undefined;
    name: string;
    description: string;
    members: UserDTO[];
    constructor(data: GroupDTO);
    static fromDomain(group: IGroup): GroupDTO;
    static fromMap(row: Record<string, any>): GroupDTO;
    static fromJson(json: Record<string, any>): GroupDTO;
    toDomain(): Group;
    toJson(): Record<string, any>;
}
//# sourceMappingURL=groupDTO.d.ts.map