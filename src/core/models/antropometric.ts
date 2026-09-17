
export class Anthropometric {
    readonly anthropometricID: string | undefined;
    readonly userUUID: string | undefined;
    readonly height: number;
    readonly weight: number;
    readonly smm: number;
    readonly fatMass: number;
    readonly bodyFatPercentage: number;
    readonly bmi: number;
    readonly whr: number;
    readonly registeredAt: Date | undefined;

    constructor(
        anthropometricID: string,
        userUUID: string,
        height: number,
        weight: number,
        smm: number,
        fatMass: number,
        bodyFatPercentage: number,
        bmi: number,
        whr: number,
        registeredAt: Date,
    ) {
        this.anthropometricID = anthropometricID;
        this.userUUID = userUUID;
        this.height = height;
        this.weight = weight;
        this.smm = smm;
        this.fatMass = fatMass;
        this.bodyFatPercentage = bodyFatPercentage;
        this.bmi = bmi;
        this.whr = whr;
        this.registeredAt = registeredAt;
    }
}