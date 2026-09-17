import { User } from "./user.ts";

export class Member extends User{
    readonly dateOfBirth: Date;
    readonly age: number;
    readonly gender: string;

    constructor(
        userUUID: string,
        userCode: string,
        firstname: string,
        surname: string,
        lastname: string,
        email: string,
        roles: string[],
        createdDate: Date,
        dateOfBirth: Date,
        age: number,
        gender: string
    ) {
        super(userUUID, userCode, firstname, surname, lastname, email, createdDate);
        this.dateOfBirth = dateOfBirth;
        this.age = age;
        this.gender = gender;
    }
}


export class MemberInfo {
    readonly userUUID: string;
    readonly dateOfBirth: Date;
    readonly age: number;
    readonly gender: string;

    constructor(
        userUUID: string,
        dateOfBirth: Date,
        age: number,
        gender: string
    ) {
        this.userUUID = userUUID;
        this.dateOfBirth = dateOfBirth;
        this.age = age;
        this.gender = gender;
    }
}
