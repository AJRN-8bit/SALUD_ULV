import { User } from "./user.ts";
export declare class Member extends User {
    readonly dateOfBirth: Date;
    readonly age: number;
    readonly gender: string;
    constructor(userUUID: string, userCode: string, firstname: string, surname: string, lastname: string, email: string, roles: string[], createdDate: Date, dateOfBirth: Date, age: number, gender: string);
}
export declare class MemberInfo {
    readonly userUUID: string;
    readonly dateOfBirth: Date;
    readonly age: number;
    readonly gender: string;
    constructor(userUUID: string, dateOfBirth: Date, age: number, gender: string);
}
//# sourceMappingURL=member.d.ts.map