import type { IGroupRepo } from "../../../../core/application/repositories/repos/groups_repo.ts";
import { Group, type IGroup } from "../../../../core/models/groups.ts";
import type { IUser, User } from "../../../../core/models/user.ts";
import { GroupDTO } from "../../../DTOs/groupDTO.ts";
import { UserDTO } from "../../../DTOs/userDTO.ts";
import { database } from "../config.ts";
import sql from "mssql";


export default class GroupRepo implements IGroupRepo{

    async userExists(userUUID: string): Promise<boolean> {
        try {
            await database.connect();

            const result = await database.request()
                .input('userUUID', sql.NVarChar, userUUID)
                .query(`
                    SELECT CASE WHEN EXISTS 
                    (SELECT 1 FROM SaludULV.Users WHERE userUUID = @userUUID)
                    THEN 1
                    ELSE 0
                    END AS userExists
                `);
            
            const exists = result.recordset[0].userExists === 1;

            return exists;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    async groupExists(groupID: number): Promise<boolean> {
        try {
            await database.connect();

            const result = await database.request()
                .input('groupID', sql.Int, groupID)
                .query(`
                    SELECT CASE WHEN EXISTS 
                    (SELECT 1 FROM SaludULV.Departments WHERE GroupID = @groupID)
                    THEN 1
                    ELSE 0
                    END AS userExists
                `);
            
            const exists = result.recordset[0].userExists === 1;

            return exists;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }



    async getGroupsList(typeID: number): Promise<IGroup[] | null> {
        try {
            await database.connect();

            var result;

            if(typeID == 1) {
                result = await database.request()
                    .query(`SELECT * FROM SaludULV.Departments;`);
            }
            else if(typeID == 2){
                result = await database.request()
                    .query(`SELECT * FROM SaludULV.AcademicGroups;`);
            }
            else{
                return null;
            }


            if(result!.recordset.length === 0 || !result) return null;
            const rows = result.recordset;

            const data: Group[] = rows.map((row: any) => 
                            GroupDTO.fromMap(row).toDomain());

            return data;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    async addMember(groupID: number, userUUID: string): Promise<void> {
        try {
            await database.connect();

            await database.request()
                .input('userUUID', sql.UniqueIdentifier, userUUID)
                .input('groupID', sql.Int, groupID)
                .query(`INSERT INTO SaludULV.Members (UserUUID, GroupID) VALUES (@userUUID, @groupID);`);
            
            return;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }



    async getGroupMembers(groupID: number): Promise<IUser[] | null> {
        try {
            await database.connect();

            const results = await database.request()
                .input('groupID', sql.Int, groupID)
                .query(`
                    SELECT U.UserCode, U.Firstname, U.Surname, U.Lastname 
                    FROM 
                    SaludULV.Departments D
                    INNER JOIN SaludULV.Members M ON D.GroupID = M.GroupID
                    INNER JOIN SaludULV.Users U ON U.UserUUID = M.UserUUID
                    WHERE D.GroupID = @groupID
                    GROUP BY D.Name, U.UserCode, U.Firstname, U.Surname, U.Lastname
                `);

            const rows = results.recordset || results; 

            if (!rows || rows.length === 0) {
                return null;
            }


            const data: User[] = rows.map((rows: any) => UserDTO.fromMap(rows).toDomain());
            console.log(`In db group member: ${data}`)
            
            return data;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }



    async getGroupInfo(groupID: number): Promise<IGroup | null> {
        try {
            await database.connect();

            const result = await database.request()
                .input('groupID', sql.Int, groupID)
                .query(`SELECT * FROM SaludULV.Departments WHERE GroupID = @groupID;`);
            
            const row = result.recordset || result; 

            if (!row || row.length === 0) {
                return null;
            }

            console.log(row[0]['GroupID']);

            const data = GroupDTO.fromMap(row[0]).toDomain();
            // console.log(`Group info frommap in db: ${data.name}, ${data.description}, ${data.building}`);

            return data;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    async getLowerLevelGroups(): Promise<IGroup[] | null> {
        try {
            await database.connect();

            const result = await database.request()
                .query(`SELECT * FROM SaludULV.Departments`);
            
            const rows = result.recordset || result; 

            if (!rows || rows.length === 0) {
                return null;
            }

            // console.log(rows);

            const data: Group[] = rows.map((rows: any) => GroupDTO.fromMap(rows).toDomain());
            // console.log(`Group info frommap in db: ${data.name}, ${data.description}, ${data.building}`);

            return data;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }
}