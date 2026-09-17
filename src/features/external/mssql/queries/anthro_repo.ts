import type { IAnthroRepo } from "../../../../core/application/repositories/repos/anthro_repo.ts";
import { Anthropometric } from "../../../../core/models/antropometric.ts";
import sql from "mssql";
import { database } from "../config.ts";
import { AnthropometricDto } from "../../../DTOs/anthropometicDto.ts";


export default class AnthroRepo implements IAnthroRepo {

    async save(data: Anthropometric): Promise<void> {
        try {
            await database.connect();

            await database.request()
            .input('anthroID', sql.UniqueIdentifier, data.anthropometricID)
            .input('userUUID', sql.UniqueIdentifier, data.userUUID)
            .input('height', sql.Decimal(5, 2), data.height)
            .input('weight', sql.Decimal(5, 2), data.weight)
            .input('smm', sql.Decimal(5, 2), data.smm)
            .input('fatMass', sql.Decimal(5, 2), data.fatMass)
            .input('bodyFatPercentage', sql.Decimal(5, 2), data.bodyFatPercentage)
            .input('bmi', sql.Decimal(5, 2), data.bmi)
            .input('whr', sql.Decimal(5, 2), data.whr)
            .input('registeredAt', sql.DateTime, data.registeredAt)

            .query('INSERT INTO SaludULV.Anthropometrics (AnthropometricID, UserUUID, Height, Weight_, SMM, FatMass, BodyFatPercentage, BMI, WHR, RegisteredAt) VALUES (@anthroID, @userUUID, @height, @weight, @smm, @fatMass, @bodyFatPercentage, @bmi, @whr, @registeredAt)');
    
            // console.log("Data saved");
            
        } catch (error) {
            throw new Error(`${error}`);
        } finally{
            await database.close();
        }
    }


    
    async getAllData(): Promise<Anthropometric[] | null> {
        try {
            await database.connect();

            const results = await database.query(
            'SELECT u.UserCode, a.Height, a.Weight_, a.SMM, a.FatMass, a.BodyFatPercentage, a.BMI, a.WHR, a.RegisteredAt FROM SaludULV.Anthropometrics a INNER JOIN SaludULV.Users u ON u.UserUUID = a.UserUUID'
            )

            const rows = results.recordset || results; 

            if (!rows || rows.length === 0) {
                return null;
            }


            const data: Anthropometric[] = rows.map((row: any) => 
                AnthropometricDto.fromMap(row).toDomain());

            // console.log(`In db: ${data?.toString()}`);

            return data;
            
        } catch (error) {
            throw new Error(`${error}`);
        } finally{
            await database.close();
        }
    }


    async getAllByUserCode(userID: String): Promise<Anthropometric[] | null> {
        try {
            await database.connect();

            const results = await database.request()
            .input('userCode', sql.NVarChar, userID)
            .query(
                `SELECT u.UserCode, a.Height, a.Weight_, a.SMM, a.FatMass, a.BodyFatPercentage, a.BMI, a.WHR, a.RegisteredAt 
                FROM SaludULV.Anthropometrics a 
                INNER JOIN SaludULV.Users u ON u.UserUUID = a.UserUUID 
                WHERE u.UserCode = @userCode`
            );

            const rows = results.recordset || results; 

            if (!rows || rows.length === 0) {
                return null;
            }


            const data: Anthropometric[] = rows.map((row: any) => 
                AnthropometricDto.fromMap(row).toDomain());

            // console.log(`In db: ${data?.toString()}`);

            return data;
            
        } catch (error) {
            throw new Error(`${error}`);
        } finally{
            await database.close();
        }
    }


    async getAllByCodeAndField(userCode: String, field: String): Promise<Anthropometric[] | null> {
    return null;
    }
}