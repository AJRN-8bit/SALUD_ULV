import type IUserRepository from "../../../core/application/ports/userRepository.ts";
import {database} from "../config/mssql.ts";
import sql from "mssql";
import {User, type IUserRegistry, type IUserInfoRegistry, type IUserLogin} from "../../../core/domain/user/user.ts";
import { UserActivity, type IUserActivityRegistry } from "../../../core/domain/user/userActivity.ts";
import { UserAnthropometric, type IUserAnthropometric } from "../../../core/domain/user/userAntroph.ts";


export default class SQLRepository implements IUserRepository{

// -----------------------------------------------------------------------------------------------------------------------------------------
    async registerUser(user: IUserRegistry): Promise<void> {
        try {
            await database.connect();

            await database.request()
            .input('userID', sql.Int, user.userID)
            .input('email', sql.NVarChar, user.email)
            .input('password', sql.NVarChar, user.password)
            .query('INSERT INTO Users (UserID, Email, Password_, CreatedAt) VALUES (@userID, @email, @password, GETDATE())');
            
            await database.close();
            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
    async registerUserInfo(user: IUserInfoRegistry): Promise<void>{
        try {
            await database.connect();

            await database.request()
            .input('userID', sql.Int, user.userID)
            .input('name', sql.NVarChar, user.name)
            .input('firstName', sql.NVarChar, user.firstName)
            .input('lastName', sql.NVarChar, user.lastName)
            .input('birthDate', sql.Date, user.birthDate)
            .input('age', sql.Int, user.age)
            .input('gender', sql.NVarChar, user.gender)
            .query('UPDATE Users SET Name_ = @name, Firstname = @firstName, Lastname = @lastName, BirthDate = @birthDate, Age = @age, Gender = @gender WHERE UserID = @userID');

            await database.close();

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }

    
// -----------------------------------------------------------------------------------------------------------------------------------------
    async loginUser(user: IUserLogin): Promise<void> {
        try {
            await database.connect();

            const foundUser = await database.request()
            .input('email', sql.NVarChar, user.email)
            .query('SELECT Password_ FROM Users WHERE Email = @email');

            await database.close();

            const foundPassword = foundUser.recordset[0].Password_;
            if(foundPassword == null || foundPassword == 'undefined'){
                throw new Error("User not found");
            }

            const passwordMatch = await User.comparePassword(user.password, foundPassword);
            if(!passwordMatch){
                throw new Error("Invalid password");
            } 

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    } 




// -----------------------------------------------------------------------------------------------------------------------------------------
    async getUserProfile(userID: number): Promise<User | null> {
        try {
            await database.connect();

            const foundUser = await database.request()
            .input('userID', sql.Int, userID)
            .query('SELECT * FROM Users WHERE UserID = @userID');

            await database.close();

            const result = foundUser.recordset[0];

            if(result == null || result == 'undefined') {return null}

            return new User(
                result.UserID,
                result.Name,
                result.FirstName,
                result.LastName,
                result.Email,
                result.Password,
                result.BirthDate,
                result.Age,
                result.Gender,
                result.CreatedAt
            );
            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }



// -----------------------------------------------------------------------------------------------------------------------------------------
    async registerUserAnthropometricData(userAnthropometric: IUserAnthropometric): Promise<void> {
        try {
            await database.connect();

            const antrophData = await database.request()
            .input('userID', sql.Int, userAnthropometric.userID)
            .input('height', sql.Decimal, userAnthropometric.height)
            .input('weight', sql.Decimal, userAnthropometric.weight)
            .input('smm', sql.Decimal, userAnthropometric.smm)
            .input('fatMass', sql.Decimal, userAnthropometric.fatMass)
            .input('bodyFatPercentage', sql.Decimal, userAnthropometric.bodyFatPercentage)
            .input('bmi', sql.Decimal, userAnthropometric.bmi)
            .input('whr', sql.Decimal, userAnthropometric.whr)
            .query('INSERT INTO AnthropometricData (UserID, Height, Weight_, SMM, FatMass, BodyFatPercentage, BMI, WHR, RegistryDate) VALUES (@userID, @height, @weight, @smm, @fatMass, @bodyFatPercentage, @bmi, @whr, GETDATE())');

            await database.close();

            // const result = antrophData.recordset[0];
            // console.log(result);

            // return new UserAnthropometric(
            //     result.UserID,
            //     result.Height,
            //     result.Weight_,
            //     result.SMM,
            //     result.FatMass,
            //     result.BodyFatPercentage,
            //     result.BMI,
            //     result.WHR,
            //     result.RegistryDate    
            // );
            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
    async getAllUserAntrophometricData(userID: number): Promise<UserAnthropometric[] | null> {
        try {
            await database.connect();

            const anthData = await database.request()
            .input('userID', sql.Int, userID)
            .query('SELECT * FROM AnthropometricData WHERE UserID = @userID ORDER BY RegistryDate DESC');

            await database.close();

            if(anthData.recordset.length === 0) {return null}

            const userAnthData: UserAnthropometric[] = anthData.recordset.map(
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

            return userAnthData;


        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }



// ON STANDBY, time value error
// -----------------------------------------------------------------------------------------------------------------------------------------
    async registerUserActivity(userActivity: IUserActivityRegistry): Promise<void> {
        try {
            const duration = await UserActivity.convertToTime(userActivity.duration);
            console.log(duration);

            await database.connect();
    
            const activity = await database.request()
            .input('userID', sql.Int , userActivity.userID)
            .input('activityType', sql.NVarChar, userActivity.activityType)
            .input('distance', sql.Decimal, userActivity.distance)
            .input('duration', sql.Time, new Date().setHours(1,4,5,12))
            .input('caloriesBurned', sql.Int, userActivity.caloriesBurned)
            .input('avgCadence', sql.Decimal, userActivity.avgCadence)
            .input('avgSpeed', sql.Decimal, userActivity.avgSpeed)
            .input('maxSpeed', sql.Decimal, userActivity.maxSpeed)
            .input('elevationGain', sql.Decimal, userActivity.elevationGain)
            .input('steps', sql.Int, userActivity.steps)
            .query('INSERT INTO Activities (UserID, ActivityType, Distance, Duration, CaloriesBurned, AvgCadence, AvgSpeed, MaxSpeed, ElevationGain, Steps, RegistryDate) VALUES (@userID, @activityType, @distance, @duration, @caloriesBurned, @avgCadence, @avgSpeed, @maxSpeed, @elevationGain, @steps, GETDATE())');
    
            await database.close();
    
            // const result = activity.recordset[0];
    
            // return new UserActivity(
            //     result.UserID,
            //     result.ActivityType,
            //     result.Distance,
            //     result.Duration,
            //     result.CaloriesBurned,
            //     result.AvgCadence,
            //     result.AvgSpeed,
            //     result.MaxSpeed,
            //     result.ElevationGain,
            //     result.Steps,
            //     result.CreatedAt
            // );
            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }


// -----------------------------------------------------------------------------------------------------------------------------------------
    async getAllUserActivities(userID: number): Promise<UserActivity[] | null> {
        try {
            await database.connect();

            const activities = await database.request()
            .input('userID', sql.Int, userID)
            .query('SELECT * FROM Activities WHERE UserID = @userID ORDER BY RegistryDate DESC');

            await database.close();

            if(activities.recordset.length === 0) {return null}

            const userActivities: UserActivity[] = activities.recordset.map(
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

            return userActivities;

        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
        
}   


// -----------------------------------------------------------------------------------------------------------------------------------------
    async deleteUserActivity(userID: number, activityID: number): Promise<void> {
        try {
            await database.connect();

            const deletedActivity = await database.request()
            .input('userID', sql.Int, userID)
            .input('activityID', sql.Int, activityID)
            .query('DELETE FROM Activities WHERE UserID = @userID AND ActivityID = @activityID');

            await database.close();

            
        } catch (error) {
            console.log(error);
            throw new Error(`${error}`);
        }
    }

}
