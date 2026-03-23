import { User } from "../../domain/user/user.ts";
import { UserActivity} from "../../domain/user/userActivity.ts";
import {UserAnthropometric} from "../../domain/user/userAntroph.ts";
import {Group} from "../../domain/group/group.ts";
import {GroupActivities} from "../../domain/group/groupActivities.ts";


export default interface IAdminRepository{
    findUserByEmail(email: string): Promise<User | null>;
    findUserByID(userID: number): Promise<User | null>;
    getAllUsers(): Promise<User[] | null>;

    getAllUsersActivities(): Promise<UserActivity[] | null>;

    getAllUsersAnthropometricData(): Promise<UserAnthropometric[] | null>;

    getAllGroups(): Promise<Group[] | null>;
    getAllGroupsActivities(): Promise<GroupActivities[] | null>;
    getGroupActivities(groupID: number): Promise<GroupActivities[] | null>;

}