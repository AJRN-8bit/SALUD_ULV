import { Anthropometric } from "../../core/models/antropometric.ts";
export declare class AnthropometricDto {
    anthropometricID: string | undefined;
    userID: string | undefined;
    height: number;
    weight: number;
    smm: number;
    fatMass: number;
    bodyFatPercentage: number;
    bmi: number;
    whr: number;
    registeredAt: Date;
    constructor(data: AnthropometricDto);
    static fromDomain(anthropometric: Anthropometric): AnthropometricDto;
    static fromMap(row: Record<string, any>): AnthropometricDto;
    static fromJson(json: Record<string, any>): AnthropometricDto;
    toDomain(): Anthropometric;
    toJson(): Record<string, any>;
}
//# sourceMappingURL=anthropometicDto.d.ts.map