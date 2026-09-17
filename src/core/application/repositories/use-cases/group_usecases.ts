import type { IGroup } from "../../../models/groups.ts";
import type { IUser } from "../../../models/user.ts";


export interface IAddMemberUseCase {
    execute(groupID: number, userUUID: string): Promise<void>;
}

export interface IGetGroupWithMembersUseCase {
    execute(groupID: number, occupationID: number): Promise<IGroup | null>;
}

export interface IGetGroupsList{
    execute(typeID: number): Promise<IGroup[] | null>;
}
