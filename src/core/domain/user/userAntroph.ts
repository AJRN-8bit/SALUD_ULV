// User antrophometric data structure
export interface IUserAnthropometric {
    userID: number;
    height: number;
    weight: number;
    smm: number;
    fatMass: number;
    bodyFatPercentage: number;
    bmi: number;
    whr: number;
}

export class UserAnthropometric implements IUserAnthropometric{
    public readonly userID: number;
    public readonly height: number;
    public readonly weight: number;
    public readonly smm: number;
    public readonly fatMass: number;
    public readonly bodyFatPercentage: number;
    public readonly bmi: number;
    public readonly whr: number;
    public readonly registeredAt: Date;

    constructor(
        userID: number,
        height: number,
        weight: number,
        SMM: number,
        fatMass: number,
        bodyFatPercentage: number,
        BMI: number,
        WHR: number,
        registeredAt: Date
    ){
        this.userID = userID;
        this.height = height;
        this.weight = weight;
        this.smm = SMM;
        this.fatMass = fatMass;
        this.bodyFatPercentage = bodyFatPercentage;
        this.bmi = BMI;
        this.whr = WHR;
        this.registeredAt = registeredAt;
    }
}