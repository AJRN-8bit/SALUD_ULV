import type IAdminRepository from "../../../core/application/ports/adminRepository.ts";
import { database } from "../config/mssql.ts";
import sql from "mssql";
import { User } from "../../../core/domain/user/user.ts";
import { UserActivity } from "../../../core/domain/user/userActivity.ts";
import { UserAnthropometric } from "../../../core/domain/user/userAntroph.ts";
import { Group } from "../../../core/domain/group/group.ts";
import { GroupActivities } from "../../../core/domain/group/groupActivities.ts";


export default class SQLRepository implements IAdminRepository {


// -----------------------------------------------------------------------------------------------------------------------------------------
    async getAllUsers(): Promise<User[] | null> {
        try {
            await database.connect();

            const foundUsers = await database.request()
            .query(`SELECT * FROM Users`);

            await database.close();

            if(foundUsers.recordset.length === 0) return null;

            const users: User[] = foundUsers.recordset.map(
                row => new User(
                    row.UserID,
                    row.Name,
                    row.FirstName,
                    row.LastName,
                    row.Email,
                    row.Password,
                    row.BirthDate,
                    row.Age,
                    row.Gender,
                    row.CreatedAt
                )
            );

            return users;
            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
async findUserByEmail(email: string): Promise<User | null> {
    return null;
}


// -----------------------------------------------------------------------------------------------------------------------------------------
async findUserByID(userID: number): Promise<User | null> {
    return null;
}


// -----------------------------------------------------------------------------------------------------------------------------------------
    async getAllUsersActivities(): Promise<UserActivity[] | null> {
        try {
            await database.connect();

            const foundUsersActivities = await database.request()
            .query(`SELECT * FROM Activities`);

            await database.close();

            if(foundUsersActivities.recordset.length === 0) return null;

            const usersActivities: UserActivity[] = foundUsersActivities.recordset.map(
                row => new UserActivity(
                    row.ActivityID,
                    row.UserID,
                    row.ActivityType,
                    row.Distance,
                    row.Duration,
                    row.CaloriesBurned,
                    row.AvgCadence,
                    row.AvgSpeed,
                    row.MaxSpeed,
                    row.ElevationGain,
                    row.Steps,
                    row.RegistryDate
                )
            );

            return usersActivities;
            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
    async getAllUsersAnthropometricData(): Promise<UserAnthropometric[] | null> {
        try {
            await database.connect();

            const foundUsersAnthData = await database.request()
            .query(`SELECT * FROM AnthropometricData`);

            await database.close();

            if(foundUsersAnthData.recordset.length === 0) return null;

            const usersAnthData: UserAnthropometric[] = foundUsersAnthData.recordset.map(
                row => new UserAnthropometric(
                    row.UserID,
                    row.Height,
                    row.Weight,
                    row.SMM,
                    row.FatMass,
                    row.BodyFatPercentage,
                    row.BMI,
                    row.WHR,
                    row.RegistryDate
                )
            );

            return usersAnthData;
            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
    async getAllGroups(): Promise<Group[] | null> {
        try {
            await database.connect();

            const foundGroups = await database.request()
            .query(`SELECT * FROM Groups`);

            await database.close();

            if(foundGroups.recordset.length === 0) return null;

            const groups: Group[] = foundGroups.recordset.map(
                row => new Group(
                    row.GroupID,
                    row.Name_
                )
            );

            return groups;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
    async getAllGroupsActivities(): Promise<GroupActivities[] | null> {
       try {
            await database.connect();

            const foundGroupsActivities = await database.request()
            .query(`SELECT * FROM GroupActivities`);

            await database.close();

            if(foundGroupsActivities.recordset.length === 0) return null;

            const groupsActivities: GroupActivities[] = foundGroupsActivities.recordset.map(
                row => new GroupActivities(
                    row.ActivityID,
                    row.GroupID,
                    row.ActivityType,
                    row.TotalDistance,
                    row.TotalDuration,
                    row.ReportDate
                )
            );

            return groupsActivities;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
async getGroupActivities(groupID: number): Promise<GroupActivities[] | null> {
       try {
            await database.connect();

            const foundGroupActivities = await database.request()
            .input('groupID', sql.Int, groupID)
            .query(`SELECT * FROM GroupActivities WHERE GroupID = @groupID`);

            await database.close();

            if(foundGroupActivities.recordset.length === 0) return null;

            const groupActivities: GroupActivities[] = foundGroupActivities.recordset.map(
                row => new GroupActivities(
                    row.ActivityID,
                    row.GroupID,
                    row.ActivityType,
                    row.TotalDistance,
                    row.TotalDuration,
                    row.ReportDate
                )
            );

            return groupActivities;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


}