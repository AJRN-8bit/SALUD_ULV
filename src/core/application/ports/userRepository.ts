import { User } from "../../domain/user/user.ts";
import type { IUserInfoRegistry, IUserLogin, IUserRegistry } from "../../domain/user/user.ts";
import { UserActivity, type IUserActivityRegistry } from "../../domain/user/userActivity.ts";
import {UserAnthropometric, type IUserAnthropometric} from "../../domain/user/userAntroph.ts";

export default interface IUserRepository{
    registerUser(user: IUserRegistry): Promise<void>;
    registerUserInfo(user: IUserInfoRegistry): Promise<void>;
    loginUser(user: IUserLogin): Promise<void>;

    getUserProfile(userID: number): Promise<User | null>;

    registerUserAnthropometricData(userAnthropometric: IUserAnthropometric): Promise<void>;
    getAllUserAntrophometricData(userID: number): Promise<UserAnthropometric[] | null>;

    registerUserActivity(userActivity: IUserActivityRegistry): Promise<void>;
    getAllUserActivities(userID: number): Promise<UserActivity[] | null>;
    deleteUserActivity(userID: number,activityID: number): Promise<void>;
    
    // editUserAntrophometricData(): Promise<void>;
}