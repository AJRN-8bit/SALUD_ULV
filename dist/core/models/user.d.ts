export interface IUser {
    readonly userUUID: string | undefined;
    readonly userCode: string | undefined;
    readonly firstname?: string;
    readonly surname?: string;
    readonly lastname?: string;
    readonly email?: string | undefined;
    readonly createdAt?: Date | undefined;
}
export declare class User implements IUser {
    readonly userUUID: string | undefined;
    readonly userCode: string | undefined;
    readonly firstname?: string;
    readonly surname?: string;
    readonly lastname?: string;
    readonly email?: string | undefined;
    readonly createdAt?: Date | undefined;
    constructor(userUUID: string, userCode: string, firstname: string, surname: string, lastname: string, email: string, createdAt: Date);
}
export interface IUserRegistry {
    name: string;
    firstName: string;
    lastName: string;
    email: string;
    password: string;
}
export interface IUserInfoRegistry {
    userID: number;
    name: string;
    firstName: string;
    lastName: string;
    birthDate: Date;
    age: number;
    gender: string;
}
export interface IUserLogin {
    email: string;
    password: string;
}
//# sourceMappingURL=user.d.ts.map