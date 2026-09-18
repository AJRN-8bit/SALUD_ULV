import type { IGroupRepo } from "../../../../core/application/repositories/repos/groups_repo.ts";
import { type IGroup } from "../../../../core/models/groups.ts";
import type { IUser } from "../../../../core/models/user.ts";
export default class GroupRepo implements IGroupRepo {
    userExists(userUUID: string): Promise<boolean>;
    groupExists(groupID: number): Promise<boolean>;
    getGroupsList(typeID: number): Promise<IGroup[] | null>;
    addMember(groupID: number, userUUID: string): Promise<void>;
    getGroupMembers(groupID: number): Promise<IUser[] | null>;
    getGroupInfo(groupID: number): Promise<IGroup | null>;
    getLowerLevelGroups(): Promise<IGroup[] | null>;
}
//# sourceMappingURL=group_repo.d.ts.map