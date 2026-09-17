// import sql from "mssql";
// import {database} from "../config.ts";
// import type { IUserAnthropometric } from "../../../../../../core/userAnthropometric/models/iuserAntroph.ts";
// import type { IRegisterAnthropometricOutPort } from "../../../../../../core/userAnthropometric/ports/secondary/anthtopometricOutPorts.ts";


// export default class AnthropometricSQLRepository implements IRegisterAnthropometricOutPort{


// // -----------------------------------------------------------------------------------------------------------------------------------------
//     async saveData(userAnthropometric: IUserAnthropometric): Promise<void> {
//         try {
//             await database.connect();
//             console.log("In SQL db");

//             await database.request()
//             .input('userID', sql.Int, userAnthropometric.userID)
//             .input('height', sql.Decimal, userAnthropometric.height)
//             .input('weight', sql.Decimal, userAnthropometric.weight)
//             .input('smm', sql.Decimal, userAnthropometric.smm)
//             .input('fatMass', sql.Decimal, userAnthropometric.fatMass)
//             .input('bodyFatPercentage', sql.Decimal, userAnthropometric.bodyFatPercentage)
//             .input('bmi', sql.Decimal, userAnthropometric.bmi)
//             .input('whr', sql.Decimal, userAnthropometric.whr)
//             .query('INSERT INTO AnthropometricData (UserID, Height, Weight_, SMM, FatMass, BodyFatPercentage, BMI, WHR, RegistryDate) VALUES (@userID, @height, @weight, @smm, @fatMass, @bodyFatPercentage, @bmi, @whr, GETDATE())');

            
//         } catch (error) {
//             throw new Error(`${error}`);
//         } finally{
//             await database.close();
//         }
//     }


// // -----------------------------------------------------------------------------------------------------------------------------------------
//  async findUserByID(userID: number): Promise<Boolean | null> {
//     try {
//         await database.connect();

//         const foundUser = await database.request()
//         .input('userID', sql.Int, userID)
//         .query('SELECT UserID FROM Users WHERE UserID = @userID');

//         await database.close();

//         if(foundUser.recordset.length === 0) {return null}

//         return true;
        
//         } catch (error) {
//             throw new Error(`${error}`);
//         } finally{
//             await database.close();
//         }
//     }
// }


// // import sql from "mssql";
// // import {database} from "../config.ts";
// // import type { IUserAnthropometric } from "../../../../../../core/userAnthropometric/models/iuserAntroph.ts";
// // import type { IRegisterAnthropometricOutPort } from "../../../../../../core/userAnthropometric/ports/secondary/anthtopometricOutPorts.ts";


// // export default class AnthropometricSQLRepository implements IRegisterAnthropometricOutPort{


// // // -----------------------------------------------------------------------------------------------------------------------------------------
// //     async saveData(userAnthropometric: IUserAnthropometric): Promise<void> {
// //         try {
// //             await database.connect();
// //             console.log("In SQL db");

// //             await database.request()
// //             .input('userID', sql.Int, userAnthropometric.userID)
// //             .input('height', sql.Decimal, userAnthropometric.height)
// //             .input('weight', sql.Decimal, userAnthropometric.weight)
// //             .input('smm', sql.Decimal, userAnthropometric.smm)
// //             .input('fatMass', sql.Decimal, userAnthropometric.fatMass)
// //             .input('bodyFatPercentage', sql.Decimal, userAnthropometric.bodyFatPercentage)
// //             .input('bmi', sql.Decimal, userAnthropometric.bmi)
// //             .input('whr', sql.Decimal, userAnthropometric.whr)
// //             .query('INSERT INTO AnthropometricData (UserID, Height, Weight_, SMM, FatMass, BodyFatPercentage, BMI, WHR, RegistryDate) VALUES (@userID, @height, @weight, @smm, @fatMass, @bodyFatPercentage, @bmi, @whr, GETDATE())');

            
// //         } catch (error) {
// //             throw new Error(`${error}`);
// //         } finally{
// //             await database.close();
// //         }
// //     }


// // // -----------------------------------------------------------------------------------------------------------------------------------------
// //  async findUserByID(userID: number): Promise<Boolean | null> {
// //     try {
// //         await database.connect();

// //         const foundUser = await database.request()
// //         .input('userID', sql.Int, userID)
// //         .query('SELECT UserID FROM Users WHERE UserID = @userID');

// //         await database.close();

// //         if(foundUser.recordset.length === 0) {return null}

// //         return true;
        
// //         } catch (error) {
// //             throw new Error(`${error}`);
// //         } finally{
// //             await database.close();
// //         }
// //     }
// // }

