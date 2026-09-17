import sql from "mssql";
import { database } from "../config.ts";
import { User, type IUser } from "../../../../core/models/user.ts";
import type { IAuthRepo } from "../../../../core/application/repositories/repos/auth_repo.ts";
import type { MemberInfo } from "../../../../core/models/member.ts";


export default class AuthRepository implements IAuthRepo {

    // -----------------------------------------------------------------------------------------------------------------------------------------
    async registerMember(user: User, password: string): Promise<void> {
        try {
            await database.connect();

            await database.request()
                .input('userUUID', sql.UniqueIdentifier, user.userUUID)
                .input('userCode', sql.NVarChar, user.userCode)
                .input('firstname', sql.NVarChar, user.firstname)
                .input('surname', sql.NVarChar, user.surname)
                .input('lastname', sql.NVarChar, user.lastname)
                .input('email', sql.NVarChar, user.email)
                .input('password', sql.NVarChar, password)
                // .input('role', sql.NVarChar, user.role)
                .input('createdAt', sql.DateTime, user.createdAt)

                .query(`INSERT INTO SaludULV.Users 
                (UserUUID, UserCode, Firstname, Surname, Lastname, Email, PasswordHash, createdAt) 
                VALUES (@userUUID, @userCode, @firstname, @surname, @lastname, @email, @password, @createdAt)`);


        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    // -----------------------------------------------------------------------------------------------------------------------------------------
    async login(input: string): Promise<{ user: IUser, passwordHash: string } | null> {
        try {
            await database.connect();

            const isEmail = input.includes('@');
            const column = isEmail ? 'Email' : 'UserCode';

            const result = await database.request()
                .input('input', sql.NVarChar, input)
                .query(`SELECT * FROM SaludULV.Users WHERE ${column} = @input`);

            if (result.recordset.length === 0) { return null }

            const row = result.recordset[0];

            const user = new User(
                row.UserUUID,
                row.UserCode,
                row.Firstname,
                row.Surname,
                row.Lastname,
                row.Email,
                row.CreatedAt
            )

            return {user: user, passwordHash: row.PasswordHash };


        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }



    async setUserRole(userUUID: string): Promise<void> {
        try {
            await database.connect();

            await database.request()
                .input('userUUID', sql.UniqueIdentifier, userUUID)
                .input('role', sql.TinyInt, 2) // member

                .query(`INSERT INTO SaludULV.UserRoles 
                (UserUUID, RoleID) 
                VALUES (@userUUID, @role)`);

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    async getUserRoles(userUUID: string): Promise<string[] | null> {
        try {
            // console.log(`In db getting roles: ${userUUID}`)
            await database.connect();
            // console.log(userUUID);

            const result = await database.request()
                .input('userUUID', sql.UniqueIdentifier, userUUID)
                .query(`
                SELECT r.Name
                FROM SaludULV.Roles r
                INNER JOIN SaludULV.UserRoles ur ON ur.RoleID = r.RoleID
                WHERE ur.UserUUID = @userUUID
                ORDER BY r.Name
            `);

            // console.log(`Roles in db: ${result.recordset}`)

            if (result.recordset.length === 0) { return null }

            const roles = result.recordset.map((row: { Name: string }) => row.Name);
            // console.log(`Roles list: ${roles}`)
            return roles;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    async registerMemberInfo(info: MemberInfo): Promise<void> {

    }



    async setMemberTypeID(userUUID: string, type: number): Promise<void> {
        try {
            await database.connect();

            await database.request()
                .input('userUUID', sql.NVarChar, userUUID)
                .input('typeID', sql.SmallInt, type)
                .query(`
                    INSERT INTO SaludULV.Members (UserUUID, TypeID) 
                    VALUES (@userUUID, @typeID);
                    `);

            return;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    async getMemberType(userUUID: string): Promise<string | null> {
        try {
            await database.connect();

            const result = await database.request()
                .input('userUUID', sql.UniqueIdentifier, userUUID)
                .query(`
                    SELECT TypeID FROM SaludULV.Members 
                    WHERE UserUUID = @userUUID
                `);


            if (result.recordset.length === 0) { return null }

            const type = result.recordset[0]?.TypeID ?? null;

            return type;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    async getMemberGroupID(userUUID: string): Promise<number | null> {
        try {
            await database.connect();

            

            const result = await database.request()
                .input('userUUID', sql.UniqueIdentifier, userUUID)
                .query(`
                    SELECT T.Name FROM SaludULV.MemberType T
                    INNER JOIN SaludULV.Members M ON M.TypeID = T.TypeID
                    WHERE M.UserUUID = @userUUID;
                `);

            
                console.log(`In db auth group id`);
            if (result.recordset.length === 0) { return null }

            const groupID = result.recordset[0].GroupID;
            console.log(`In db auth group id: ${groupID}`);
            return groupID;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }




    // -----------------------------------------------------------------------------------------------------------------------------------------
    async findByEmail(email: string): Promise<boolean | null> {
        try {
            await database.connect();

            const result = await database.request()
                .input('email', sql.NVarChar, email)
                .query(`
                SELECT CASE WHEN EXISTS 
                (SELECT 1 FROM SaludULV.Users WHERE Email = @email)
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


    // -----------------------------------------------------------------------------------------------------------------------------------------
    async findByCode(code: string): Promise<boolean | null> {
        try {
            await database.connect();
            console.log(`In DB find by code: ${code}`);

            const result = await database.request()
                .input('userCode', sql.NVarChar, code)
                .query(`
                    SELECT CASE WHEN EXISTS 
                    (SELECT 1 FROM SaludULV.Users WHERE userCode = @userCode)
                    THEN 1
                    ELSE 0
                    END AS userExists
                `);

            const exists = result.recordset[0].userExists === 1;
            console.log(`In DB user exists: ${exists}`);

            return exists;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }



    // -----------------------------------------------------------------------------------------------------------------------------------------
    async changePassword(email: string, newPw: string): Promise<boolean | null> {
        try {
            await database.connect();

            await database.request()
                .input('email', sql.NVarChar, email)
                .input('newPw', sql.NVarChar, newPw)
                .query('UPDATE SaludULV.Users SET PasswordHash = @newPw WHERE Email = @email');

            return true;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }


    // -----------------------------------------------------------------------------------------------------------------------------------------
    async deleteAccount(email: string): Promise<void> {
        try {
            await database.connect();

            await database.request()
                .input('email', sql.NVarChar, email)
                .query('DELETE FROM SaludULV.Users WHERE Email = @email');

            return;

        } catch (error) {
            throw new Error(`${error}`);
        } finally {
            await database.close();
        }
    }
}



