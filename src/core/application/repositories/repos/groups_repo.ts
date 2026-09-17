import type { Group, IGroup } from "../../../models/groups.ts";
import type { IUser } from "../../../models/user.ts";


export interface IGroupRepo {
    userExists(userUUID: string): Promise<boolean>;
    groupExists(groupID: number, typeID: number): Promise<boolean>;

    getGroupsList(typeID: number): Promise<IGroup[] | null>;
    getLowerLevelGroups(groupID: number): Promise<IGroup[] | null>;
    addMember(groupID: number, userUUID: string): Promise<void>;

    getGroupInfo(groupID: number, typeID: number): Promise<IGroup | null>;
    getGroupMembers(groupID: number, typeID: number): Promise<IUser[] | null>;
}