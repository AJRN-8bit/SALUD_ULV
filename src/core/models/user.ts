// Base model for the multiple user types.
export interface IUser{
    readonly userUUID: string | undefined;
    readonly userCode: string | undefined;
    readonly firstname?: string;
    readonly surname?: string;
    readonly lastname?: string;
    readonly email?: string | undefined;
    // readonly roles?: string[];
    readonly createdAt?: Date | undefined;
}


export class User implements IUser{
    readonly userUUID: string | undefined;
    readonly userCode: string | undefined;
    readonly firstname?: string;
    readonly surname?: string;
    readonly lastname?: string;
    readonly email?: string | undefined;
    // readonly roles?: string[];
    readonly createdAt?: Date | undefined;

    constructor(
        userUUID: string,
        userCode: string,
        firstname: string,
        surname: string,
        lastname: string,
        email: string,
        // roles: string[],
        createdAt: Date,
    ) {
        this.userUUID = userUUID;
        this.userCode = userCode;
        this.firstname = firstname;
        this.surname = surname;
        this.lastname = lastname;
        this.email = email;
        // this.roles = roles;
        this.createdAt = createdAt;
    }
}


// User registry structure
export interface IUserRegistry{
    name: string;
    firstName: string; 
    lastName: string; 
    email: string;
    password: string;
}

export interface IUserInfoRegistry{
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