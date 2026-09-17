import { Anthropometric } from "../../core/models/antropometric.ts";

export class AnthropometricDto {
    anthropometricID: string | undefined;
    userID: string | undefined;  // Can be UserUUID and Code
    height!: number;
    weight!: number;
    smm!: number;
    fatMass!: number;
    bodyFatPercentage!: number;
    bmi!: number;
    whr!: number;
    registeredAt!: Date;

    constructor(data: AnthropometricDto) {
        this.anthropometricID = data.anthropometricID;
        this.userID = data.userID;
        this.height = data.height;
        this.weight = data.weight;
        this.smm = data.smm;
        this.fatMass = data.fatMass;
        this.bodyFatPercentage = data.bodyFatPercentage;
        this.bmi = data.bmi;
        this.whr = data.whr;
        this.registeredAt = data.registeredAt;
    }

    static fromDomain(anthropometric: Anthropometric): AnthropometricDto {
        // Fix: Wrap the data inside an object {}
        return new AnthropometricDto({
            userID: anthropometric.userUUID,
            height: anthropometric.height,
            weight: anthropometric.weight,
            smm: anthropometric.smm,
            fatMass: anthropometric.fatMass,
            bodyFatPercentage: anthropometric.bodyFatPercentage,
            bmi: anthropometric.bmi,
            whr: anthropometric.whr,
            registeredAt: anthropometric.registeredAt,
        } as AnthropometricDto); // Cast ensures it satisfies the class type shape
    }

    // Admin view
    static fromMap(row: Record<string, any>): AnthropometricDto {
        return new AnthropometricDto({
            userID: row['UserCode'],
            height: Number(row['Height']),
            weight: Number(row['Weight_']),
            smm: Number(row['SMM']),
            fatMass: Number(row['FatMass']),
            bodyFatPercentage: Number(row['BodyFatPercentage']),
            bmi: Number(row['BMI']),
            whr: Number(row['WHR']),
            
            // MSSQL DATETIME fields are usually automatically parsed into JS Date objects 
            // by the driver, but wrapping it in `new Date()` acts as a safe guard.
            registeredAt: row['RegisteredAt'] || row['RegisteredAt'] 
                ? new Date(row['RegisteredAt'] ?? row['RegisteredAt']) 
                : new Date(),
        } as AnthropometricDto);
    }


    static fromJson(json: Record<string, any>): AnthropometricDto {
        // Fix: Wrap the data inside an object {}
        return new AnthropometricDto({
            anthropometricID: json['anthropometricID'],
            userID: json['userUUID'],
            height: json['height'],
            weight: json['weight'],
            smm: json['smm'],
            fatMass: json['fatMass'],
            bodyFatPercentage: json['bodyFatPercentage'],
            bmi: json['bmi'],
            whr: json['whr'],
            registeredAt: json['registeredAt'],
        } as AnthropometricDto);
    }

    toDomain(): Anthropometric {
        // Assuming Anthropometric domain model still uses positional parameters in its constructor
        return new Anthropometric(
            this.anthropometricID!, // Avoid generating a brand new UUID if one already exists
            this.userID!,
            this.height,
            this.weight,
            this.smm,
            this.fatMass,
            this.bodyFatPercentage,
            this.bmi,
            this.whr,
            this.registeredAt,
        );
    }

    toJson(): Record<string, any> {
        return {
            userCode: this.userID,
            height: this.height,
            weight: this.weight,
            smm: this.smm,
            fatMass: this.fatMass,
            bodyFatPercentage: this.bodyFatPercentage,
            bmi: this.bmi,
            whr: this.whr,
            registeredAt: this.registeredAt.toISOString(),
        };
    }
}